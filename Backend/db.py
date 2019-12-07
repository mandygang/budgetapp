import os
import json
import bcrypt
import hashlib
import sqlite3
import datetime
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

# user_table = db.Table('users', db.Model.metadata,
#                     db.Column('expense_id', db.Integer, db.ForeignKey('expense.id')),
#                     db.Column('budget_id', db.Integer, db.ForeignKey('budget.id'))
#                     )
tag_table = db.Table('tags', db.Model.metadata,
                    db.Column('tag_id', db.Integer,db.ForeignKey('tag.id')),
                    db.Column('expense_id', db.Integer,db.ForeignKey('expense.id'))
                    )

# General User information
class User(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True)
    firstName = db.Column(db.String, nullable = False)
    lastName = db.Column(db.String, nullable = False)
    # email = db.Column(db.String, nullable = False)
    # phoneNum = db.Column(db.String, nullable = True)

    # tables
    expenses = db.relationship('Expense', cascade='delete')
    budgets = db.relationship('Budget', cascade='delete')

    # User information
    email = db.Column(db.String, nullable=False, unique=True)
    password_digest = db.Column(db.String, nullable=False)

    # Session information
    session_token = db.Column(db.String, nullable=False, unique=True)
    session_expiration = db.Column(db.DateTime, nullable=False)
    update_token = db.Column(db.String, nullable=False, unique=True)

    def __init__(self, **kwargs):
        self.firstName = kwargs.get('firstName', '')
        self.lastName = kwargs.get('lastName', '')
        self.email = kwargs.get('email', '')
        self.password_digest = bcrypt.hashpw(
            kwargs.get("password").encode("utf8"), bcrypt.gensalt(rounds=13)
        )
        self.expenses = []
        self.budgets = []
        self.renew_session()

    def serialize(self):
        return {
            'user_id': self.id,
            'firstName': self.firstName,
            'lastName': self.lastName,
            'email': self.email,
            'expenses': [s.serialize() for s in self.expenses],
            'budgets': [s.serialize() for s in self.budgets]
        }

    # Used to randomly generate session/update tokens
    def _urlsafe_base_64(self):
        return hashlib.sha1(os.urandom(64)).hexdigest()

    # Generates new tokens, and resets expiration time
    def renew_session(self):
        self.session_token = self._urlsafe_base_64()
        self.session_expiration = datetime.datetime.now() + datetime.timedelta(days=1)
        self.update_token = self._urlsafe_base_64()

    def verify_password(self, password):
        return bcrypt.checkpw(password.encode("utf8"), self.password_digest)

    # Checks if session token is valid and hasn't expired
    def verify_session_token(self, session_token):
        return (
            session_token == self.session_token
            and datetime.datetime.now() < self.session_expiration
        )

    def verify_update_token(self, update_token):
        return update_token == self.update_token

# Spending expense
class Expense(db.Model):
    __tablename__ = 'expense'
    id = db.Column(db.Integer, primary_key = True)
    title = db.Column(db.String, nullable = False)          # Title of the spending expense
    amount = db.Column(db.Float, nullable = False)          # The amount spent, Do we assume USD or BRB??
    description = db.Column(db.String, nullable = True)     # Optional description of the expense
    date = db.Column(db.Integer, nullable = False)          # Date the purchase was made (helps with display?)

    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable = False)                              #IDK how to do this
    tags = db.relationship('Tag', secondary = tag_table, back_populates='entries')

    def __init__(self, **kwargs):
        self.title = kwargs.get('title', '')
        self.amount = kwargs.get('amount', 0.0)
        self.description = kwargs.get('description', '')
        self.date = kwargs.get('date', '')
        self.user_id = kwargs.get('user_id', 0)

    def serialize(self):
        return {
            'expense_id': self.id,
            'title': self.title,
            'amount': self.amount,
            'description': self.description,
            'date': self.date,
            'tags': [t.serialize() for t in self.tags]
        }


# Optional decision to include the tag in your spending expense
# name of the category [food, clothing, transport, entertainment, groceries, bills, miscellaneous, spending(Include for budget)]
class Tag(db.Model):
    __tablename__ = 'tag'
    id = db.Column(db.Integer, primary_key = True)
    name = db.Column(db.String, nullable = False)
    entries = db.relationship('Expense', secondary = tag_table, back_populates='tags')

    def __init__(self, **kwargs):
        self.name = kwargs.get('name', '')

    def serialize(self):
        return {
            'tag_id': self.id,
            'name': self.name
        }
    def serialize2(self):
        return{
            'name': self.name
        }


# including the budget in your monthly spending tracking
class Budget(db.Model):
    __tablename__ = 'budget'
    id = db.Column(db.Integer, primary_key = True)
    title = db.Column(db.String, nullable = False)
    limit = db.Column(db.Integer, nullable = False)         #your limit for the month
    length = db.Column(db.Integer, nullable = False)        #Default: Month; [week, month, year]
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable = False)

    # A budget has 1 tag
    tag_id = db.Column(db.Integer, nullable = False)

    def __init__(self, **kwargs):
        self.title = kwargs.get('title', '')
        self.limit = kwargs.get('limit', 0)
        self.length = kwargs.get('length', 0)
        self.user_id = kwargs.get('user_id', 0)
        self.tag_id = kwargs.get('tag_id', 0)

    def serialize(self):
        return{
            'budget_id': self.id,
            'title': self.title,
            'limit': self.limit,
            'tag_id': self.tag_id
        }
