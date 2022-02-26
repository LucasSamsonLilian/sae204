DROP TABLE IF EXISTS `article`;

CREATE TABLE `article` (
  `idArticle` int NOT NULL AUTO_INCREMENT,
  `designation` varchar(255) DEFAULT NULL,
  `prix` decimal(5,2) NOT NULL,
  PRIMARY KEY (`idArticle`)
);

LOCK TABLES `article` WRITE;
INSERT INTO `article` VALUES (1,'G',5.25),(2,'g',5.25),(3,'Mouchoir ( hygi',2.54),(4,'Coca cola ( boisson )',1.52),(5,'Salade ( l',2.00),(6,'Choux ( l',2.50),(7,'Pomme de terre ( l',1.50),(8,'Tomate ( l',1.50),(9,'Haricot ( l',6.50),(10,'Potiron ( l',3.00),(11,'Poireau ( l',1.50),(12,'Fenouil ( l',3.00),(13,'Pissenlit ( l',5.00),(14,'Petit pois ( l',6.00),(15,'Poivron ( l',3.00),(16,'Radis ( l',2.00),(17,'Pomme ( fruit ) ',3.00),(18,'Perrier ( 1L eau ) ',1.50),(19,'Vittel ( 1L eau ) ',1.80);
UNLOCK TABLES;


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

--
-- Dumping data for table `commande`
--

