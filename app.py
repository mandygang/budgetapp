import json
from db import db, User, Entry, Tag, Goal
from flask import Flask, request

db_filename = "budget.db"
app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///%s' % db_filename
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_ECHO'] = True
#
db.init_app(app)
with app.app_context():
    db.create_all()

@app.route('/')
def hello_world():
    return 'Hello worldx!'

"""
YOUR ROUTES BELOW
"""
@app.route('/api/users/')
def get_users():
    users = User.query.all()
    res = {'success': True, 'data': [u.serialize() for u in users]}
    return json.dumps(res), 200

@app.route('/api/users/', methods=['POST'])
def create_user():
    post_body = json.loads(request.data)
    first_name = post_body.get('first_name', '')
    last_name = post_body.get('last_name', '')
    email = post_body.get('email', '')
    phoneNum = post_body.get('phone_number', '')
    user = User(
        firstName = first_name,
        lastName = last_name,
        email = email,
        phoneNum = phoneNum
    )
    db.session.add(user)
    db.session.commit()
    return json.dumps({'success': True, 'data': user.serialize()}), 201

@app.route('/api/user/<int:user_id>/')
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

@app.route('/api/courses/', methods=['POST'])
def create_course():
    post_body = json.loads(request.data)
    code = post_body.get('code', '')
    name = post_body.get('name', '')
    course = Course(
        code = code,
        name = name
    )
    db.session.add(course)
    db.session.commit()
    return json.dumps({'success': True, 'data': course.serialize()}), 201

@app.route('/api/course/<int:course_id>/')
def get_course(course_id):
    course = Course.query.filter_by(id=course_id).first()
    if not course:
        return json.dumps({'success': False, 'error': 'Course not found!'}), 404
    return json.dumps({'success': True, 'data': course.serialize()}), 200


@app.route('/api/course/<int:course_id>/add/', methods=['POST'])
def add_user(course_id):
    post_body = json.loads(request.data)
    type = post_body.get('type', '')
    user_id = post_body.get('user_id', '')
    user = User.query.filter_by(id=user_id).first()
    course = Course.query.filter_by(id=course_id).first()
    if not course:
        return json.dumps({'success': False, 'error': 'Course not found!'}), 404
    if type == "instructor":
        course.instructors.append(user)
    elif type == "student":
        course.students.append(user)
    else:
        return json.dumps({'success': False, 'error': 'Pick a valid job'}), 404
    db.session.add(user)
    db.session.commit()
    return json.dumps({'success': True, 'data': course.serialize()}), 200

@app.route('/api/course/<int:course_id>/assignment/', methods=['POST'])
def create_assignment(course_id):
    post_body = json.loads(request.data)
    title = post_body.get('title', '')
    due_date = post_body.get('due_date', '')
    course = Course.query.filter_by(id=course_id).first()
    if not course:
        return json.dumps({'success': False, 'error': 'Assignment not found!'}), 404
    assignment = Assignment(
        title = title,
        due_date = due_date,
        course_id = course_id
    )
    course.assignments.append(assignment)
    db.session.add(assignment)
    db.session.commit()
    result = assignment.serialize()
    result['course'] = course.serialize2()
    return json.dumps({'success': True, 'data': result}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)