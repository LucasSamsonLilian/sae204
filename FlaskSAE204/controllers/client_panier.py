#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import request, redirect, session, flash

from connexion_db import get_db
import datetime

client_panier = Blueprint('client_panier', __name__,
                        template_folder='templates')


@client_panier.route('/client/panier/add', methods=['POST'])
def client_panier_add():
    mycursor = get_db().cursor()

    client_id = session['user_id']
    id_article = request.form.get('idArticle')
    quantite = request.form.get('quantite')

    sql = "SELECT * FROM panier WHERE id_telephone = %s AND idUser=%s"
    mycursor.execute(sql, (id_article, client_id))
    article_panier = mycursor.fetchone()

    mycursor.execute("SELECT telephone.prix FROM Telephone WHERE id_telephone = %s", (id_article))
    prix = mycursor.fetchone()

    mycursor.execute("SELECT telephone.modele FROM Telephone WHERE id_telephone = %s", (id_article))
    nom = mycursor.fetchone()

    mycursor.execute("SELECT telephone.stock FROM Telephone WHERE id_telephone = %s", (id_article))
    stock = mycursor.fetchone()

    mycursor.execute("SELECT SUM(panier.quantite) as qte FROM panier WHERE id_telephone = %s",(id_article))
    stock_non_dispo=mycursor.fetchone()

    if(stock_non_dispo['qte'] is not None):
        stock_vrai=stock['stock']-stock_non_dispo['qte']
    else:
        stock_vrai=stock['stock']

    print(type(stock['stock'])," ", stock['stock'])
    date=datetime.datetime.now()

    if stock['stock']>=1:
        if stock_vrai>=int(quantite):
            if not (article_panier is None) and article_panier['quantite'] >= 1:
                tuple_update_panier = (quantite, client_id, id_article)
                sql = "UPDATE panier SET quantite = quantite+%s WHERE idUser = %s AND id_telephone=%s"
                mycursor.execute(sql, tuple_update_panier)
            else:
                tuple_insert = (date, prix['prix'],quantite,id_article,client_id,nom['modele'] )
                sql = "INSERT INTO panier(date_ajout,prix_unit,quantite,id_telephone,idUser,nom) VALUES (%s,%s,%s,%s,%s,%s)"
                mycursor.execute(sql, tuple_insert)
            get_db().commit()
        else:
            flash(u'Trop de commande pour ce téléphone, veuillez réessayer dans quelques jours')
    else:
        flash(u'Nous n\'avons plus de téléphone de ce type dans nos stock')



    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))


@client_panier.route('/client/panier/add2', methods=['POST'])
def client_panier_add2():
    mycursor = get_db().cursor()

    client_id = session['user_id']
    id_panier=request.form.get('idPanier')
    quantite = request.form.get('quantite')

    sql = "SELECT panier.id_telephone as id FROM panier WHERE idPanier=%s AND idUser=%s"
    mycursor.execute(sql, (id_panier, client_id))
    id_article= mycursor.fetchone()

    mycursor.execute("SELECT SUM(panier.quantite) as qte FROM panier WHERE id_telephone = %s", (id_article))
    stock_non_dispo = mycursor.fetchone()

    tuple_update_panier = (quantite ,client_id, id_article['id'])
    sql = "UPDATE panier SET quantite=quantite+%s WHERE idUser = %s AND id_telephone=%s"
    mycursor.execute(sql, tuple_update_panier)
    get_db().commit()

    return redirect('/client/article/show')


@client_panier.route('/client/panier/delete', methods=['POST'])
def client_panier_delete():
    mycursor = get_db().cursor()
    client_id = session['user_id']
    idPanier = request.form.get('idPanier')

    mycursor.execute("SELECT panier.quantite FROM panier WHERE idPanier = %s", (idPanier))
    qte = mycursor.fetchone()


    if qte['quantite'] > 1:
        tuple_update = (1, client_id, idPanier)
        sql = "UPDATE panier SET quantite = quantite-%s WHERE idUser = %s AND idPanier=%s"
        mycursor.execute(sql, tuple_update)
    if(qte['quantite']==1):
        tuple_delete = (client_id, idPanier)
        sql = "DELETE FROM panier WHERE idUser=%s AND idPanier=%s"
        mycursor.execute(sql, tuple_delete)


    get_db().commit()

    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))


@client_panier.route('/client/panier/vider', methods=['POST'])
def client_panier_vider():
    mycursor = get_db().cursor()
    client_id = session['user_id']

    tuple_deleteAll=(client_id)
    sql = "DELETE FROM panier WHERE idUser=%s"
    mycursor.execute(sql, tuple_deleteAll)

    get_db().commit()

    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))


@client_panier.route('/client/panier/delete/line', methods=['POST'])
def client_panier_delete_line():
    mycursor = get_db().cursor()
    client_id = session['user_id']
    idPanier = request.form.get('idPanier')

    tuple_delete = (client_id, idPanier)
    sql = "DELETE FROM panier WHERE idUser=%s AND idPanier=%s"
    mycursor.execute(sql, tuple_delete)

    get_db().commit()

    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))


@client_panier.route('/client/panier/filtre', methods=['POST'])
def client_panier_filtre():
    filter_word = request.form.get('filter_word', None)
    filter_prix_min = request.form.get('filter_prix_min', None)
    filter_prix_max = request.form.get('filter_prix_max', None)
    filter_types = request.form.getlist('filter_types', None)
    if(filter_word is not None):
        session['word'] = filter_word
    if (filter_prix_min is not None):
        session['prix_min'] = filter_prix_min
    if (filter_prix_max is not None):
        session['prix_max'] = filter_prix_max
    if (filter_types is not None and int(filter_types[0])>0):
        session['code_marque'] = filter_types[0]


    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))


@client_panier.route('/client/panier/filtre/suppr', methods=['POST'])
def client_panier_filtre_suppr():
    session.pop('word', None)
    session.pop('prix_min', None)
    session.pop('prix_max', None)
    session.pop('code_marque', None)

    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))
