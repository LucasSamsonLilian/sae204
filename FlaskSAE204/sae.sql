SET GLOBAL local_infile=1;

DROP TABLE IF EXISTS  ligneCommande;
DROP TABLE IF EXISTS  commande;
DROP TABLE IF EXISTS  panier;
DROP TABLE IF EXISTS  etat;
DROP TABLE IF EXISTS  userC;
DROP TABLE IF EXISTS  telephone;
DROP TABLE IF EXISTS  seSitue;
DROP TABLE IF EXISTS  fournisseur;
DROP TABLE IF EXISTS  ville;
DROP TABLE IF EXISTS  stockage;
DROP TABLE IF EXISTS ram;
DROP TABLE IF EXISTS  couleur;
DROP TABLE IF EXISTS  marque;
DROP TABLE IF EXISTS pays;

CREATE TABLE IF NOT EXISTS stockage(
   id_stockage INT AUTO_INCREMENT,
   stockage int,
   PRIMARY KEY(id_stockage)
);

INSERT INTO stockage VALUES (1,0),(2,16),(3,32),(4,64),(5,128),(6,256),(7,512);

CREATE TABLE IF NOT EXISTS ram(
   id_ram INT AUTO_INCREMENT,
   ram int,
   PRIMARY KEY(id_ram)
);

INSERT INTO ram VALUES (1,0),(2,2),(3,4),(4,8),(5,12),(6,16);


CREATE TABLE IF NOT EXISTS couleur(
   code_couleur INT AUTO_INCREMENT,
   nom_couleur CHAR(50),
   PRIMARY KEY(code_couleur)
);

INSERT INTO couleur VALUES (1,'Acajou'),(2,'Amande'),(3,'Argent'),(4,'Blanc'),(5,'noir'),(6,'Zinzolin');


CREATE TABLE IF NOT EXISTS marque(
   code_marque INT,
   nom_marque VARCHAR(50),
   image_marque VARCHAR(50),
   PRIMARY KEY(code_marque)
);

INSERT INTO marque VALUES (1,'Apple', 'apple.png'),(2,'Samsung', 'samsung.png'),(3,'Xiaomi', 'xiaomi.png'),(4,'Oppo', 'oppo.png'),(5,'LG', 'lg.png'),(6,'Huawei', 'huawei.png'),(3310,'Nokia', 'nokia.png');


CREATE TABLE IF NOT EXISTS ville(
   code_ville INT AUTO_INCREMENT,
   nom_ville CHAR(50),
   PRIMARY KEY(code_ville)
);

INSERT INTO ville VALUES (1,'Le Caire'),(2,'Gizeh'),(3,'Alexandrie'),(4,'Suez'),(5,'Louxor'),(6,'Mansourah'),(7,'Tanta');


CREATE TABLE IF NOT EXISTS fournisseur(
   code_fournisseur INT AUTO_INCREMENT,
   nom_fournisseur CHAR(50),
   adresse VARCHAR(50),
   PRIMARY KEY(code_fournisseur)
);

INSERT INTO fournisseur VALUES (1,'telemago','84 place de Lesage Bourgeoisdan'),(2,'telephonarabe','83 place Odette Legendre Humbertboeuf'),(3,'telemagouille','17 boulevard de Roger Antoine'),(4,'telemacron','39 chemin de Lebon Coulonnec'),(5,'teleferry','45 place Jean Maillot Boulanger');

CREATE TABLE IF NOT EXISTS pays(
    codePays INT AUTO_INCREMENT,
    libelle VARCHAR(50),
    taxe DECIMAL(7,2),
    PRIMARY KEY (codePays)
);

INSERT INTO pays VALUES (null,'France',2.0),
                        (null,'Allemagne',3.5),
                        (null,'Angleterre',8.1);

SELECT * FROM pays;

CREATE TABLE IF NOT EXISTS userC(
   idUser INT AUTO_INCREMENT,
   email VARCHAR(50),
   username VARCHAR(50),
   password VARCHAR(250),
   role VARCHAR(50),
   est_actif BOOLEAN,
   adresse VARCHAR(50),
   codePays INT NOT NULL,
   CONSTRAINT fk_pays_telephone
   FOREIGN KEY(codePays) REFERENCES pays(codePays),
   PRIMARY KEY(idUser)
);

CREATE TABLE IF NOT EXISTS etat(
    idEtat INT NOT NULL AUTO_INCREMENT,
    libelle VARCHAR(50),
    PRIMARY KEY (idEtat)
);

INSERT INTO etat(libelle) VALUES ('en cours de traitement'),('expedie'),('valide');

