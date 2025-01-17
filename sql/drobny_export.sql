-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: hotel2
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `adresa`
--

DROP TABLE IF EXISTS `adresa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adresa` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `mesto` varchar(30) NOT NULL,
  `cislo_popisne` varchar(30) NOT NULL,
  `psc` varchar(10) NOT NULL,
  `zeme_id` int NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `zeme_ID` (`zeme_id`),
  CONSTRAINT `adresa_ibfk_1` FOREIGN KEY (`zeme_id`) REFERENCES `zeme` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adresa`
--

LOCK TABLES `adresa` WRITE;
/*!40000 ALTER TABLE `adresa` DISABLE KEYS */;
INSERT INTO `adresa` VALUES (1,'Praha','1234','12000',1),(2,'Bratislava','5678','81101',2),(3,'Londýn','9012','WC2N',3),(4,'Nová Ves','1','12345',1);
/*!40000 ALTER TABLE `adresa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_log` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `akce` varchar(50) NOT NULL,
  `detail` text,
  `datum_cas` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `uzivatel_id` int DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `uzivatel_id` (`uzivatel_id`),
  CONSTRAINT `audit_log_ibfk_1` FOREIGN KEY (`uzivatel_id`) REFERENCES `zakaznik` (`ID`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_log`
--

LOCK TABLES `audit_log` WRITE;
/*!40000 ALTER TABLE `audit_log` DISABLE KEYS */;
INSERT INTO `audit_log` VALUES (1,'Vytvoření rezervace','Vytvořena rezervace R001 pro Jana Nováka','2025-01-14 08:48:20',1),(2,'Aktualizace rezervace','Změna stavu rezervace R002 na Dokoncena','2025-01-14 08:48:20',2),(3,'Vytvoření pokoje','Vytvořen pokoj č. 201 typu Apartmán','2025-01-14 08:48:20',NULL),(4,'Zrušení rezervace','Zrušena rezervace č. R0005','2025-01-17 14:36:34',NULL),(5,'Zrušení rezervace','Zrušena rezervace č. R005','2025-01-17 14:38:34',NULL),(6,'Zrušení rezervace','Zrušena rezervace č. R004','2025-01-17 14:40:19',NULL),(7,'Zrušení rezervace','Zrušena rezervace č. R004','2025-01-17 14:48:54',NULL),(8,'Zrušení rezervace','Zrušena rezervace č. R004','2025-01-17 14:49:17',NULL),(9,'Zrušení rezervace','Zrušena rezervace č. R004','2025-01-17 14:52:07',NULL),(10,'Zrušení rezervace','Zrušena rezervace č. R004','2025-01-17 14:53:09',NULL),(11,'Zrušení rezervace','Zrušena rezervace č. R004','2025-01-17 14:53:49',NULL);
/*!40000 ALTER TABLE `audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doprava`
--

DROP TABLE IF EXISTS `doprava`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doprava` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `nazev` varchar(30) NOT NULL,
  `cena` float NOT NULL,
  `popis` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doprava`
--

LOCK TABLES `doprava` WRITE;
/*!40000 ALTER TABLE `doprava` DISABLE KEYS */;
INSERT INTO `doprava` VALUES (1,'Letadlo',1500,'Přeprava letadlem'),(2,'Vlak',500.5,'Pohodlná cesta vlakem'),(3,'Auto',250.75,'Půjčovna aut'),(4,'Pesky',0.1,'Pesky');
/*!40000 ALTER TABLE `doprava` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pokoj`
--

DROP TABLE IF EXISTS `pokoj`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pokoj` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `cislo` varchar(10) NOT NULL,
  `pocet_posteli` decimal(3,0) NOT NULL,
  `typ_pokoje_id` int NOT NULL,
  `velikost_pokoje` float NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `typ_pokoje_ID` (`typ_pokoje_id`),
  CONSTRAINT `pokoj_ibfk_1` FOREIGN KEY (`typ_pokoje_id`) REFERENCES `typ_pokoje` (`ID`),
  CONSTRAINT `pokoj_chk_1` CHECK ((`pocet_posteli` between 1 and 10))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pokoj`
--

LOCK TABLES `pokoj` WRITE;
/*!40000 ALTER TABLE `pokoj` DISABLE KEYS */;
INSERT INTO `pokoj` VALUES (1,'101',1,1,15.5),(2,'102',2,2,20),(3,'201',4,3,40.25),(4,'1424',2,4,13);
/*!40000 ALTER TABLE `pokoj` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pokoj_v_rezervaci`
--

DROP TABLE IF EXISTS `pokoj_v_rezervaci`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pokoj_v_rezervaci` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `pokoj_id` int NOT NULL,
  `cislo_rezervace` varchar(20) NOT NULL,
  `pocet_lidi` decimal(3,0) NOT NULL,
  `datum_rezervace` datetime NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `pokoj_ID` (`pokoj_id`),
  KEY `cislo_rezervace` (`cislo_rezervace`),
  CONSTRAINT `pokoj_v_rezervaci_ibfk_1` FOREIGN KEY (`pokoj_id`) REFERENCES `pokoj` (`ID`),
  CONSTRAINT `pokoj_v_rezervaci_ibfk_2` FOREIGN KEY (`cislo_rezervace`) REFERENCES `rezervace` (`cislo_rezervace`),
  CONSTRAINT `pokoj_v_rezervaci_chk_1` CHECK ((`pocet_lidi` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pokoj_v_rezervaci`
--

LOCK TABLES `pokoj_v_rezervaci` WRITE;
/*!40000 ALTER TABLE `pokoj_v_rezervaci` DISABLE KEYS */;
INSERT INTO `pokoj_v_rezervaci` VALUES (1,1,'R001',1,'2025-01-14 08:48:20'),(2,2,'R002',4,'2025-01-14 08:48:20'),(3,3,'R003',4,'2025-01-14 08:48:20');
/*!40000 ALTER TABLE `pokoj_v_rezervaci` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rezervace`
--

DROP TABLE IF EXISTS `rezervace`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rezervace` (
  `cislo_rezervace` varchar(20) NOT NULL,
  `datum_od` date NOT NULL,
  `datum_do` date NOT NULL,
  `check_in_do` time NOT NULL,
  `check_out_do` time NOT NULL,
  `celkova_cena` float NOT NULL,
  `snidane` tinyint(1) DEFAULT NULL,
  `vratna_rezervace` tinyint(1) DEFAULT NULL,
  `pocet_deti` decimal(3,0) NOT NULL,
  `pocet_dospelych` decimal(3,0) NOT NULL,
  `adresa_id` int NOT NULL,
  `zakaznik_id` int NOT NULL,
  `doprava_id` int NOT NULL,
  `stav` enum('Probiha','Dokoncena') NOT NULL DEFAULT 'Probiha',
  PRIMARY KEY (`cislo_rezervace`),
  KEY `adresa_ID` (`adresa_id`),
  KEY `zakaznik_ID` (`zakaznik_id`),
  KEY `doprava_ID` (`doprava_id`),
  KEY `idx_rezervace_cislo` (`cislo_rezervace`),
  KEY `idx_rezervace_datum` (`datum_od`,`datum_do`),
  CONSTRAINT `rezervace_ibfk_1` FOREIGN KEY (`adresa_id`) REFERENCES `adresa` (`ID`),
  CONSTRAINT `rezervace_ibfk_2` FOREIGN KEY (`zakaznik_id`) REFERENCES `zakaznik` (`ID`),
  CONSTRAINT `rezervace_ibfk_3` FOREIGN KEY (`doprava_id`) REFERENCES `doprava` (`ID`),
  CONSTRAINT `rezervace_chk_1` CHECK (((`pocet_deti` >= 0) and (`pocet_dospelych` > 0))),
  CONSTRAINT `rezervace_chk_2` CHECK ((`datum_od` < `datum_do`)),
  CONSTRAINT `rezervace_chk_3` CHECK ((`celkova_cena` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rezervace`
--

LOCK TABLES `rezervace` WRITE;
/*!40000 ALTER TABLE `rezervace` DISABLE KEYS */;
INSERT INTO `rezervace` VALUES ('1','2025-01-01','2025-01-07','00:00:12','00:00:22',10000,0,0,1,1,1,1,1,'Probiha'),('R001','2025-01-20','2025-01-25','14:00:00','11:00:00',5000,1,0,0,1,1,1,1,'Probiha'),('R002','2025-02-01','2025-02-05','15:00:00','10:00:00',3000.5,0,1,2,2,2,2,2,'Dokoncena'),('R003','2025-03-10','2025-03-15','13:00:00','12:00:00',7500.75,1,1,1,3,3,3,3,'Probiha'),('R004','2025-01-01','2025-01-07','00:00:12','00:00:22',10000,1,0,1,1,1,1,1,'Probiha'),('R005','2025-01-01','2025-01-07','00:00:12','00:00:22',10000,1,0,1,1,1,1,1,'Dokoncena'),('R006','2025-01-01','2025-01-07','00:00:12','00:00:22',10000,0,1,1,1,1,1,1,'Probiha'),('R007','2025-01-01','2025-01-07','00:00:12','00:00:22',5000,1,1,1,1,1,1,1,'Dokoncena');
/*!40000 ALTER TABLE `rezervace` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `typ_pokoje`
--

DROP TABLE IF EXISTS `typ_pokoje`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `typ_pokoje` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `nazev` varchar(30) NOT NULL,
  `popis` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `typ_pokoje`
--

LOCK TABLES `typ_pokoje` WRITE;
/*!40000 ALTER TABLE `typ_pokoje` DISABLE KEYS */;
INSERT INTO `typ_pokoje` VALUES (1,'Jednolůžkový','Pokoj pro jednu osobu'),(2,'Dvoulůžkový','Pokoj pro dvě osoby'),(3,'Apartmán','Luxusní apartmán s kuchyňkou'),(4,'nazev','popis'),(5,'Single Room','A room for one person'),(10,'Moje1','Muj pokoj1');
/*!40000 ALTER TABLE `typ_pokoje` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `view_financniprehledrezervaci`
--

DROP TABLE IF EXISTS `view_financniprehledrezervaci`;
/*!50001 DROP VIEW IF EXISTS `view_financniprehledrezervaci`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_financniprehledrezervaci` AS SELECT 
 1 AS `cislo_rezervace`,
 1 AS `jmeno`,
 1 AS `prijmeni`,
 1 AS `datum_od`,
 1 AS `datum_do`,
 1 AS `celkova_cena`,
 1 AS `pocet_dni`,
 1 AS `prumerna_denni_cena`,
 1 AS `snizena_cena`,
 1 AS `doprava`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_obsazenostpokojuvrealnemcase`
--

DROP TABLE IF EXISTS `view_obsazenostpokojuvrealnemcase`;
/*!50001 DROP VIEW IF EXISTS `view_obsazenostpokojuvrealnemcase`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_obsazenostpokojuvrealnemcase` AS SELECT 
 1 AS `pokoj_id`,
 1 AS `pokoj_cislo`,
 1 AS `pocet_posteli`,
 1 AS `stav`,
 1 AS `cislo_rezervace`,
 1 AS `datum_od`,
 1 AS `datum_do`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_prumernadelkapobytuhostu`
--

DROP TABLE IF EXISTS `view_prumernadelkapobytuhostu`;
/*!50001 DROP VIEW IF EXISTS `view_prumernadelkapobytuhostu`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_prumernadelkapobytuhostu` AS SELECT 
 1 AS `jmeno`,
 1 AS `prijmeni`,
 1 AS `prumerna_delka_pobytu`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_statistikyhostupodlezemi`
--

DROP TABLE IF EXISTS `view_statistikyhostupodlezemi`;
/*!50001 DROP VIEW IF EXISTS `view_statistikyhostupodlezemi`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_statistikyhostupodlezemi` AS SELECT 
 1 AS `zeme`,
 1 AS `pocet_rezervaci`,
 1 AS `prumerny_pocet_hostu_na_rezervaci`,
 1 AS `celkovy_pocet_hostu`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `zakaznik`
--

DROP TABLE IF EXISTS `zakaznik`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `zakaznik` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `jmeno` varchar(30) NOT NULL,
  `prijmeni` varchar(30) NOT NULL,
  `telefon` varchar(20) NOT NULL,
  `email` varchar(30) NOT NULL,
  `zeme_id` int NOT NULL,
  `vek` int NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `telefon` (`telefon`),
  UNIQUE KEY `email` (`email`),
  KEY `zeme_ID` (`zeme_id`),
  KEY `idx_zakaznik_jmeno_prijmeni` (`jmeno`,`prijmeni`),
  CONSTRAINT `zakaznik_ibfk_1` FOREIGN KEY (`zeme_id`) REFERENCES `zeme` (`ID`),
  CONSTRAINT `zakaznik_chk_1` CHECK ((`email` like _utf8mb4'%@%'))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zakaznik`
--

LOCK TABLES `zakaznik` WRITE;
/*!40000 ALTER TABLE `zakaznik` DISABLE KEYS */;
INSERT INTO `zakaznik` VALUES (1,'Jan','Novák','123456789','jan.novak@example.com',1,30),(2,'Mária','Kováčová','987654321','maria.kovacova@example.com',2,25),(3,'John','Smith','555123456','john.smith@example.com',3,46),(4,'Vojta','Nevim','123 231 421','ftmovojtus@gmail.com',1,19);
/*!40000 ALTER TABLE `zakaznik` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zeme`
--

DROP TABLE IF EXISTS `zeme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `zeme` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `nazev` varchar(30) NOT NULL,
  `iso_kod` varchar(10) NOT NULL,
  `mena` varchar(30) NOT NULL,
  `uredni_jazyk` varchar(30) NOT NULL,
  `region` varchar(30) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zeme`
--

LOCK TABLES `zeme` WRITE;
/*!40000 ALTER TABLE `zeme` DISABLE KEYS */;
INSERT INTO `zeme` VALUES (1,'Česká republika','CZ','Kč','Čeština','Evropa'),(2,'Slovensko','SK','€','Slovenčina','Evropa'),(3,'Spojené království','GB','£','Angličtina','Evropa'),(21,'nazev','ISO_kod','mena','uredni_jazyk','region'),(22,'Czech Republic','CZ','Czech Koruna','Czech','Europe'),(23,'United States','US','US Dollar','English','North America');
/*!40000 ALTER TABLE `zeme` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `view_financniprehledrezervaci`
--

/*!50001 DROP VIEW IF EXISTS `view_financniprehledrezervaci`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_financniprehledrezervaci` AS select `r`.`cislo_rezervace` AS `cislo_rezervace`,`z`.`jmeno` AS `jmeno`,`z`.`prijmeni` AS `prijmeni`,`r`.`datum_od` AS `datum_od`,`r`.`datum_do` AS `datum_do`,`r`.`celkova_cena` AS `celkova_cena`,(to_days(`r`.`datum_do`) - to_days(`r`.`datum_od`)) AS `pocet_dni`,round((`r`.`celkova_cena` / (to_days(`r`.`datum_do`) - to_days(`r`.`datum_od`))),2) AS `prumerna_denni_cena`,(case when (`r`.`snidane` = 'Y') then 'Ano' else 'Ne' end) AS `snizena_cena`,`d`.`nazev` AS `doprava` from ((`rezervace` `r` join `zakaznik` `z` on((`r`.`zakaznik_id` = `z`.`ID`))) left join `doprava` `d` on((`r`.`doprava_id` = `d`.`ID`))) where (`r`.`datum_od` >= (curdate() - interval 1 year)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_obsazenostpokojuvrealnemcase`
--

/*!50001 DROP VIEW IF EXISTS `view_obsazenostpokojuvrealnemcase`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_obsazenostpokojuvrealnemcase` AS select `p`.`ID` AS `pokoj_id`,`p`.`cislo` AS `pokoj_cislo`,`p`.`pocet_posteli` AS `pocet_posteli`,(case when (`r`.`cislo_rezervace` is not null) then 'Obsazeno' else 'Volno' end) AS `stav`,`r`.`cislo_rezervace` AS `cislo_rezervace`,`r`.`datum_od` AS `datum_od`,`r`.`datum_do` AS `datum_do` from ((`pokoj` `p` left join `pokoj_v_rezervaci` `pvr` on((`p`.`ID` = `pvr`.`pokoj_id`))) left join `rezervace` `r` on((`pvr`.`cislo_rezervace` = `r`.`cislo_rezervace`))) where (((`r`.`datum_od` <= curdate()) and (`r`.`datum_do` >= curdate())) or (`r`.`cislo_rezervace` is null)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_prumernadelkapobytuhostu`
--

/*!50001 DROP VIEW IF EXISTS `view_prumernadelkapobytuhostu`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_prumernadelkapobytuhostu` AS select `z`.`jmeno` AS `jmeno`,`z`.`prijmeni` AS `prijmeni`,round(avg((to_days(`r`.`datum_do`) - to_days(`r`.`datum_od`))),2) AS `prumerna_delka_pobytu` from (`zakaznik` `z` join `rezervace` `r` on((`z`.`ID` = `r`.`zakaznik_id`))) group by `z`.`ID`,`z`.`jmeno`,`z`.`prijmeni` having (`prumerna_delka_pobytu` > 0) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_statistikyhostupodlezemi`
--

/*!50001 DROP VIEW IF EXISTS `view_statistikyhostupodlezemi`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_statistikyhostupodlezemi` AS select `ze`.`nazev` AS `zeme`,count(distinct `r`.`cislo_rezervace`) AS `pocet_rezervaci`,round(avg((`r`.`pocet_deti` + `r`.`pocet_dospelych`)),2) AS `prumerny_pocet_hostu_na_rezervaci`,sum((`r`.`pocet_deti` + `r`.`pocet_dospelych`)) AS `celkovy_pocet_hostu` from ((`rezervace` `r` join `zakaznik` `z` on((`r`.`zakaznik_id` = `z`.`ID`))) join `zeme` `ze` on((`z`.`zeme_id` = `ze`.`ID`))) group by `ze`.`ID`,`ze`.`nazev` having (`pocet_rezervaci` > 0) order by `celkovy_pocet_hostu` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-17 21:16:20
