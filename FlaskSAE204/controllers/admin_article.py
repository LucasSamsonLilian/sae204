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
    return render_template('admin/article/show_article.html', articles=articles)

@admin_article.route('/admin/article/add', methods=['GET'])
def add_article():
    mycursor = get_db().cursor()
    sql = "SELECT * FROM marque"
    mycursor.execute(sql)
    marques = mycursor.fetchall()

    sql = "SELECT * FROM ram"
    mycursor.execute(sql)
    ram = mycursor.fetchall()

    sql = "SELECT * FROM stockage"
    mycursor.execute(sql)
    stockage = mycursor.fetchall()

    sql = "SELECT * FROM fournisseur"
    mycursor.execute(sql)
    fournisseur = mycursor.fetchall()


    return render_template('admin/article/add_article.html', marques=marques, rams=ram, stockages=stockage, fournisseurs=fournisseur)

@admin_article.route('/admin/article/add', methods=['POST'])
def valid_add_article():
    mycursor = get_db().cursor()

    stock = request.form.get('stock_telephone', '')
    prix = request.form.get('prix_telephone', '')
    modele = request.form.get('modele_telephone', '')
    marque = request.form.get('marque_telephone', '')
    taille = request.form.get('taille_telephone', '')
    poids = request.form.get('poids_telephone', '')
    ram = request.form.get('ram_telephone', '')
    stockage = request.form.get('stockage_telephone', '')
    fournisseur = request.form.get('fournisseur_telephone', '')




    mycursor.execute("SELECT COUNT(*)+1 as id FROM Telephone")
    id=mycursor.fetchone()

    date = datetime.datetime.now()

    mycursor.execute("INSERT INTO Telephone VALUE (%s, %s, %s, %s, %s,%s, %s, %s, %s, %s,%s, %s, %s, %s )",(id['id'], modele, 'telephone', date, prix,modele, poids, taille, ram, stockage, fournisseur, 1, marque, stock ))
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

    mycursor.execute("SELECT COUNT(*) as id FROM ligneCommande WHERE telephone_id=%s", (id))
    nbTeleMarque = mycursor.fetchone()

    if (nbTeleMarque['id'] == 0):
        mycursor.execute("DELETE FROM Telephone WHERE id_telephone = %s",(id))
        mycursor.fetchone()
        get_db().commit()
        flash(u'un article supprimé')
    else:
        flash(u'cet article ne peut etre supprimé')
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

##############################gestion types articles########################################################################################


@admin_article.route('/admin/type-article/show')
def show_type_article():
    mycursor = get_db().cursor()
    mycursor.execute("SELECT * FROM marque")
    type_articles = mycursor.fetchall()
    return render_template('admin/type_article/show_type_article.html', type_articles=type_articles)


@admin_article.route('/admin/type-article/add', methods=['GET'])
def add_type_article():
    return render_template('admin/type_article/add_type_article.html')

@admin_article.route('/admin/type-article/add', methods=['POST'])
def valid_add_type_article():
    mycursor = get_db().cursor()

    nom = request.form.get('nom_marque', '')

    mycursor.execute("SELECT COUNT(*) as id FROM marque")
    id=mycursor.fetchone()


    mycursor.execute("INSERT INTO marque VALUE (%s, %s, %s)",(id['id'], nom, nom))
    mycursor.fetchone()

    get_db().commit()

    message = u'marque ajouté'
    flash(message)
    return redirect(url_for('admin_article.show_type_article'))

@admin_article.route('/admin/type-article/delete', methods=['POST'])
def delete_type_article():
    # id = request.args.get('id', '')
    id = request.form.get('code_marque', '')

    mycursor = get_db().cursor()

    mycursor.execute("SELECT COUNT(*) as id FROM Telephone WHERE code_marque=%s",(id))
    nbTeleMarque= mycursor.fetchone()

    if(nbTeleMarque['id']==0):
        mycursor.execute("DELETE FROM marque WHERE code_marque = %s",(id))
        mycursor.fetchone()
        get_db().commit()
        flash(u'une marque supprimé')

    else:
        flash(u'cette maque ne peut etre supprimé')

    return redirect(url_for('admin_article.show_type_article'))

@admin_article.route('/admin/type-article/edit/<int:id>', methods=['GET'])
def edit_type_article(id):
    mycursor = get_db().cursor()
    sql="SELECT * FROM marque WHERE code_marque = %s"
    mycursor.execute(sql, id)
    types_articles = mycursor.fetchone()

    return render_template('admin/type_article/edit_type_article.html', type_article=types_articles)

@admin_article.route('/admin/type-article/edit', methods=['POST'])
def valid_type_edit_article():
    mycursor = get_db().cursor()

    id = request.form.get('code_marque', '')
    nom_marque = request.form.get('nom_marque', '')


    mycursor.execute("UPDATE marque SET nom_marque=%s  WHERE code_marque=%s",(nom_marque, id))
    mycursor.fetchone()

    get_db().commit()

    return redirect(url_for('admin_article.show_type_article'))