CREATE TABLE IF NOT EXISTS telephone(
   id_telephone INT AUTO_INCREMENT,
   modele CHAR(50),
   categorie CHAR(50),
   date_sortie DATE,
   prix DOUBLE,
   image_telephone VARCHAR(50),
   poids DOUBLE,
   taille_ecran DOUBLE,
   ramTel INT NOT NULL,
   stockageTel INT NOT NULL,
   code_fournisseur INT NOT NULL,
   code_couleur INT NOT NULL,
   code_marque INT NOT NULL,
   stock INT,
   PRIMARY KEY(id_telephone),
   CONSTRAINT fk_Telephone_fournisseur
   FOREIGN KEY(code_fournisseur) REFERENCES fournisseur(code_fournisseur),
   CONSTRAINT fk_Telephone_stockage
   FOREIGN KEY(stockageTel) REFERENCES stockage(id_stockage),
   CONSTRAINT fk_Telephone_ram
   FOREIGN KEY(ramTel) REFERENCES ram(id_ram),
   CONSTRAINT fk_Telehpone_couleur
   FOREIGN KEY(code_couleur) REFERENCES couleur(code_couleur),
   CONSTRAINT fk_Telephone_marque
   FOREIGN KEY(code_marque) REFERENCES marque(code_marque)
);

INSERT INTO telephone VALUES (1,'P30 Pro','smartphone','2005-04-19',850,'p30pro.jpg',192,6.47,4,2,3,2,4,100),(2,'IPhone 13','smartphone','2014-09-21',850,'iphone13.jfif',174,6,1,3,2,2,1,100),(3,'IPhone 13 Mini','smartphone','2014-09-21',850,'iphone13.jfif',141,5,4,4,2,2,1,100),(4,'Galaxy Z Flip3','smartphone','2027-08-21',1050,'galaxyZflip3.png',183,6,3,5,3,1,2,100),(5,'3310','Bi-bande GSM 900/1800','1998-01-01',65,'3310.jpg',79,2,4,1,1,2,3310,100);


CREATE TABLE IF NOT EXISTS panier(
   idPanier INT AUTO_INCREMENT,
   date_ajout DATE   ,
   prix_unit DOUBLE,
   quantite INT,
   id_telephone INT,
   idUser INT NOT NULL,
   nom CHAR(50),
   PRIMARY KEY(idPanier),
   CONSTRAINT fk_panier_Telephone
   FOREIGN KEY(id_telephone) REFERENCES telephone(id_telephone),
   CONSTRAINT fk_panier_userC
   FOREIGN KEY(idUser) REFERENCES userC(idUser)
);

CREATE TABLE IF NOT EXISTS commande(
   idCommande INT NOT NULL AUTO_INCREMENT,
   date_achat DATE,
   idUser INT,
   idEtat INT,
   PRIMARY KEY(idCommande),
   CONSTRAINT commande_ibfk_1 FOREIGN KEY(idUser) REFERENCES userC(idUser),
   CONSTRAINT commande_ibfk_2 FOREIGN KEY(idEtat) REFERENCES etat(idEtat)
);

CREATE TABLE IF NOT EXISTS ligneCommande(
   idLigneCommande INT AUTO_INCREMENT,
   commande_id INT,
   telephone_id INT,
   prix decimal(10,2),
   quantite INT,
   PRIMARY KEY(idLigneCommande),
   CONSTRAINT ligneCommande_ibfk1 FOREIGN KEY(commande_id) REFERENCES commande(idCommande),
   CONSTRAINT ligneCommande_ibfk2 FOREIGN KEY(telephone_id) REFERENCES telephone(id_telephone)
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

INSERT INTO userC (idUser, email, username, password, role,  est_actif,codePays) VALUES
(NULL, 'admin@admin.fr', 'admin', 'sha256$pBGlZy6UukyHBFDH$2f089c1d26f2741b68c9218a68bfe2e25dbb069c27868a027dad03bcb3d7f69a', 'ROLE_admin', 1,1);
INSERT INTO userC  (idUser, email, username, password, role, est_actif,codePays) VALUES
(NULL, 'client@client.fr', 'client', 'sha256$Q1HFT4TKRqnMhlTj$cf3c84ea646430c98d4877769c7c5d2cce1edd10c7eccd2c1f9d6114b74b81c4', 'ROLE_client', 1,2);
INSERT INTO userC  (idUser, email, username, password, role,  est_actif,codePays) VALUES
(NULL, 'client2@client2.fr', 'client2', 'sha256$ayiON3nJITfetaS8$0e039802d6fac2222e264f5a1e2b94b347501d040d71cfa4264cad6067cf5cf3', 'ROLE_client',1,2);
