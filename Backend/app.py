import json
from db import db, User, Expense, Tag, Budget
from flask import Flask, request
import users_dao

db_filename = "budget.db"
app = Flask(__name__)

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()


def extract_token(request):
    auth_header = request.headers.get("Authorization")
    if not auth_header:
        return False, json.dumps({'error': 'Missing authorization header'})
    bearer_token = auth_header.replace("Bearer ", "").strip()
    if not bearer_token:
        return False, json.dumps({'error': 'Missing authorization header'})

    return True, bearer_token


# @app.route("/")
# def hello_world():
#     return json.dumps({"message": "Hello, World!"})

# Gets all users
@app.route('/api/users/', methods=["GET"])
def get_users():
    users = User.query.all()
    res = {'success': True, 'data': [u.serialize() for u in users]}
    return json.dumps(res), 200

# Gets specific user by user_id
@app.route('/api/user/<int:user_id>/', methods=['GET'])
def get_user(user_id):
    user = User.query.filter_by(id=user_id).first()
    if not user:
        return json.dumps({'success': False, 'error': 'User not found!'}), 404
    return json.dumps({'success': True, 'data': user.serialize()}), 200

@app.route('/api/user/<int:user_id>/', methods=['DELETE'])
def delete_user(user_id):
    user = User.query.get(user_id)
    if not user:
        return json.dumps({'success': False, 'error': 'User not found!'}), 404
    db.session.delete(user)
    db.session.commit()
    return json.dumps({'success': True, 'data': user.serialize()}), 201


# create budget for a category -- double check how i added tag
#might want to change it to post body
@app.route('/api/budget/<int:user_id>/', methods=['POST'])
def create_budget(user_id, tag_id):
    user = User.query.filter_by(id=user_id).first()
    #tag = Tag.query.filter_by(id=tag_id).first()
    #user = User.query.get(user_id)
    if not user:
        return json.dumps({'success': False, 'error': 'User not found!'}), 404

    post_body = json.loads(request.data)
    title = post_body.get('title', '')
    limit = post_body.get('limit', 0)
    length = post_body.get('length', 0)
    tag = post_body.get('tag', '')

    budget = Budget(
        title = title,
        limit = limit,
        length = length,
        user_id = user_id,
        tag_id = tag_id
    )
    user.budgets.append(budget)

    db.session.add(budget)
    db.session.commit()
    return json.dumps({'success': True, 'data': budget.serialize()}), 201

@app.route('/api/budgets/', methods=['GET'])
def get_budgets():
    budgets = Budget.query.all()
    res = {'success': True, 'data': [b.serialize() for b in budgets]}
    return json.dumps(res), 200

@app.route('/api/budget/<int:budget_id>/', methods=['GET'])
def get_budget(budget_id):
    budget = Budget.query.filter_by(id=budget_id).first()
    if not budget:
        return json.dumps({'success': False, 'error': 'Budget not found!'}), 404
    return json.dumps({'success': True, 'data': budget.serialize()}), 200

@app.route('/api/budget/<int:user_id>/<int:tag_id>/', methods=['GET'])
def get_budget_by_tag(user_id, tag_id):
    user = User.query.filter_by(id=user_id).first()
    budgets = user.budgets
    for b in budgets:
        if b.tag_id == tag_id:
            return json.dumps({'success': True, 'data': b.serialize()}), 200
    return json.dumps({'success': False, 'error': 'Budget not found!'}), 404

# Edit Budget
@app.route('/api/budget/edit/<int:budget_id>/', methods=['POST'])
def edit_budget(budget_id):
    budget = Budget.query.filter_by(id=budget_id).first()
    if not budget:
        return json.dumps({'success': False, 'error': 'Budget not found!'}), 404

    post_body = json.loads(request.data)
    budget.title = post_body.get('title', '')
    budget.limit = post_body.get('limit', 0)
    budget.length = post_body.get('length', 0)
    budget.tag_id = post_body.get('tag_id', 0)

    db.session.commit()
    return json.dumps({'success': True, 'data': budget.serialize()}), 200

