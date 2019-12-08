"""
Database implementation for the budget app
"""

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
# tag_table = db.Table('tags', db.Model.metadata,
#                     db.Column('tag_id', db.Integer,db.ForeignKey('tag.id')),
#                     db.Column('expense_id', db.Integer,db.ForeignKey('expense.id'))
#                     )

class User(db.Model):
    """
    This class contains user profile information

    This information helps keep track of profile user and the expenses, budgets, and
    tags created under their profile

    INSTANCE ATTRIBUTES:
        firstName:          First name of the user
        lastName:           Last name of the user
        email:              Valid email of the user
        password_digest:    Password for the user's account
        expenses:           Contains a list of all the user's expenses
        budgets:            Contains a list of all the user's budget goals
    """

    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True)
    firstName = db.Column(db.String, nullable = False)
    lastName = db.Column(db.String, nullable = False)
    # email = db.Column(db.String, nullable = False)
    # phoneNum = db.Column(db.String, nullable = True)

    # table relationships
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
        """
        Initializes a user account
        """

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
        """
        Formats the return dictionary layout for a user profile
        """

        return {
            'user_id': self.id,
            'firstName': self.firstName,
            'lastName': self.lastName,
            'email': self.email,
            'expenses': [s.serialize() for s in self.expenses],
            'budgets': [s.serialize() for s in self.budgets]
        }

    def _urlsafe_base_64(self):
        """
        Used to randomly generate session/update tokens
        """
        return hashlib.sha1(os.urandom(64)).hexdigest()

    def renew_session(self):
        """
        Generates new tokens, and resets expiration time
        """
        self.session_token = self._urlsafe_base_64()
        self.session_expiration = datetime.datetime.now() + datetime.timedelta(days=1)
        self.update_token = self._urlsafe_base_64()

    def verify_password(self, password):
        return bcrypt.checkpw(password.encode("utf8"), self.password_digest)

    def verify_session_token(self, session_token):
        """
        Checks if session token is valid and hasn't expired
        """
        return (
            session_token == self.session_token
            and datetime.datetime.now() < self.session_expiration
        )

    def verify_update_token(self, update_token):
        return update_token == self.update_token

# Spending expense
class Expense(db.Model):
    """
    This class contains details for a spending expense

    INSTANCE ATTRIBUTES:
        id:             Gives additional detail to access a specific expense recorded
        title:          Name of the expense logged
        amount:         The cost of the expense (Currency: USD?)
        description:    (Optional) Details about the expense logged (i.e. where/why was the purchase made?)
        date:           Date of when the purchase was made, for organization and display
        user_id:        Links the expenses to one user
        tag_id:         Category/type of expense, int that refers to an list of set tags
    """

    __tablename__ = 'expense'
    id = db.Column(db.Integer, primary_key = True)
    title = db.Column(db.String, nullable = False)
    amount = db.Column(db.Float, nullable = False)
    description = db.Column(db.String, nullable = True)
    date = db.Column(db.Integer, nullable = False)

    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable = False)
    tag_id = db.Column(db.Integer, nullable = False)
    #tags = db.relationship('Tag', secondary = tag_table, back_populates='entries')

    def __init__(self, **kwargs):
        """
        Initializes an expense log
        """
        self.title = kwargs.get('title', '')
        self.amount = kwargs.get('amount', 0.0)
        self.description = kwargs.get('description', '')
        self.date = kwargs.get('date', '')
        self.user_id = kwargs.get('user_id', 0)
        self.tag_id = kwargs.get('user_id', 0)

    def serialize(self):
        """
        Formats the return dictionary layout for an expense
        """
        return {
            'expense_id': self.id,
            'title': self.title,
            'amount': self.amount,
            'description': self.description,
            'date': self.date,
            'tag': self.tag_id
        }


# including the budget in your monthly spending tracking
class Budget(db.Model):
    """
    This class contains details for a budget

    The budget is a monthly goal that helps the user track how much they are spending
    in a tag (category). The user sets a cap to how much they would ideally like to
    for that month related to the tag

    A bugdet can only have one tag

    INSTANCE ATTRIBUTES:
        id:
        title:          name of the budget
        limit:          The cap on the amount of money the user wants in spend
        length:         The time frame in which the budget is active, Default: Month [week, month, year]
        user_id:        Links the budget to one user
        tag_id:         Links the budget to a tag
    """
    __tablename__ = 'budget'
    id = db.Column(db.Integer, primary_key = True)
    title = db.Column(db.String, nullable = False)
    limit = db.Column(db.Integer, nullable = False)
    length = db.Column(db.Integer, nullable = False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable = False)

    tag_id = db.Column(db.Integer, nullable = False)

    def __init__(self, **kwargs):
        """
        Initializes a tag
        """
        self.title = kwargs.get('title', '')
        self.limit = kwargs.get('limit', 0)
        self.length = kwargs.get('length', 0)
        self.user_id = kwargs.get('user_id', 0)
        self.tag_id = kwargs.get('tag_id', 0)

    def serialize(self):
        """
        Formats the return dictionary layout for a budget entry
        """
        return{
            'budget_id': self.id,
            'title': self.title,
            'limit': self.limit,
            'tag_id': self.tag_id
        }


# Optional decision to include the tag in your spending expense
# name of the category [food, clothing, transport, entertainment, groceries,
#                           bills, miscellaneous, spending(Include for budget)]
# class Tag(db.Model):
#     """
#     This class contains details for a tag that describes and categories the type of
#     expense made
#
#     INSTANCE ATTRIBUTES:
#         id:
#         name:       Title of the tag
#         entries:    List of all expenses logged by a user related to the tag
#     """
#     __tablename__ = 'tag'
#     id = db.Column(db.Integer, primary_key = True)
#     name = db.Column(db.String, nullable = False)
#     entries = db.relationship('Expense', secondary = tag_table, back_populates='tags')
#
#     def __init__(self, **kwargs):
#         """
#         Initializes a tag
#         """
#         self.name = kwargs.get('name', '')
#
#     def serialize(self):
#         """
#         Formats the return dictionary layout for a tag with its id
#         """
#         return {
#             'tag_id': self.id,
#             'name': self.name
#         }
#     def serialize2(self):
#         """
#         Formats the return dictionary layout for a tag, just name
#         """
#         return{
#             'name': self.name
#         }
