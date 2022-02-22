#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import render_template, redirect, flash, session
from connexion_db import get_db

client_commande = Blueprint('client_commande', __name__,
                        template_folder='templates')


@client_commande.route('/client/commande/add', methods=['POST'])
def client_commande_add():
    mycursor = get_db().cursor()
    client_id = session['user_id']
    flash(u'Commande ajoutée')



    sql = '''DELETE FROM panier WHERE idUser = %s;'''
    mycursor.execute(sql, client_id)
    get_db().commit()
    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))



@client_commande.route('/client/commande/show', methods=['get','post'])
def client_commande_show():
    mycursor = get_db().cursor()
    commandes = None  #commande
    articles_commande = None  # lignecommande
    return render_template('client/commandes/show.html', commandes=commandes, articles_commande=articles_commande)