# Delete budget
@app.route('/api/budget/<int:budget_id>/', methods=['DELETE'])
def delete_budget(budget_id):
    budget = Budget.query.filter_by(id=budget_id).first()
    if not budget:
        return json.dumps({'success': False, 'error': 'Budget not found!'}), 404

    db.session.delete(budget)
    db.session.commit()
    return json.dumps({'success': True, 'data': budget.serialize()}), 201


# Add/Log Expense
@app.route('/api/expense/<int:user_id>/', methods=['POST'])
def create_expense(user_id):
    user = User.query.filter_by(id=user_id).first()
    #user = User.query.get(user_id)
    if not user:
        return json.dumps({'success': False, 'error': 'User not found!'}), 404

    post_body = json.loads(request.data)
    title = post_body.get('title', '')
    amount = post_body.get('amount', 0.0)
    description = post_body.get('description', '')
    date = post_body.get('date', '')
    tags = post_body.get('tags', [])

    expense = Expense(
        title = title,
        amount = amount,
        description = description,
        date = date,
    )
    for tag in tags:
        expense.tags.append(Tag.query.filter_by(id=tag).first())

    user.expenses.append(expense)
    db.session.add(expense)
    db.session.commit()
    return json.dumps({'success': True, 'data': expense.serialize()}), 201

# Edit EXPENSE
@app.route('/api/expense/edit/<int:expense_id>/', methods=['POST'])
def edit_expense(expense_id):
    expense = Expense.query.filter_by(id=expense_id).first()
    if not expense:
        return json.dumps({'success': False, 'error': 'Expense not found!'}), 404

    post_body = json.loads(request.data)
    expense.title = post_body.get('title', '')
    expense.amount = post_body.get('amount', 0.0)
    expense.description = post_body.get('description', '')
    expense.date = post_body.get('date', '')
    tags = post_body.get('tags',[])
    new_tags = []
    for tag in tags:
        new_tags.append(Tag.query.filter_by(id=tag).first())
    expense.tags = new_tags

    db.session.commit()
    return json.dumps({'success': True, 'data': expense.serialize()}), 200

# delete EXPENSE
@app.route('/api/expense/<int:expense_id>/', methods=['DELETE'])
def delete_expense(expense_id):
    expense = Expense.query.filter_by(id=expense_id).first()
    if not expense:
        return json.dumps({'success': False, 'error': 'Expense not found!'}), 404

    db.session.delete(expense)
    db.session.commit()
    return json.dumps({'success': True, 'data': expense.serialize()}), 201

# Get all user's expenses, should be listed by date?
# Do we need to sort by date?
@app.route('/api/expenses/<int:user_id>/', methods=['GET'])
def get_users_expenses(user_id):
    user = User.query.filter_by(id=user_id).first()
    #user = User.query.get(user_id)
    if not user:
        return json.dumps({'success': False, 'error': 'User not found!'}), 404

    expenses = user.expenses
    res = {'success': True, 'data': [e.serialize() for e in expenses]}
    return json.dumps(res), 200

#TAG
@app.route('/api/tag/', methods=['POST'])
def create_tag():
    post_body = json.loads(request.data)
    name = post_body.get('name', '')

    tag = Tag(
        name = name
    )

    db.session.add(tag)
    db.session.commit()
    return json.dumps({'success': True, 'data': tag.serialize()}), 201

@app.route('/api/expenses/<int:user_id>/<int:tag_id>/', methods=['GET'])
def get_expenses_by_tag(user_id, tag_id):
    user = User.query.filter_by(id=user_id).first()
    #user = User.query.get(user_id)
    if not user:
        return json.dumps({'success': False, 'error': 'User not found!'}), 404

    expenses = user.expenses
    right_expenses = []
    for e in expenses:
        for tags in e.tags:
            if tags.id == tag_id:
                right_expenses.append(e.serialize())
    if len(right_expenses) > 0:
        res = {'success': True, 'data': right_expenses}
        return json.dumps(res), 200

    return json.dumps({'success': False, 'error': 'Budget not found!'}), 404

# all expenses by category
# probably a simpler way to do this with tables
# @app.route('/api/expenses/<int:user_id>/<int:tag_id>/', methods=['GET'])
# def get_users_expenses_tag(user_id, tag_id):
#     user = User.query.filter_by(id=user_id).first()
#     #user = User.query.get(user_id)
#     if not user:
#         return json.dumps({'success': False, 'error': 'User not found!'}), 404
#
#     tag = Tag.query.get(id=tag_id)


