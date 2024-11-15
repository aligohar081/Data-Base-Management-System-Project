from flask import Flask, request, render_template, redirect, url_for, session
import os       #imported to generate a random secret key for session management.
import psycopg2  #connect the database with flask
app = Flask(__name__)
app.secret_key = os.urandom(16)
def get_db_connection():
    conn = psycopg2.connect(
        database="DB_Project",
        user="ali_db",
        password="sys",
        host="localhost",
        port="5432"
    )
    return conn

@app.route('/')
def index():
    if 'logged_in' in session and session['logged_in']:
        return render_template('index.html', logged_in=True)
    else:
        return render_template('index.html', logged_in=False)


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        userid = request.form['userid']
        uname = request.form['uname']
        pin = request.form['pin']
        usertype = request.form['usertype']
        faculty_name = request.form['faculty_name']
        skill_set = request.form['skill_set'] if usertype == 'student' else ''
        conn = get_db_connection()
        cursor = conn.cursor()
        if usertype == 'student':
            cursor.execute(f"CALL register_student_user ({userid}, '{uname}', '{pin}', '{usertype}', '{faculty_name}', '{skill_set}')")
        elif usertype == 'supervisor':
            cursor.execute(f"CALL register_supervisor ({userid}, '{uname}', '{pin}', '{faculty_name}', '{usertype}')")
        conn.commit()

        return redirect(url_for('index'))
    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method =='GET':
        return render_template('login.html')
    
    uname = request.form['uname']
    pin = request.form['pin']
    conn = get_db_connection()
    cursor = conn.cursor()
    q1 = f"SELECT validate_coordinator ('{uname}', '{pin}')"
    cursor.execute(q1)
    user_id = cursor.fetchall()[0][0]
    if user_id:
        session['logged_in'] = True
        session['username'] = uname
        return render_template('index.html', coordi = "True")
    else:
        q = f"SELECT validate_user_login ('{uname}', '{pin}')"
        cursor.execute(q)
        user_id = cursor.fetchall()[0][0]
        conn.close()

        if user_id:
            session['logged_in'] = True
            session['username'] = uname
            return render_template('index.html', logged_in = session['logged_in'])
        return "Invalid username or password!"

@app.route('/signout', methods=['GET', 'POST'])
def signout():
    session['logged_in'] = False
    session.pop('username', None)
    return render_template('login.html')

@app.route('/project_registration', methods=['GET', 'POST'])
def register_project():
    if request.method == 'POST':
        if 'userid' in request.form:
            userid = request.form['userid']
            project_id = request.form['project_id']
            project_title = request.form['project_title']
            project_description = request.form['project_description']
            skill_set = request.form['skill_set']
            s_id = request.form['s_id']
            q = f"Call register_project({project_id}, '{project_title}', '{project_description}', '{skill_set}', {userid}, 'not approved', {s_id});"
            print(q)
            conn = get_db_connection()
            cursor = conn.cursor()
            cursor.execute(q)
            conn.commit()
            return render_template("my_projects.html")
            
        else:
            return "User ID is required."
    return render_template('project_registration.html')

@app.route('/approved_project',  methods=['GET', 'POST'])
def projects():
    conn = get_db_connection()
    cur = conn.cursor()
    q = "SELECT * FROM project_description WHERE status = 'Approve'"
    cur.execute(q)
    projects = cur.fetchall()
    cur.close()
    conn.commit()
    conn.close()
    return render_template('approved_project.html', projects=projects)


@app.route('/not_approved_project',  methods=['GET', 'POST'])
def not_approved_project():
    if request.method == 'GET':
        conn = get_db_connection()
        cur = conn.cursor()
        q = "SELECT * FROM project_description WHERE status = 'not approved' or status = 'Reject'"
        cur.execute(q)
        projects = cur.fetchall()
        cur.close()
        conn.close()
        if projects:
            return render_template('projects_to_approve.html', projects=projects)
        else:
            return render_template('projects_to_approve.html', error = "No project to see")
    else:
        action = request.form['action']
        p_id = request.form['project_id']
        conn = get_db_connection()
        cur = conn.cursor()
        q = f"UPDATE project_description SET status = '{action}' WHERE project_id = {p_id};"
        cur.execute(q)
        conn.commit()
        cur.close()
        conn.close()
        return render_template('projects_to_approve.html', msg = "Done")

@app.route('/my_project',  methods=['GET', 'POST'])
def my_project():
    conn = get_db_connection()
    cur = conn.cursor()
    u_name  = session['username']
    ui = f"select userid from users where uname = '{session['username']}';"
    cur.execute(ui)
    u_id = cur.fetchall()
    q = f"SELECT * FROM project_description WHERE userid = {u_id[0][0]}"
    cur.execute(q)
    projects = cur.fetchall()
    print(projects)
    cur.close()
    conn.commit()
    conn.close()
    if projects:
        return render_template('my_projects.html', projects=projects)
    else:
        return render_template('my_projects.html', error = "No project to see")




if __name__ == '__main__':
    app.run(debug=True)
