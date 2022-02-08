DROP TABLE IF EXISTS  ligneCommande;
DROP TABLE IF EXISTS  commande;
DROP TABLE IF EXISTS  panier;
DROP TABLE IF EXISTS  etat;
DROP TABLE IF EXISTS  userC;
DROP TABLE IF EXISTS  Telephone;
DROP TABLE IF EXISTS  seSitue;
DROP TABLE IF EXISTS  ville;
DROP TABLE IF EXISTS  fournisseur;
DROP TABLE IF EXISTS  caracteristique;
DROP TABLE IF EXISTS  couleur;
DROP TABLE IF EXISTS  marque;

CREATE TABLE IF NOT EXISTS caracteristique(
   id_caracteristique INT AUTO_INCREMENT,
   stockage DOUBLE,
   RAM INT,
   PRIMARY KEY(id_caracteristique)
);

CREATE TABLE IF NOT EXISTS couleur(
   code_couleur INT,
   nom_couleur CHAR(50),
   image_couleur VARCHAR(50),
   PRIMARY KEY(code_couleur)
);

CREATE TABLE IF NOT EXISTS marque(
   code_marque INT,
   nom_marque CHAR(50),
   PRIMARY KEY(code_marque)
);

CREATE TABLE IF NOT EXISTS fournisseur(
   code_fournisseur INT,
   nom_fournisseur CHAR(50),
   adresse VARCHAR(50),
   PRIMARY KEY(code_fournisseur)
);

CREATE TABLE IF NOT EXISTS ville(
   code_ville INT,
   nom_ville CHAR(50),
   PRIMARY KEY(code_ville)
);

CREATE TABLE IF NOT EXISTS userC(
   idUser INT AUTO_INCREMENT,
   email VARCHAR(50),
   username VARCHAR(50),
   password VARCHAR(250),
   role VARCHAR(50),
   est_actif BOOLEAN,
   PRIMARY KEY(idUser)
);

CREATE TABLE IF NOT EXISTS etat(
   idEtat INT AUTO_INCREMENT,
   libelle VARCHAR(50),
   idUser INT NOT NULL,
   PRIMARY KEY(idEtat),
   UNIQUE(idUser),
   CONSTRAINT fk_etat_userC
   FOREIGN KEY(idUser) REFERENCES userC(idUser)
);

CREATE TABLE IF NOT EXISTS Telephone(
   id_telephone INT AUTO_INCREMENT,
   modele CHAR(50),
   categorie CHAR(50),
   date_sortie DATE,
   prix DOUBLE,
   image_telephone VARCHAR(50),
   code_fournisseur INT NOT NULL,
   id_caracteristique INT NOT NULL,
   code_couleur INT NOT NULL,
   code_marque INT NOT NULL,
   poids DOUBLE,
   taille_ecran DOUBLE,
   PRIMARY KEY(id_telephone),
   CONSTRAINT fk_Telephone_fournisseur
   FOREIGN KEY(code_fournisseur) REFERENCES fournisseur(code_fournisseur),
   CONSTRAINT fk_Telephone_caracteristique
   FOREIGN KEY(id_caracteristique) REFERENCES caracteristique(id_caracteristique),
   CONSTRAINT fk_Telehpone_couleur
   FOREIGN KEY(code_couleur) REFERENCES couleur(code_couleur),
   CONSTRAINT fk_Telephone_marque
   FOREIGN KEY(code_marque) REFERENCES marque(code_marque)
);

CREATE TABLE IF NOT EXISTS panier(
   idPanier INT AUTO_INCREMENT,
   date_ajout DATE,
   prix_unit INT,
   quantite INT,
   id_telephone INT,
   idUser INT NOT NULL,
   PRIMARY KEY(idPanier),
   UNIQUE(id_telephone),
   UNIQUE(idUser),
   CONSTRAINT fk_panier_Telephone
   FOREIGN KEY(id_telephone) REFERENCES Telephone(id_telephone),
   CONSTRAINT fk_panier_userC
   FOREIGN KEY(idUser) REFERENCES userC(idUser)
);

CREATE TABLE IF NOT EXISTS commande(
   idCommande INT AUTO_INCREMENT,
   date_achat DATE,
   idPanier INT NOT NULL,
   PRIMARY KEY(idCommande),
   CONSTRAINT fk_commande_panier
   FOREIGN KEY(idPanier) REFERENCES panier(idPanier)
);

CREATE TABLE IF NOT EXISTS ligneCommande(
   idLigneCommande INT AUTO_INCREMENT,
   prix_unit INT,
   quantite INT,
   idCommande INT NOT NULL,
   PRIMARY KEY(idLigneCommande),
   CONSTRAINT fk_ligneCommande_commande
   FOREIGN KEY(idCommande) REFERENCES commande(idCommande)
);

CREATE TABLE IF NOT EXISTS seSitue(
   code_fournisseur INT,
   code_ville INT,
   PRIMARY KEY(code_fournisseur, code_ville),
   CONSTRAINT fk_seSitue_fournisseur
   FOREIGN KEY(code_fournisseur) REFERENCES fournisseur(code_fournisseur),
   CONSTRAINT fk_seSitue_ville
   FOREIGN KEY(code_ville) REFERENCES ville(code_ville)
);

INSERT INTO userC (idUser, email, username, password, role,  est_actif) VALUES
(NULL, 'admin@admin.fr', 'admin', 'sha256$pBGlZy6UukyHBFDH$2f089c1d26f2741b68c9218a68bfe2e25dbb069c27868a027dad03bcb3d7f69a', 'ROLE_admin', 1);
INSERT INTO userC  (idUser, email, username, password, role, est_actif) VALUES
(NULL, 'client@client.fr', 'client', 'sha256$Q1HFT4TKRqnMhlTj$cf3c84ea646430c98d4877769c7c5d2cce1edd10c7eccd2c1f9d6114b74b81c4', 'ROLE_client', 1);
INSERT INTO userC  (idUser, email, username, password, role,  est_actif) VALUES
(NULL, 'client2@client2.fr', 'client2', 'sha256$ayiON3nJITfetaS8$0e039802d6fac2222e264f5a1e2b94b347501d040d71cfa4264cad6067cf5cf3', 'ROLE_client',1);