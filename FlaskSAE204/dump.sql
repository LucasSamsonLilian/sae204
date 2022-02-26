DROP TABLE IF EXISTS `commande`;

CREATE TABLE `commande` (
  `idCommande` int NOT NULL AUTO_INCREMENT,
  `date_achat` date DEFAULT NULL,
  `idUser` int DEFAULT NULL,
  `idEtat` int DEFAULT NULL,
  PRIMARY KEY (`idCommande`),
  KEY `commande_ibfk_1` (`idUser`),
  KEY `commande_ibfk_2` (`idEtat`),
  CONSTRAINT `commande_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `userc` (`idUser`),
  CONSTRAINT `commande_ibfk_2` FOREIGN KEY (`idEtat`) REFERENCES `etat` (`idEtat`)
);


LOCK TABLES `commande` WRITE;
INSERT INTO `commande` VALUES (1,'2022-02-26',2,3),(2,'2022-02-26',4,3),(3,'2022-02-26',2,3),(4,'2022-02-26',4,3);
UNLOCK TABLES;

DROP TABLE IF EXISTS `couleur`;
CREATE TABLE `couleur` (
  `code_couleur` int NOT NULL AUTO_INCREMENT,
  `nom_couleur` char(50) DEFAULT NULL,
  PRIMARY KEY (`code_couleur`)
) ;


LOCK TABLES `couleur` WRITE;
INSERT INTO `couleur` VALUES (1,'Acajou'),(2,'Amande'),(3,'Argent'),(4,'Blanc'),(5,'noir'),(6,'Zinzolin');
UNLOCK TABLES;


DROP TABLE IF EXISTS `etat`;
CREATE TABLE `etat` (
  `idEtat` int NOT NULL AUTO_INCREMENT,
  `libelle` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idEtat`)
) ;

LOCK TABLES `etat` WRITE;
INSERT INTO `etat` VALUES (1,'en cours de traitement'),(2,'expedie'),(3,'valide');
UNLOCK TABLES;

DROP TABLE IF EXISTS `fournisseur`;
CREATE TABLE `fournisseur` (
  `code_fournisseur` int NOT NULL AUTO_INCREMENT,
  `nom_fournisseur` char(50) DEFAULT NULL,
  `adresse` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`code_fournisseur`)
) ;

LOCK TABLES `fournisseur` WRITE;
INSERT INTO `fournisseur` VALUES (1,'telemago','84 place de Lesage Bourgeoisdan'),(2,'telephonarabe','83 place Odette Legendre Humbertboeuf'),(3,'telemagouille','17 boulevard de Roger Antoine'),(4,'telemacron','39 chemin de Lebon Coulonnec'),(5,'teleferry','45 place Jean Maillot Boulanger');
UNLOCK TABLES;

DROP TABLE IF EXISTS `lignecommande`;
CREATE TABLE `lignecommande` (
  `idLigneCommande` int NOT NULL AUTO_INCREMENT,
  `commande_id` int DEFAULT NULL,
  `telephone_id` int DEFAULT NULL,
  `prix` decimal(10,2) DEFAULT NULL,
  `quantite` int DEFAULT NULL,
  PRIMARY KEY (`idLigneCommande`),
  KEY `ligneCommande_ibfk1` (`commande_id`),
  KEY `ligneCommande_ibfk2` (`telephone_id`),
  CONSTRAINT `ligneCommande_ibfk1` FOREIGN KEY (`commande_id`) REFERENCES `commande` (`idCommande`),
  CONSTRAINT `ligneCommande_ibfk2` FOREIGN KEY (`telephone_id`) REFERENCES `telephone` (`id_telephone`)
) ;

LOCK TABLES `lignecommande` WRITE;
INSERT INTO `lignecommande` VALUES (1,1,1,850.00,1),(2,2,5,65.00,10),(3,3,1,850.00,1),(4,4,2,850.00,1);
UNLOCK TABLES;

DROP TABLE IF EXISTS `marque`;
CREATE TABLE `marque` (
  `code_marque` int NOT NULL,
  `nom_marque` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`code_marque`)
);

LOCK TABLES `marque` WRITE;
INSERT INTO `marque` VALUES (1,'Apple'),(2,'Samsung'),(3,'Xiaomi'),(4,'Oppo'),(5,'LG'),(6,'Huawei'),(3310,'Nokia');
UNLOCK TABLES;

DROP TABLE IF EXISTS `panier`;

CREATE TABLE `panier` (
  `idPanier` int NOT NULL AUTO_INCREMENT,
  `date_ajout` date DEFAULT NULL,
  `prix_unit` double DEFAULT NULL,
  `quantite` int DEFAULT NULL,
  `id_telephone` int DEFAULT NULL,
  `idUser` int NOT NULL,
  `nom` char(50) DEFAULT NULL,
  PRIMARY KEY (`idPanier`),
  KEY `fk_panier_Telephone` (`id_telephone`),
  KEY `fk_panier_userC` (`idUser`),
  CONSTRAINT `fk_panier_Telephone` FOREIGN KEY (`id_telephone`) REFERENCES `telephone` (`id_telephone`),
  CONSTRAINT `fk_panier_userC` FOREIGN KEY (`idUser`) REFERENCES `userc` (`idUser`)
) ;



DROP TABLE IF EXISTS `ram`;
CREATE TABLE `ram` (
  `id_ram` int NOT NULL AUTO_INCREMENT,
  `ram` int DEFAULT NULL,
  PRIMARY KEY (`id_ram`)
) ;


LOCK TABLES `ram` WRITE;
INSERT INTO `ram` VALUES (1,0),(2,2),(3,4),(4,8),(5,12),(6,16);
UNLOCK TABLES;

