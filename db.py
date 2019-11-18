import os
import json
import sqlite3
from datetime import datetime
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

instructor_table = db.Table('instructors', db.Model.metadata,
                             db.Column('course_id', db.Integer, db.ForeignKey('course.id')),
                             db.Column('instructor_id', db.Integer, db.ForeignKey('user.id'))
                    )

student_table = db.Table('students', db.Model.metadata,
                             db.Column('course_id', db.Integer, db.ForeignKey('course.id')),
                             db.Column('student_id', db.Integer, db.ForeignKey('user.id'))
                    )

class Course(db.Model):
    __tablename__ = "course"
    id = db.Column(db.Integer, primary_key=True)
    code = db.Column(db.String, nullable = False)
    name = db.Column(db.String, nullable = False)
    assignments = db.relationship('Assignment', cascade='delete')
    instructors = db.relationship('User', secondary = instructor_table, back_populates='instructor_courses')
    students = db.relationship('User', secondary = student_table, back_populates='student_courses')

    def __init__(self, **kwargs):
        self.code = kwargs.get('code', '')
        self.name = kwargs.get('name', '')
        self.assignments = []

    def serialize(self):
        return {
            'id': self.id,
            'code': self.code,
            'name': self.name,
            'assignments': [s.serialize() for s in self.assignments],
            'instructors': [i.serialize2() for i in self.instructors],
            'students': [s.serialize2() for s in self.students]
        }
    def serialize2(self):
        return {
            'id': self.id,
            'code': self.code,
            'name': self.name
        }
    
class Assignment(db.Model):
    __tablename__ = 'assignment'
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String, nullable = False)
    due_date = db.Column(db.Integer, nullable = False)
    course_id = db.Column(db.Integer, db.ForeignKey('course.id'), nullable = False)
    

    def __init__(self, **kwargs):
        self.title = kwargs.get('title', '')
        self.due_date = kwargs.get('due_date', '')
        self.course_id = kwargs.get('course_id', '')

    def serialize(self):
        return {
            'id': self.id,
            'title': self.title,
            'due_date': self.due_date
        }

class User(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable = False)
    netid = db.Column(db.String, nullable = False)
    flag = False
    instructor_courses = db.relationship('Course', secondary=instructor_table, back_populates='instructors')
    student_courses = db.relationship('Course', secondary=student_table, back_populates='students')
    
    def __init__(self, **kwargs):
        self.name = kwargs.get('name', '')
        self.netid = kwargs.get('netid', '')
        
    def serialize(self):
        courses = []
        for c in self.instructor_courses:
            courses.append(c.serialize2())
        for c in self.student_courses:
            courses.append(c.serialize2())
        return {
            'id': self.id,
            'name': self.name,
            'netid': self.netid,
            'courses': courses
        }
    def serialize2(self):
        return {
            'id': self.id,
            'name': self.name,
            'netid': self.netid
        }