# get total Spending
# get total spending by Category
# EXTRA: add category
# Birdy Quotes/Homescreen message display




# @app.route('/api/courses/', methods=['POST'])
# def create_course():
#     post_body = json.loads(request.data)
#     code = post_body.get('code', '')
#     name = post_body.get('name', '')
#     course = Course(
#         code = code,
#         name = name
#     )
#     db.session.add(course)
#     db.session.commit()
#     return json.dumps({'success': True, 'data': course.serialize()}), 201
#
# @app.route('/api/course/<int:course_id>/')
# def get_course(course_id):
#     course = Course.query.filter_by(id=course_id).first()
#     if not course:
#         return json.dumps({'success': False, 'error': 'Course not found!'}), 404
#     return json.dumps({'success': True, 'data': course.serialize()}), 200
#
#
# @app.route('/api/course/<int:course_id>/add/', methods=['POST'])
# def add_user(course_id):
#     post_body = json.loads(request.data)
#     type = post_body.get('type', '')
#     user_id = post_body.get('user_id', '')
#     user = User.query.filter_by(id=user_id).first()
#     course = Course.query.filter_by(id=course_id).first()
#     if not course:
#         return json.dumps({'success': False, 'error': 'Course not found!'}), 404
#     if type == "instructor":
#         course.instructors.append(user)
#     elif type == "student":
#         course.students.append(user)
#     else:
#         return json.dumps({'success': False, 'error': 'Pick a valid job'}), 404
#     db.session.add(user)
#     db.session.commit()
#     return json.dumps({'success': True, 'data': course.serialize()}), 200
#
# @app.route('/api/course/<int:course_id>/assignment/', methods=['POST'])
# def create_assignment(course_id):
#     post_body = json.loads(request.data)
#     title = post_body.get('title', '')
#     due_date = post_body.get('due_date', '')
#     course = Course.query.filter_by(id=course_id).first()
#     if not course:
#         return json.dumps({'success': False, 'error': 'Assignment not found!'}), 404
#     assignment = Assignment(
#         title = title,
#         due_date = due_date,
#         course_id = course_id
#     )
#     course.assignments.append(assignment)
#     db.session.add(assignment)
#     db.session.commit()
#     result = assignment.serialize()
#     result['course'] = course.serialize2()
#     return json.dumps({'success': True, 'data': result}), 200


# ================================ Account Routes ================================
@app.route("/register/", methods=["POST"])
def register_account():
    post_body = json.loads(request.data)
    email = post_body.get('email')
    password = post_body.get('password')

    if not email or not password:
        return json.dumps({'error': 'missing email or password.'})

    created, user = users_dao.create_user(email, password)

    if not created:
        return json.dumps({'error': 'User already exists.'})

    return json.dumps({
        'session_token': user.session_token,
        'session_expiration': str(user.session_expiration),
        'update_token': user.update_token
    })


@app.route("/login/", methods=["POST"])
def login():
    post_body = json.loads(request.data)
    email = post_body.get('email')
    password = post_body.get('password')

    if not email or not password:
        return json.dumps({'error': 'missing email or password.'})

    success, user = users_dao.verify_credentials(email, password)

    if not success:
        return json.dumps({'error': 'Incorrect email or password.'})

    return json.dumps({
        'session_token': user.session_token,
        'session_expiration': str(user.session_expiration),
        'update_token': user.update_token
    })


@app.route("/session/", methods=["POST"])
def update_session():
    success, update_token = extract_token(request)
    if not success:
        return update_token

    try:
        user = users_dao.renew_session(update_token)
    except:
        return json.dumps({"error": "Invalid update token."})

    return json.dumps({
        'session_token': user.session_token,
        'session_expiration': str(user.session_expiration),
        'update_token': user.update_token
    })


@app.route("/secret/", methods=["GET"])
def secret_message():
    success, session_token = extract_token(request)
    if not success:
        return session_token

    user = users_dao.get_user_by_session_token(session_token)
    if not user or not user.verify_session_token(session_token):
        return json.dumps({'error': 'Invalid session token'})

    return json.dumps({'message': 'You have successfully implemented session tokens.'})

# ================================ End of Account Routes ================================

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
