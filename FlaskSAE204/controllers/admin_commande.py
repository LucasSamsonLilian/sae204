#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint, request
from flask import render_template, redirect

from connexion_db import get_db

admin_commande = Blueprint('admin_commande', __name__,
                        template_folder='templates')

@admin_commande.route('/admin/commande/index')
def admin_index():
    return render_template('admin/layout_admin.html')


@admin_commande.route('/admin/commande/show', methods=['get','post'])
def admin_commande_show():
    mycursor = get_db().cursor()
    sql = '''SELECT * FROM commande'''
    mycursor.execute(sql)
    commandes = mycursor.fetchall()

    for commande in commandes:
        mycursor.execute("SELECT idUser FROM commande WHERE idCommande = %s",commande['idCommande'])
        client_id = mycursor.fetchone()
        client_id = client_id.get('idUser')
        print(client_id)

        mycursor.execute("SELECT taxe FROM pays INNER JOIN userC ON userC.codePays = pays.codePays AND idUser = %s",
                         client_id)
        taxePays_ = mycursor.fetchone()
        taxePays_ = float(taxePays_.get('taxe'))

        tuple_select = (commande['idCommande'])
        sql = '''SELECT SUM(quantite) AS nbr FROM ligneCommande WHERE commande_id = %s '''
        mycursor.execute(sql, tuple_select)
        retour = mycursor.fetchone()
        commande['nbr_articles'] = retour.get("nbr")

        sql = '''SELECT SUM(quantite*prix) AS prix FROM ligneCommande WHERE commande_id = %s '''
        mycursor.execute(sql, tuple_select)
        retour = mycursor.fetchone()
        commande['prix_total'] = float(retour.get("prix")) + taxePays_

        tuple_select = (commande['idUser'])
        sql = '''SELECT username AS username FROM userC WHERE idUser = %s '''
        mycursor.execute(sql, tuple_select)
        retour = mycursor.fetchone()
        commande['username'] = retour.get("username")

        tuple_select = (commande['idEtat'])
        sql = '''SELECT libelle FROM etat WHERE idEtat = %s'''
        mycursor.execute(sql, tuple_select)
        retour = mycursor.fetchone()
        commande['libelle'] = retour.get("libelle")

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

    return render_template('admin/commandes/show.html', commandes=commandes, articles_commande=articles_commande)


@admin_commande.route('/admin/commande/valider', methods=['get','post'])
def admin_commande_valider():
    mycursor = get_db().cursor()
    idCommande = request.form.get("idCommande")

    sql = '''UPDATE commande SET idEtat = 3 WHERE idCommande = %s'''
    mycursor.execute(sql, (idCommande,))
    get_db().commit()


    return redirect('/admin/commande/show') 
