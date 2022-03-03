#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import render_template
from flask import request, redirect, session

from connexion_db import get_db

client_article = Blueprint('client_article', __name__,
                        template_folder='templates')

@client_article.route('/client/index')
@client_article.route('/client/article/show')      # remplace /client
def client_article_show():                                 # remplace client_index
    mycursor = get_db().cursor()

    # select type_article
    types_articles = []

    client_id = session['user_id']


    sql = "SELECT * FROM panier WHERE idUser=%s"
    mycursor.execute(sql, client_id)
    panier = mycursor.fetchall()
    articles_panier = panier

    sql="SELECT SUM(panier.prix_unit * panier.quantite) as total FROM panier WHERE idUser=%s"
    mycursor.execute(sql, client_id)
    prix_totalListe = mycursor.fetchone()
    prix_total=(prix_totalListe['total'])



    sql = "SELECT * FROM telephone"
    mycursor.execute(sql)
    telephone = mycursor.fetchall()
    articles = telephone


    return render_template('client/boutique/panier_article.html', articles=articles, articlesPanier=articles_panier, prix_total=prix_total, itemsFiltre=types_articles)

@client_article.route('/client/article/details/<int:id>', methods=['GET'])
def client_article_details(id):
    mycursor = get_db().cursor()
    client_id = session['user_id']

    sql = "SELECT * FROM telephone WHERE id_telephone=%s"
    mycursor.execute(sql, id)
    telephone = mycursor.fetchone()
    article = telephone


    sql="SELECT * FROM ligneCommande INNER JOIN commande ON commande.idCommande = ligneCommande.commande_id WHERE commande.idUser=%s"
    mycursor.execute(sql, client_id)
    commandes_articles=mycursor.fetchall()
    commentaires=[]

    return render_template('client/boutique/article_details.html', article=article, commentaires=commentaires, commandes_articles=commandes_articles)