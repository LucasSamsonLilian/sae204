#! /usr/bin/python
# -*- coding:utf-8 -*-

from flask import Blueprint
from flask import request, render_template, redirect, flash, session
from werkzeug.security import generate_password_hash, check_password_hash

from connexion_db import get_db

auth_security = Blueprint('auth_security', __name__,
                        template_folder='templates')


@auth_security.route('/login')
def auth_login():
    return render_template('auth/login.html')


@auth_security.route('/login', methods=['POST'])
def auth_login_post():
    mycursor = get_db().cursor()
    username = request.form.get('username')
    password = request.form.get('password')
    tuple_select = (username,)
    sql = '''SELECT * FROM userC WHERE username = %s'''
    retour = mycursor.execute(sql, tuple_select)
    user = mycursor.fetchone()
    if user:
        mdp_ok = check_password_hash(user['password'], password)
        if not mdp_ok:
            flash(u'Vérifier votre mot de passe et essayer encore.')
            return redirect('/login')
        else:
            session['username'] = user['username']
            session['role'] = user['role']
            session['user_id'] = user['idUser']
            if user['role'] == 'ROLE_admin':
                return redirect('/admin/commande/index')
            else:
                return redirect('/client/article/show')
    else:
        flash(u'Vérifier votre login et essayer encore.')
        return redirect('/login')

@auth_security.route('/signup')
def auth_signup():
    mycursor = get_db().cursor()
    sql = '''SELECT * FROM pays'''
    mycursor.execute(sql)
    pays_ = mycursor.fetchall()

    return render_template('auth/signup.html', pays_=pays_)


@auth_security.route('/signup', methods=['POST'])
def auth_signup_post():
    mycursor = get_db().cursor()
    email = request.form.get('email')
    username = request.form.get('username')
    password = request.form.get('password')
    pays = request.form.get('pays')
    tuple_select = (username, email)
    sql = '''SELECT * FROM userC WHERE email = %s OR username = %s'''
    retour = mycursor.execute(sql, tuple_select)
    user = mycursor.fetchone()
    if user:
        flash(u'votre adresse <strong>Email</strong> ou  votre <strong>Username</strong> (login) existe déjà')
        return redirect('/signup')

    # ajouter un nouveau user
    password = generate_password_hash(password, method='sha256')
    tuple_insert = (username, email, password, 'ROLE_client',pays)
    sql = '''INSERT INTO userC(username,email,password,role,codePays) VALUES (%s,%s,%s,%s,%s)'''
    mycursor.execute(sql, tuple_insert)
    get_db().commit()                    # position de cette ligne discutatble !
    sql='''SELECT last_insert_id() AS last_insert_id;'''
    mycursor.execute(sql)
    info_last_id = mycursor.fetchone()
    user_id = info_last_id['last_insert_id']
    get_db().commit()
    session.pop('username', None)
    session.pop('role', None)
    session.pop('user_id', None)
    session.pop('codePays',None)
    session['username'] = username
    session['role'] = 'ROLE_client'
    session['user_id'] = user_id
    session['codePays'] = pays
    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))


@auth_security.route('/logout')
def auth_logout():
    session.pop('username', None)
    session.pop('role', None)
    session.pop('user_id', None)
    session.pop('word', None)
    session.pop('prix_min', None)
    session.pop('prix_max', None)
    session.pop('code_marque', None)
    return redirect('/')
    #return redirect(url_for('main_index'))

@auth_security.route('/forget-password', methods=['GET'])
def forget_password():
    return render_template('auth/forget_password.html')

