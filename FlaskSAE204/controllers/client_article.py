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

    client_id = session['user_id']



    sql = "SELECT * FROM panier WHERE idUser=%s"
    mycursor.execute(sql, client_id)
    panier = mycursor.fetchall()
    articles_panier = panier

    sql="SELECT SUM(panier.prix_unit * panier.quantite) as total FROM panier WHERE idUser=%s"
    mycursor.execute(sql, client_id)
    prix_totalListe = mycursor.fetchone()
    prix_total=(prix_totalListe['total'])

    mycursor.execute("SELECT * FROM marque")
    marque_filtre = mycursor.fetchall()

    mycursor.execute("SELECT * FROM telephone")
    articles = mycursor.fetchall()

    if 'word' in session:
        mycursor.execute("SELECT * FROM telephone WHERE modele LIKE %s", ("%"+session["word"]+"%"))
        articles = mycursor.fetchall()



    for article in articles:
        mycursor.execute("SELECT marque.nom_marque FROM marque WHERE code_marque=%s", (article['code_marque']))
        marque = mycursor.fetchone()
        article['nom_marque'] = marque.get('nom_marque')
        article['show'] = True


    if('code_marque' in session):
        for article in articles:
            x=article['code_marque']
            y=session['code_marque']
            if(int(y)>0 and int(x)==int(y) and article['show']):
                article['show'] = True
            else:
                article['show'] = False

    if ('prix_min' in session):
        for article in articles:
            x = article['prix']
            y = session['prix_min']
            if (y is not None and int(x) >= int(y) and article['show']):
                article['show'] = True
            else:
                article['show'] = False

    if ('prix_max' in session):
        for article in articles:
            x = article['prix']
            y = session['prix_max']
            if (y is not None and int(x) <= int(y) and article['show']):
                article['show'] = True
            else:
                article['show'] = False


    return render_template('client/boutique/panier_article.html', articles=articles, articlesPanier=articles_panier, prix_total=prix_total, itemsFiltre=marque_filtre)

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

    sql="SELECT * FROM commentaire WHERE telephone_id=%s"
    mycursor.execute(sql, id)
    commentaires=mycursor.fetchall()

    tuple_commeUser=(id, client_id)
    sql = "SELECT * FROM commentaire WHERE telephone_id=%s AND user_id = %s"
    mycursor.execute(sql, tuple_commeUser)
    commentaires_user = mycursor.fetchall()


    return render_template('client/boutique/article_details.html', article=article, commentaires=commentaires, commandes_articles=commandes_articles, commentaires_user=commentaires_user)