DROP TABLE IF EXISTS `sesitue`;
CREATE TABLE `sesitue` (
  `code_fournisseur` int NOT NULL,
  `code_ville` int NOT NULL,
  PRIMARY KEY (`code_fournisseur`,`code_ville`),
  KEY `fk_seSitue_ville` (`code_ville`),
  CONSTRAINT `fk_seSitue_fournisseur` FOREIGN KEY (`code_fournisseur`) REFERENCES `fournisseur` (`code_fournisseur`),
  CONSTRAINT `fk_seSitue_ville` FOREIGN KEY (`code_ville`) REFERENCES `ville` (`code_ville`)
);


DROP TABLE IF EXISTS `stockage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stockage` (
  `id_stockage` int NOT NULL AUTO_INCREMENT,
  `stockage` int DEFAULT NULL,
  PRIMARY KEY (`id_stockage`)
) ;

LOCK TABLES `stockage` WRITE;
INSERT INTO `stockage` VALUES (1,0),(2,16),(3,32),(4,64),(5,128),(6,256),(7,512);
UNLOCK TABLES;

DROP TABLE IF EXISTS `telephone`;
CREATE TABLE `telephone` (
  `id_telephone` int NOT NULL AUTO_INCREMENT,
  `modele` char(50) DEFAULT NULL,
  `categorie` char(50) DEFAULT NULL,
  `date_sortie` date DEFAULT NULL,
  `prix` double DEFAULT NULL,
  `image_telephone` varchar(50) DEFAULT NULL,
  `poids` double DEFAULT NULL,
  `taille_ecran` double DEFAULT NULL,
  `ramTel` int NOT NULL,
  `stockageTel` int NOT NULL,
  `code_fournisseur` int NOT NULL,
  `code_couleur` int NOT NULL,
  `code_marque` int NOT NULL,
  `stock` int DEFAULT NULL,
  PRIMARY KEY (`id_telephone`),
  KEY `fk_Telephone_fournisseur` (`code_fournisseur`),
  KEY `fk_Telephone_stockage` (`stockageTel`),
  KEY `fk_Telephone_ram` (`ramTel`),
  KEY `fk_Telehpone_couleur` (`code_couleur`),
  KEY `fk_Telephone_marque` (`code_marque`),
  CONSTRAINT `fk_Telehpone_couleur` FOREIGN KEY (`code_couleur`) REFERENCES `couleur` (`code_couleur`),
  CONSTRAINT `fk_Telephone_fournisseur` FOREIGN KEY (`code_fournisseur`) REFERENCES `fournisseur` (`code_fournisseur`),
  CONSTRAINT `fk_Telephone_marque` FOREIGN KEY (`code_marque`) REFERENCES `marque` (`code_marque`),
  CONSTRAINT `fk_Telephone_ram` FOREIGN KEY (`ramTel`) REFERENCES `ram` (`id_ram`),
  CONSTRAINT `fk_Telephone_stockage` FOREIGN KEY (`stockageTel`) REFERENCES `stockage` (`id_stockage`)
) ;


LOCK TABLES `telephone` WRITE;
INSERT INTO `telephone` VALUES (1,'P30 Pro','smartphone','2005-04-19',850,'img',192,6.47,4,2,3,2,4,100),(2,'IPhone 13','smartphone','2014-09-21',850,'img',174,6,1,3,2,2,2,100),(3,'IPhone 13 Mini','smartphone','2014-09-21',850,'img',141,5,4,4,2,2,2,100),(4,'Galaxy Z Flip3','smartphone','2027-08-21',1050,'img',183,6,3,5,3,1,5,100),(5,'3310','Bi-bande GSM 900/1800','0000-00-00',65,'img',79,2,4,1,1,2,3310,100);
UNLOCK TABLES;

DROP TABLE IF EXISTS `userc`;
CREATE TABLE `userc` (
  `idUser` int NOT NULL AUTO_INCREMENT,
  `email` varchar(50) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(250) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `est_actif` tinyint(1) DEFAULT NULL,
  `adresse` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idUser`)
) ;

LOCK TABLES `userc` WRITE;
INSERT INTO `userc` VALUES (1,'admin@admin.fr','admin','sha256$pBGlZy6UukyHBFDH$2f089c1d26f2741b68c9218a68bfe2e25dbb069c27868a027dad03bcb3d7f69a','ROLE_admin',1,NULL),(2,'client@client.fr','client','sha256$Q1HFT4TKRqnMhlTj$cf3c84ea646430c98d4877769c7c5d2cce1edd10c7eccd2c1f9d6114b74b81c4','ROLE_client',1,NULL),(3,'client2@client2.fr','client2','sha256$ayiON3nJITfetaS8$0e039802d6fac2222e264f5a1e2b94b347501d040d71cfa4264cad6067cf5cf3','ROLE_client',1,NULL),(4,'lucas.ferry.ecole@gmail.com','lucas','sha256$BII1inpyOSYvBR6y$ade02792c005c155897bfdea89e2a74ca830aa2620755eaea91b30b481b2c257','ROLE_client',NULL,NULL);
UNLOCK TABLES;

DROP TABLE IF EXISTS `ville`;

CREATE TABLE `ville` (
  `code_ville` int NOT NULL AUTO_INCREMENT,
  `nom_ville` char(50) DEFAULT NULL,
  PRIMARY KEY (`code_ville`)
) ;

LOCK TABLES `ville` WRITE;
INSERT INTO `ville` VALUES (1,'Le Caire'),(2,'Gizeh'),(3,'Alexandrie'),(4,'Suez'),(5,'Louxor'),(6,'Mansourah'),(7,'Tanta');
UNLOCK TABLES;
