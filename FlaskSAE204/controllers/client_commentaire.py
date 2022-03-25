#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import request, redirect

from connexion_db import get_db

client_commentaire = Blueprint('client_commentaire', __name__,
                        template_folder='templates')

@client_commentaire.route('/client/comment/add', methods=['POST'])
def client_comment_add():
    mycursor = get_db().cursor()
    article_id = request.form.get('idArticle', None)
    user_id = request.form.get('idUser', None)
    note = request.form.get('note', None)
    comm = request.form.get('commentaire', None)

    mycursor.execute("SELECT userC.username as nom FROM userC WHERE idUser = %s", user_id)
    nom = mycursor.fetchone()

    tuple_insert=(None, comm, note, nom['nom'], user_id, article_id)
    sql="INSERT INTO commentaire (id_commentaire, commentaire, note, nomUser, user_id, telephone_id) VALUES(%s, %s, %s, %s, %s, %s)"
    mycursor.execute(sql, tuple_insert)

    get_db().commit()

    return redirect('/client/article/details/'+article_id)
    #return redirect(url_for('client_article_details', id=int(article_id)))

@client_commentaire.route('/client/comment/delete', methods=['POST'])
def client_comment_detete():
    mycursor = get_db().cursor()
    article_id = request.form.get('idArticle', None)
    id_user = request.form.get('idUser', None)
    id_comm = request.form.get('idAvis', None)

    mycursor.execute("DELETE FROM commentaire WHERE id_commentaire = %s AND user_id = %s AND telephone_id = %s",(id_comm, id_user, article_id))
    mycursor.fetchone()

    get_db().commit()


    return redirect('/client/article/details/'+article_id)
    #return redirect(url_for('client_article_details', id=int(article_id)))