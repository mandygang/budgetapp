import json
from db import db, Course, User, Assignment
from flask import Flask, request
import users_dao

db_filename = "cms.db"
app = Flask(__name__)
#Db = db.DB()

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///%s' % db_filename
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_ECHO'] = True
#
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

@app.route('/')
def hello_world():
    return 'Hello worldx!'

"""
YOUR ROUTES BELOW
"""
@app.route('/api/courses/')
def get_courses():
    courses = Course.query.all()
    res = {'success': True, 'data': [c.serialize() for c in courses]}
    return json.dumps(res), 200

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


@app.route('/api/users/', methods=['POST'])
def create_user():
    post_body = json.loads(request.data)
    name = post_body.get('name', '')
    netid = post_body.get('netid', '')
    user = User(
        name = name,
        netid = netid
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

#AUTHENTICATION
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

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

