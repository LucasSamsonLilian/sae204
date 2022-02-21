#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import request, redirect, session

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

    date=datetime.datetime.now()


    if not (article_panier is None) and article_panier['quantite'] >= 1:
        tuple_update = (quantite, client_id, id_article)
        sql = "UPDATE panier SET quantite = quantite+%s WHERE idUser = %s AND id_telephone=%s"
        mycursor.execute(sql, tuple_update)
    else:
        tuple_insert = (date, prix['prix'],quantite,id_article,client_id,nom['modele'] )
        sql = "INSERT INTO panier(date_ajout,prix_unit,quantite,id_telephone,idUser,nom) VALUES (%s,%s,%s,%s,%s,%s)"
        mycursor.execute(sql, tuple_insert)

    get_db().commit()

    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))

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
    # SQL
    filter_word = request.form.get('filter_word', None)
    filter_prix_min = request.form.get('filter_prix_min', None)
    filter_prix_max = request.form.get('filter_prix_max', None)
    filter_types = request.form.getlist('filter_types', None)

    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))


@client_panier.route('/client/panier/filtre/suppr', methods=['POST'])
def client_panier_filtre_suppr():
    session.pop('filter_word', None)
    session.pop('filter_prix_min', None)
    session.pop('filter_prix_max', None)
    session.pop('filter_types', None)
    print("suppr filtre")
    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))
