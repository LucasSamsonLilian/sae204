#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import request, render_template, redirect, url_for, flash
import datetime
from connexion_db import get_db

admin_article = Blueprint('admin_article', __name__,
                        template_folder='templates')

@admin_article.route('/admin/article/show')
def show_article():
    mycursor = get_db().cursor()
    mycursor.execute("SELECT * FROM Telephone")
    articles = mycursor.fetchall()
    print(articles)
    return render_template('admin/article/show_article.html', articles=articles)

@admin_article.route('/admin/article/add', methods=['GET'])
def add_article():
    mycursor = get_db().cursor()
    types_articles = None
    return render_template('admin/article/add_article.html', types_articles=types_articles)

@admin_article.route('/admin/article/add', methods=['POST'])
def valid_add_article():
    mycursor = get_db().cursor()

    stock = request.form.get('stock_telephone', '')
    prix = request.form.get('prix_telephone', '')
    modele = request.form.get('modele_telephone', '')

    mycursor.execute("SELECT COUNT(*)+1 as id FROM Telephone")
    id=mycursor.fetchone()
    print(id)

    date = datetime.datetime.now()

    mycursor.execute("INSERT INTO Telephone VALUE (%s, %s, %s, %s, %s,%s, %s, %s, %s, %s,%s, %s, %s, %s )",(id['id'], modele, 'telephone', date, prix, modele, 1, 1, 1, 1, 1, 1, 1, stock ))
    mycursor.fetchone()

    get_db().commit()



    message = u'article ajouté'
    flash(message)
    return redirect(url_for('admin_article.show_article'))

@admin_article.route('/admin/article/delete', methods=['POST'])
def delete_article():
    # id = request.args.get('id', '')
    id = request.form.get('id_telephone', '')
    mycursor = get_db().cursor()
    mycursor.execute("DELETE FROM Telephone WHERE id_telephone = %s",(id))
    mycursor.fetchone()
    get_db().commit()

    print("un article supprimé, id :", id)
    flash(u'un article supprimé, id : ' + id)
    return redirect(url_for('admin_article.show_article'))

@admin_article.route('/admin/article/edit/<int:id>', methods=['GET'])
def edit_article(id):
    mycursor = get_db().cursor()
    sql="SELECT * FROM Telephone WHERE id_telephone = %s"
    mycursor.execute(sql, id)
    article = mycursor.fetchone()

    types_articles = None
    return render_template('admin/article/edit_article.html', article=article, types_articles=types_articles)

@admin_article.route('/admin/article/edit', methods=['POST'])
def valid_edit_article():
    mycursor = get_db().cursor()

    id = request.form.get('id_telephone', '')
    stock = request.form.get('stock_telephone', '')
    prix = request.form.get('prix_telephone', '')
    modele = request.form.get('modele_telephone', '')

    mycursor.execute("UPDATE Telephone SET stock=%s, prix=%s, modele=%s  WHERE id_telephone=%s",(stock, prix, modele, id))
    mycursor.fetchone()

    get_db().commit()

    return redirect(url_for('admin_article.show_article'))
