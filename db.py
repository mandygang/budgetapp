import os
import json
import sqlite3
from datetime import datetime
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

# user_table = db.Table('users', db.Model.metadata,
#                     db.Column('entry_id', db.Integer, db.ForeignKey('entry.id')),
#                     db.Column('goal_id', db.Integer, db.ForeignKey('goal.id'))
#                     )

tag_table = db.Table('tags', db.Model.metadata,
                    db.Column('tag_id', db.Integer,db.ForeignKey('tag.id')),
                    db.Column('entry_id', db.Integer,db.ForeignKey('entry.id'))
                    )

# instructor_table = db.Table('instructors', db.Model.metadata,
#                              db.Column('course_id', db.Integer, db.ForeignKey('course.id')),
#                              db.Column('instructor_id', db.Integer, db.ForeignKey('user.id'))
#                     )
#
# student_table = db.Table('students', db.Model.metadata,
#                              db.Column('course_id', db.Integer, db.ForeignKey('course.id')),
#                              db.Column('student_id', db.Integer, db.ForeignKey('user.id'))
                    # )

# General User information
class User(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True)
    firstName = db.Column(db.String, nullable = False)
    lastName = db.Column(db.String, nullable = False)
    email = db.Column(db.String, nullable = False)
    phoneNum = db.Column(db.String, nullable = True)
    # add table information for spending
    entries = db.relationship('Entry', cascade='delete')
    goals = db.relationship('Goal', cascade='delete')

    def __init__(self, **kwargs):
        self.firstName = kwargs.get('firstName', '')
        self.lastName = kwargs.get('lastName', '')
        self.email = kwargs.get('email', '')
        self.phoneNum = kwargs.get('phoneNum', '')
        self.entries = []
        self.goals = []

    def serialize(self):
        return {
            'id': self.id,
            'firstName': self.firstName,
            'lastName': self.lastName,
            'email': self.email,
            'phoneNum': self.phoneNum,
            'entries': [s.serialize() for s in self.entries],
            'goals': [s.serialize() for s in self.goals],
        }

# Spending entry either Expenses or Income
# Need to link to the user
class Entry(db.Model):
    __tablename__ = 'entry'
    id = db.Column(db.Integer, primary_key = True)
    title = db.Column(db.String, nullable = False)          # Title of the spending Entry
    type = db.Column(db.String, nullable = False)           # Type of spending [EXPENSE, INCOME]
    amount = db.Column(db.Float, nullable = False)          # The amount spent, Do we assume USD or BRB??
    description = db.Column(db.String, nullable = True)     # Optional description of the entry
    date = db.Column(db.Integer, nullable = False)          # Date the purchase was made (helps with display?)

    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable = False)
    #tag = db.Column()                                 #IDK how to do this
    tags = db.relationship('Tag', secondary = tag_table, back_populates='entries')

    def __init__(self, **kwargs):
        self.title = kwargs.get('title', '')
        self.type = kwargs.get('type', '')
        self.amount = kwargs.get('amount', '')
        self.description = kwargs.get('description', '')
        self.date = kwargs.get('date', '')
        self.user_id = kwargs.get('user_id', '')

    def serialize(self):
        return {
            'id': self.id,
            'title': self.title,
            'type': self.type,
            'amount': self.amount,
            'description': self.description,
            'date': self.date
        }


# Optional decision to include the tag in your spending entry
class Tag(db.Model):
    __tablename__ = 'tag'
    id = db.Column(db.Integer, primary_key = True)
    # name of the category [food, clothing, transport, entertainment, groceries, bills, miscellaneous, spending(Include for goal)]
    name = db.Column(db.name, nullable = False)
    entries = db.relationship('Entry', secondary = tag_table, back_populates='tags')
    # Link to spending Entry

    def __init__(self, **kwargs):
        self.name = kwargs.get('name', '')

    def serialize(self):
        return {
            'id': self.id,
            'name': self.name
        }


# including the goal in your monthly spending tracking??
class Goal(db.Model):
    __tablename__ = 'goal'
    id = db.Column(db.Integer, primary_key = True)
    title = db.Column(db.String, nullable = False)
    limit = db.Column(db.Integer, nullable = False)         #your limit for the month
    length = db.Column(db.Integer, nullable = False)        #Default: Month; [week, month, year]
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable = False)
    #link to goal to a specific tag, optional (could be for just the spending period)


    def __init__(self, **kwargs):
        self.title = kwargs.get('title', '')
        self.limit = kwargs.get('limit', '')
        self.length = kwargs.get('length', '')
        self.user_id = kwargs.get('user_id', '')

    def serialize(self):
        return{
            'id': self.id,
            'title': self.title,
            'limit': self.limit,
            'length': self.length
        }