LOCK TABLES `commande` WRITE;
/*!40000 ALTER TABLE `commande` DISABLE KEYS */;
INSERT INTO `commande` VALUES (1,'2022-02-26',2,3),(2,'2022-02-26',4,3),(3,'2022-02-26',2,3),(4,'2022-02-26',4,3);
/*!40000 ALTER TABLE `commande` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `couleur`
--

DROP TABLE IF EXISTS `couleur`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `couleur` (
  `code_couleur` int NOT NULL AUTO_INCREMENT,
  `nom_couleur` char(50) DEFAULT NULL,
  PRIMARY KEY (`code_couleur`)
) ;

--
-- Dumping data for table `couleur`
--

LOCK TABLES `couleur` WRITE;
/*!40000 ALTER TABLE `couleur` DISABLE KEYS */;
INSERT INTO `couleur` VALUES (1,'Acajou\r'),(2,'Amande\r'),(3,'Argent\r'),(4,'Blanc\r'),(5,'noir\r'),(6,'Zinzolin\r');
/*!40000 ALTER TABLE `couleur` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `etat`
--

DROP TABLE IF EXISTS `etat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `etat` (
  `idEtat` int NOT NULL AUTO_INCREMENT,
  `libelle` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idEtat`)
) ;

--
-- Dumping data for table `etat`
--

LOCK TABLES `etat` WRITE;
/*!40000 ALTER TABLE `etat` DISABLE KEYS */;
INSERT INTO `etat` VALUES (1,'en cours de traitement'),(2,'expedie'),(3,'valide');
/*!40000 ALTER TABLE `etat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fournisseur`
--

DROP TABLE IF EXISTS `fournisseur`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fournisseur` (
  `code_fournisseur` int NOT NULL AUTO_INCREMENT,
  `nom_fournisseur` char(50) DEFAULT NULL,
  `adresse` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`code_fournisseur`)
) ;

--
-- Dumping data for table `fournisseur`
--

LOCK TABLES `fournisseur` WRITE;
/*!40000 ALTER TABLE `fournisseur` DISABLE KEYS */;
INSERT INTO `fournisseur` VALUES (1,'telemago','84 place de Lesage Bourgeoisdan\r'),(2,'telephonarabe','83 place Odette Legendre Humbertboeuf\r'),(3,'telemagouille','17 boulevard de Roger Antoine\r'),(4,'telemacron','39 chemin de Lebon Coulonnec\r'),(5,'teleferry','45 place Jean Maillot Boulanger\r');
/*!40000 ALTER TABLE `fournisseur` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lignecommande`
--

DROP TABLE IF EXISTS `lignecommande`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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

--
-- Dumping data for table `lignecommande`
--

LOCK TABLES `lignecommande` WRITE;
/*!40000 ALTER TABLE `lignecommande` DISABLE KEYS */;
INSERT INTO `lignecommande` VALUES (1,1,1,850.00,1),(2,2,5,65.00,10),(3,3,1,850.00,1),(4,4,2,850.00,1);
/*!40000 ALTER TABLE `lignecommande` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marque`
--

DROP TABLE IF EXISTS `marque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marque` (
  `code_marque` int NOT NULL,
  `nom_marque` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`code_marque`)
);

--
-- Dumping data for table `marque`
--

LOCK TABLES `marque` WRITE;
/*!40000 ALTER TABLE `marque` DISABLE KEYS */;
INSERT INTO `marque` VALUES (1,'Apple\r'),(2,'Samsung\r'),(3,'Xiaomi\r'),(4,'Oppo\r'),(5,'LG\r'),(6,'Huawei\r'),(3310,'Nokia\r');
/*!40000 ALTER TABLE `marque` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `panier`
--

DROP TABLE IF EXISTS `panier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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

--
-- Dumping data for table `panier`
--

LOCK TABLES `panier` WRITE;
/*!40000 ALTER TABLE `panier` DISABLE KEYS */;
/*!40000 ALTER TABLE `panier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ram`
--

DROP TABLE IF EXISTS `ram`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ram` (
  `id_ram` int NOT NULL AUTO_INCREMENT,
  `ram` int DEFAULT NULL,
  PRIMARY KEY (`id_ram`)
) ;

--
-- Dumping data for table `ram`
--

LOCK TABLES `ram` WRITE;
/*!40000 ALTER TABLE `ram` DISABLE KEYS */;
INSERT INTO `ram` VALUES (1,0),(2,2),(3,4),(4,8),(5,12),(6,16);
/*!40000 ALTER TABLE `ram` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sesitue`
--

DROP TABLE IF EXISTS `sesitue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sesitue` (
  `code_fournisseur` int NOT NULL,
  `code_ville` int NOT NULL,
  PRIMARY KEY (`code_fournisseur`,`code_ville`),
  KEY `fk_seSitue_ville` (`code_ville`),
  CONSTRAINT `fk_seSitue_fournisseur` FOREIGN KEY (`code_fournisseur`) REFERENCES `fournisseur` (`code_fournisseur`),
  CONSTRAINT `fk_seSitue_ville` FOREIGN KEY (`code_ville`) REFERENCES `ville` (`code_ville`)
);

--
-- Dumping data for table `sesitue`
--

LOCK TABLES `sesitue` WRITE;
/*!40000 ALTER TABLE `sesitue` DISABLE KEYS */;
/*!40000 ALTER TABLE `sesitue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stockage`
--

DROP TABLE IF EXISTS `stockage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stockage` (
  `id_stockage` int NOT NULL AUTO_INCREMENT,
  `stockage` int DEFAULT NULL,
  PRIMARY KEY (`id_stockage`)
) ;

--
-- Dumping data for table `stockage`
--

LOCK TABLES `stockage` WRITE;
/*!40000 ALTER TABLE `stockage` DISABLE KEYS */;
INSERT INTO `stockage` VALUES (1,0),(2,16),(3,32),(4,64),(5,128),(6,256),(7,512);
/*!40000 ALTER TABLE `stockage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `telephone`
--

DROP TABLE IF EXISTS `telephone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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

--
-- Dumping data for table `telephone`
--

LOCK TABLES `telephone` WRITE;
/*!40000 ALTER TABLE `telephone` DISABLE KEYS */;
INSERT INTO `telephone` VALUES (1,'P30 Pro','smartphone','2005-04-19',850,'img',192,6.47,4,2,3,2,4,100),(2,'IPhone 13','smartphone','2014-09-21',850,'img',174,6,1,3,2,2,2,100),(3,'IPhone 13 Mini','smartphone','2014-09-21',850,'img',141,5,4,4,2,2,2,100),(4,'Galaxy Z Flip3','smartphone','2027-08-21',1050,'img',183,6,3,5,3,1,5,100),(5,'3310','Bi-bande GSM 900/1800','0000-00-00',65,'img',79,2,4,1,1,2,3310,100);
/*!40000 ALTER TABLE `telephone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userc`
--

DROP TABLE IF EXISTS `userc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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

--
-- Dumping data for table `userc`
--

LOCK TABLES `userc` WRITE;
/*!40000 ALTER TABLE `userc` DISABLE KEYS */;
INSERT INTO `userc` VALUES (1,'admin@admin.fr','admin','sha256$pBGlZy6UukyHBFDH$2f089c1d26f2741b68c9218a68bfe2e25dbb069c27868a027dad03bcb3d7f69a','ROLE_admin',1,NULL),(2,'client@client.fr','client','sha256$Q1HFT4TKRqnMhlTj$cf3c84ea646430c98d4877769c7c5d2cce1edd10c7eccd2c1f9d6114b74b81c4','ROLE_client',1,NULL),(3,'client2@client2.fr','client2','sha256$ayiON3nJITfetaS8$0e039802d6fac2222e264f5a1e2b94b347501d040d71cfa4264cad6067cf5cf3','ROLE_client',1,NULL),(4,'lucas.ferry.ecole@gmail.com','lucas','sha256$BII1inpyOSYvBR6y$ade02792c005c155897bfdea89e2a74ca830aa2620755eaea91b30b481b2c257','ROLE_client',NULL,NULL);
/*!40000 ALTER TABLE `userc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ville`
--

DROP TABLE IF EXISTS `ville`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ville` (
  `code_ville` int NOT NULL AUTO_INCREMENT,
  `nom_ville` char(50) DEFAULT NULL,
  PRIMARY KEY (`code_ville`)
) ;

--
-- Dumping data for table `ville`
--

LOCK TABLES `ville` WRITE;
/*!40000 ALTER TABLE `ville` DISABLE KEYS */;
INSERT INTO `ville` VALUES (1,'Le Caire\r'),(2,'Gizeh\r'),(3,'Alexandrie\r'),(4,'Suez \r'),(5,'Louxor \r'),(6,'Mansourah\r'),(7,'Tanta \r');
/*!40000 ALTER TABLE `ville` ENABLE KEYS */;
UNLOCK TABLES;
