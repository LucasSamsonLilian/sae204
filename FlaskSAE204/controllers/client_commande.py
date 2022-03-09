#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint, url_for
from flask import render_template, redirect, flash, session, request
from connexion_db import get_db
import datetime

client_commande = Blueprint('client_commande', __name__,
                        template_folder='templates')


@client_commande.route('/client/commande/add', methods=['POST'])
def client_commande_add():
    mycursor = get_db().cursor()
    client_id = session['user_id']

    sql = '''SELECT * FROM panier WHERE idUser=%s'''
    mycursor.execute(sql,client_id)
    items_panier = mycursor.fetchall()

    if items_panier is None or len(items_panier) < 1:
        flash(u'Pas d\'articles dans le panier')
        return redirect(url_for('client_index'))
    else:
        flash(u'Commande ajouté')

    date=datetime.datetime.now()

    tuple_insert = (date,client_id,1)
    sql = '''INSERT INTO commande(date_achat,idUser,idEtat) VALUES(%s,%s,%s)'''
    mycursor.execute(sql, tuple_insert)

    sql = '''SELECT last_insert_id() as last_insert_id'''
    mycursor.execute(sql)

    commande_id = mycursor.fetchone()

    for item in items_panier:
        tuple_delete = (client_id,item['id_telephone'])
        sql = '''DELETE FROM panier WHERE idUser = %s AND id_telephone = %s'''
        mycursor.execute(sql,tuple_delete)

        sql = '''SELECT prix FROM telephone WHERE id_telephone = %s'''
        mycursor.execute(sql,item['id_telephone'])
        prix = mycursor.fetchone()  

        tuple_update_stock=(item['quantite'], item['id_telephone'])
        sql="UPDATE Telephone SET stock=stock-%s WHERE id_telephone= %s"
        mycursor.execute(sql, tuple_update_stock)

        sql = '''INSERT INTO ligneCommande(commande_id,telephone_id,prix,quantite) VALUES (%s,%s,%s,%s)'''
        tuple_insert = (commande_id['last_insert_id'], item['id_telephone'], prix['prix'], item['quantite'])
        mycursor.execute(sql,tuple_insert)
    get_db().commit()
    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))



@client_commande.route('/client/commande/show', methods=['get','post'])
def client_commande_show():
    mycursor = get_db().cursor()

    client_id=session['user_id']
    sql = '''SELECT * FROM commande WHERE idUser = %s'''
    mycursor.execute(sql,client_id)
    commandes = mycursor.fetchall()
    for commande in commandes:
        tuple_select = (commande['idCommande'])
        sql = '''SELECT SUM(quantite) AS nbr FROM ligneCommande WHERE commande_id = %s '''
        mycursor.execute(sql,tuple_select)
        retour = mycursor.fetchone()
        commande['nbr_articles'] = retour.get("nbr")

        sql = '''SELECT SUM(quantite*prix) AS prix FROM ligneCommande WHERE commande_id = %s '''
        mycursor.execute(sql, tuple_select)
        retour = mycursor.fetchone()
        commande['prix_total'] = retour.get("prix")

        tuple_select = (commande['idEtat'])
        sql = '''SELECT libelle FROM etat WHERE idEtat = %s'''
        mycursor.execute(sql, tuple_select)
        retour = mycursor.fetchone()
        commande['libelle'] = retour.get("libelle")


    sql = '''SELECT last_insert_id() as last_insert_id'''
    mycursor.execute(sql)
    commande_id = mycursor.fetchone()

    id_commande = request.form.get('idCommande')

    sql = '''SELECT * FROM ligneCommande WHERE commande_id = %s'''
    mycursor.execute(sql, (id_commande,))
    articles_commande = mycursor.fetchall()

    for acommande in articles_commande:
        tuple_select = (acommande['telephone_id'])
        sql = '''SELECT modele FROM Telephone WHERE id_telephone = %s'''
        mycursor.execute(sql, tuple_select)
        retour = mycursor.fetchone()
        acommande['telephone_id'] = retour.get("modele")

        tuple_select = (acommande['idLigneCommande'])
        sql = '''SELECT (quantite*prix) AS prixtot FROM ligneCommande WHERE idLigneCommande = %s '''
        mycursor.execute(sql, tuple_select)
        retour = mycursor.fetchone()
        acommande['prix_total'] = retour.get("prixtot")


    return render_template('client/commandes/show.html', commandes=commandes,articles_commande=articles_commande )
#

