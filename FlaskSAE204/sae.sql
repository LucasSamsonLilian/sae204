DROP TABLE IF EXISTS  caracteristique;
DROP TABLE IF EXISTS  couleur;
DROP TABLE IF EXISTS  marque;
DROP TABLE IF EXISTS  fournisseur;
DROP TABLE IF EXISTS  ville;
DROP TABLE IF EXISTS  userC;
DROP TABLE IF EXISTS  etat;
DROP TABLE IF EXISTS  Telephone;
DROP TABLE IF EXISTS  panier;
DROP TABLE IF EXISTS  commande;
DROP TABLE IF EXISTS  ligne_commande;
DROP TABLE IF EXISTS  se_situe;

CREATE TABLE caracteristique(
   id_caracteristique INT,
   poids DOUBLE,
   stockage DOUBLE,
   resisstance_eau INT(1),
   taille_ecran DOUBLE,
   RAM INT,
   PRIMARY KEY(id_caracteristique)
);

CREATE TABLE couleur(
   code_couleur INT,
   nom_couleur CHAR(50),
   image_couleur VARCHAR(50),
   PRIMARY KEY(code_couleur)
);

CREATE TABLE marque(
   code_marque INT,
   nom_marque CHAR(50),
   PRIMARY KEY(code_marque)
);

CREATE TABLE fournisseur(
   code_fournisseur INT,
   nom_fournisseur CHAR(50),
   adresse VARCHAR(50),
   PRIMARY KEY(code_fournisseur)
);

CREATE TABLE ville(
   code_ville INT,
   nom_ville CHAR(50),
   PRIMARY KEY(code_ville)
);

CREATE TABLE userC(
   id INT,
   username VARCHAR,
   password VARCHAR(50),
   role VARCHAR(50),
   est_actif INT(0,1),
   email VARCHAR(50),
   PRIMARY KEY(id)
);

CREATE TABLE etat(
   id INT,
   libelle VARCHAR(50),
   idUser INT NOT NULL,
   PRIMARY KEY(id),
   UNIQUE(idUser),
   FOREIGN KEY(idUser) REFERENCES userC(id)
);

CREATE TABLE Telephone(
   id_telephone VARCHAR(50),
   modele CHAR(50),
   categorie CHAR(50),
   date_sortie DATE,
   prix DOUBLE,
   image_telephone VARCHAR(50),
   code_fournisseur INT NOT NULL,
   id_caracteristique INT NOT NULL,
   code_couleur INT NOT NULL,
   code_marque INT NOT NULL,
   PRIMARY KEY(id_telephone),
   FOREIGN KEY(code_fournisseur) REFERENCES fournisseur(code_fournisseur),
   FOREIGN KEY(id_caracteristique) REFERENCES caracteristique(id_caracteristique),
   FOREIGN KEY(code_couleur) REFERENCES couleur(code_couleur),
   FOREIGN KEY(code_marque) REFERENCES marque(code_marque)
);

CREATE TABLE panier(
   idPanier INT,
   date_ajout DATE,
   prix_unit INT,
   quantite INT,
   id_telephone VARCHAR(50) NOT NULL,
   idUser INT NOT NULL,
   PRIMARY KEY(idPanier),
   UNIQUE(id_telephone),
   UNIQUE(idUser),
   FOREIGN KEY(id_telephone) REFERENCES Telephone(id_telephone),
   FOREIGN KEY(idUser) REFERENCES userC(id)
);

CREATE TABLE commande(
   idCommande INT,
   date_achat DATE,
   idPanier INT NOT NULL,
   PRIMARY KEY(idCommande),
   FOREIGN KEY(idPanier) REFERENCES panier(idPanier)
);

CREATE TABLE ligne_commande(
   idLigneCommande INT,
   prix_unit INT,
   quantite INT,
   idCommande INT NOT NULL,
   PRIMARY KEY(idLigneCommande),
   FOREIGN KEY(idCommande) REFERENCES commande(idCommande)
);

CREATE TABLE se_situe(
   code_fournisseur INT,
   code_ville INT,
   PRIMARY KEY(code_fournisseur, code_ville),
   FOREIGN KEY(code_fournisseur) REFERENCES fournisseur(code_fournisseur),
   FOREIGN KEY(code_ville) REFERENCES ville(code_ville)
);
