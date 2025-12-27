-- MySQL dump 10.13  Distrib 8.0.44, for macos15 (arm64)
--
-- Host: localhost    Database: odeme_sistemi
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `__EFMigrationsHistory`
--

DROP TABLE IF EXISTS `__EFMigrationsHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `__EFMigrationsHistory` (
  `MigrationId` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ProductVersion` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`MigrationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `__EFMigrationsHistory`
--

LOCK TABLES `__EFMigrationsHistory` WRITE;
/*!40000 ALTER TABLE `__EFMigrationsHistory` DISABLE KEYS */;
INSERT INTO `__EFMigrationsHistory` VALUES ('20251221192034_AddFraudFields','9.0.0');
/*!40000 ALTER TABLE `__EFMigrationsHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fraud_incelemeleri`
--

DROP TABLE IF EXISTS `fraud_incelemeleri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fraud_incelemeleri` (
  `id` int NOT NULL AUTO_INCREMENT,
  `islem_id` int NOT NULL,
  `inceleyen_kullanici_id` int NOT NULL,
  `karar` enum('GERCEK','SAHTE') COLLATE utf8mb4_unicode_ci NOT NULL,
  `aciklama` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `inceleme_tarihi` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_fraud_islem` (`islem_id`),
  KEY `fk_fraud_inceleyen` (`inceleyen_kullanici_id`),
  KEY `idx_fraud_inceleme_tarih` (`inceleme_tarihi`),
  CONSTRAINT `fk_fraud_inceleyen` FOREIGN KEY (`inceleyen_kullanici_id`) REFERENCES `kullanicilar` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_fraud_islem` FOREIGN KEY (`islem_id`) REFERENCES `islemler` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fraud_incelemeleri`
--

LOCK TABLES `fraud_incelemeleri` WRITE;
/*!40000 ALTER TABLE `fraud_incelemeleri` DISABLE KEYS */;
/*!40000 ALTER TABLE `fraud_incelemeleri` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesaplar`
--

DROP TABLE IF EXISTS `hesaplar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hesaplar` (
  `id` int NOT NULL AUTO_INCREMENT,
  `kullanici_id` int NOT NULL,
  `hesap_no` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bakiye` decimal(18,2) NOT NULL DEFAULT '0.00',
  `para_birimi` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'TRY',
  `durum` enum('AKTIF','KAPALI') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'AKTIF',
  `olusturma_tarihi` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hesap_no` (`hesap_no`),
  KEY `fk_hesaplar_kullanici` (`kullanici_id`),
  CONSTRAINT `fk_hesaplar_kullanici` FOREIGN KEY (`kullanici_id`) REFERENCES `kullanicilar` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesaplar`
--

LOCK TABLES `hesaplar` WRITE;
/*!40000 ALTER TABLE `hesaplar` DISABLE KEYS */;
INSERT INTO `hesaplar` VALUES (1,2,'ACC1001',1365.00,'TRY','AKTIF','2025-12-10 15:40:21'),(2,2,'ACC1002',500.00,'TRY','AKTIF','2025-12-10 15:40:21'),(3,3,'ACC2001',760.00,'TRY','AKTIF','2025-12-10 15:40:21');
/*!40000 ALTER TABLE `hesaplar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `islemler`
--

DROP TABLE IF EXISTS `islemler`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `islemler` (
  `id` int NOT NULL AUTO_INCREMENT,
  `kaynak_hesap_id` int DEFAULT NULL,
  `hedef_hesap_id` int DEFAULT NULL,
  `tutar` decimal(18,2) NOT NULL,
  `islem_tipi` enum('YUKLEME','ODEME','TRANSFER','IADE') COLLATE utf8mb4_unicode_ci NOT NULL,
  `eski_bakiye_kaynak` decimal(18,2) DEFAULT NULL,
  `yeni_bakiye_kaynak` decimal(18,2) DEFAULT NULL,
  `eski_bakiye_hedef` decimal(18,2) DEFAULT NULL,
  `yeni_bakiye_hedef` decimal(18,2) DEFAULT NULL,
  `islem_zamani` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `durum` enum('BASARILI','IPTAL','BEKLIYOR') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'BASARILI',
  `aciklama` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_fraud_etiketi` tinyint(1) DEFAULT NULL,
  `fraud_tahmin_skoru` decimal(5,4) DEFAULT NULL,
  `fraud_model_id` int DEFAULT NULL,
  `fraud_tahmin_tarihi` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_islem_fraud_model` (`fraud_model_id`),
  KEY `idx_islemler_kaynak_hesap` (`kaynak_hesap_id`),
  KEY `idx_islemler_hedef_hesap` (`hedef_hesap_id`),
  KEY `idx_islemler_zaman` (`islem_zamani`),
  KEY `idx_islemler_fraud_skor` (`fraud_tahmin_skoru`,`is_fraud_etiketi`),
  KEY `idx_islemler_tipi_zaman` (`islem_tipi`,`islem_zamani`),
  CONSTRAINT `fk_islem_fraud_model` FOREIGN KEY (`fraud_model_id`) REFERENCES `ml_modelleri` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_islem_hedef_hesap` FOREIGN KEY (`hedef_hesap_id`) REFERENCES `hesaplar` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_islem_kaynak_hesap` FOREIGN KEY (`kaynak_hesap_id`) REFERENCES `hesaplar` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `islemler_chk_1` CHECK ((`tutar` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `islemler`
--

LOCK TABLES `islemler` WRITE;
/*!40000 ALTER TABLE `islemler` DISABLE KEYS */;
INSERT INTO `islemler` VALUES (1,NULL,1,200.00,'YUKLEME',NULL,NULL,1000.00,1200.00,'2025-12-09 15:40:21','BASARILI',NULL,0,0.0500,1,'2025-12-09 15:40:21'),(2,1,3,150.00,'TRANSFER',1200.00,1050.00,750.00,900.00,'2025-12-10 15:40:21','BASARILI',NULL,0,0.1500,1,'2025-12-10 15:40:21'),(3,NULL,1,50.00,'YUKLEME',NULL,NULL,1000.00,1050.00,'2025-12-10 15:41:25','BASARILI',NULL,NULL,NULL,NULL,NULL),(4,1,3,10.00,'TRANSFER',1050.00,1040.00,750.00,760.00,'2025-12-10 15:41:25','BASARILI',NULL,NULL,NULL,NULL,NULL),(5,NULL,1,25.00,'YUKLEME',NULL,NULL,1040.00,1065.00,'2025-12-10 18:43:03','BASARILI','Test yükleme',NULL,NULL,NULL,NULL),(6,NULL,1,100.00,'YUKLEME',NULL,NULL,1065.00,1165.00,'2025-12-23 15:22:28','BASARILI','Test yükleme',NULL,NULL,NULL,NULL),(7,NULL,1,100.00,'YUKLEME',NULL,NULL,1165.00,1265.00,'2025-12-23 15:22:40','BASARILI','Test yükleme',NULL,NULL,NULL,NULL),(8,NULL,1,100.00,'YUKLEME',NULL,NULL,1265.00,1365.00,'2025-12-23 15:22:50','BASARILI','Test yükleme',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `islemler` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kullanicilar`
--

DROP TABLE IF EXISTS `kullanicilar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kullanicilar` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ad_soyad` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sifre_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rol_id` int NOT NULL,
  `durum` enum('AKTIF','PASIF') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'AKTIF',
  `olusturma_tarihi` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `son_giris_tarihi` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_kullanicilar_rol` (`rol_id`),
  KEY `idx_kullanicilar_durum` (`durum`),
  CONSTRAINT `fk_kullanicilar_rol` FOREIGN KEY (`rol_id`) REFERENCES `roller` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_email_format` CHECK ((`email` like _utf8mb4'%_@_%._%'))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kullanicilar`
--

LOCK TABLES `kullanicilar` WRITE;
/*!40000 ALTER TABLE `kullanicilar` DISABLE KEYS */;
INSERT INTO `kullanicilar` VALUES (1,'Admin Kullanıcı','admin@example.com','admin123',1,'AKTIF','2025-12-10 15:40:21',NULL),(2,'Ali Müşteri','ali@example.com','ali123',2,'AKTIF','2025-12-10 15:40:21',NULL),(3,'Ayşe Müşteri','ayse@example.com','ayse123',2,'AKTIF','2025-12-10 15:40:21',NULL),(4,'Fraud Uzmanı','fraud@example.com','fraud123',3,'AKTIF','2025-12-10 15:40:21',NULL);
/*!40000 ALTER TABLE `kullanicilar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ml_modelleri`
--

DROP TABLE IF EXISTS `ml_modelleri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ml_modelleri` (
  `id` int NOT NULL AUTO_INCREMENT,
  `model_adi` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `versiyon` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `egitim_tarihi` datetime NOT NULL,
  `egitim_veri_kaynak` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `accuracy` decimal(5,4) DEFAULT NULL,
  `precision_skor` decimal(5,4) DEFAULT NULL,
  `recall` decimal(5,4) DEFAULT NULL,
  `f1_skor` decimal(5,4) DEFAULT NULL,
  `model_dosya_yolu` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ml_model` (`model_adi`,`versiyon`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ml_modelleri`
--

LOCK TABLES `ml_modelleri` WRITE;
/*!40000 ALTER TABLE `ml_modelleri` DISABLE KEYS */;
INSERT INTO `ml_modelleri` VALUES (1,'RandomForest','v1','2025-12-10 15:40:21','kaggle_online_payments.csv',0.9850,0.9100,0.9200,0.9150,'models/rf_v1.joblib');
/*!40000 ALTER TABLE `ml_modelleri` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roller`
--

DROP TABLE IF EXISTS `roller`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roller` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ad` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `aciklama` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `olusturma_tarihi` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ad` (`ad`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roller`
--

LOCK TABLES `roller` WRITE;
/*!40000 ALTER TABLE `roller` DISABLE KEYS */;
INSERT INTO `roller` VALUES (1,'ADMIN','Sistem yöneticisi','2025-12-10 15:40:21'),(2,'KULLANICI','Sıradan kullanıcı','2025-12-10 15:40:21'),(3,'FRAUD_UZMANI','Şüpheli işlemleri inceleyen kullanıcı','2025-12-10 15:40:21');
/*!40000 ALTER TABLE `roller` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Transactions`
--

DROP TABLE IF EXISTS `Transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Transactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sender` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `receiver` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `IsFraud` tinyint(1) NOT NULL DEFAULT '0',
  `FraudScore` double NOT NULL DEFAULT '0',
  `FraudReason` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Transactions`
--

LOCK TABLES `Transactions` WRITE;
/*!40000 ALTER TABLE `Transactions` DISABLE KEYS */;
INSERT INTO `Transactions` VALUES (1,'bekir','irem ',3200.00,'2025-12-20 17:37:26',0,0,NULL),(4,'ece kaya','emir kaya',500.00,'2025-12-20 18:37:13',0,0,NULL);
/*!40000 ALTER TABLE `Transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_gunluk_islem_sayilari`
--

DROP TABLE IF EXISTS `vw_gunluk_islem_sayilari`;
/*!50001 DROP VIEW IF EXISTS `vw_gunluk_islem_sayilari`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_gunluk_islem_sayilari` AS SELECT 
 1 AS `islem_tarih`,
 1 AS `islem_sayisi`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_hesap_islem_ozet`
--

DROP TABLE IF EXISTS `vw_hesap_islem_ozet`;
/*!50001 DROP VIEW IF EXISTS `vw_hesap_islem_ozet`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_hesap_islem_ozet` AS SELECT 
 1 AS `id`,
 1 AS `islem_zamani`,
 1 AS `islem_tipi`,
 1 AS `tutar`,
 1 AS `kaynak_hesap_no`,
 1 AS `hedef_hesap_no`,
 1 AS `durum`,
 1 AS `fraud_tahmin_skoru`,
 1 AS `fraud_risk_seviye`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_kullanici_hesap_bakiyeleri`
--

DROP TABLE IF EXISTS `vw_kullanici_hesap_bakiyeleri`;
/*!50001 DROP VIEW IF EXISTS `vw_kullanici_hesap_bakiyeleri`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_kullanici_hesap_bakiyeleri` AS SELECT 
 1 AS `kullanici_id`,
 1 AS `ad_soyad`,
 1 AS `email`,
 1 AS `hesap_id`,
 1 AS `hesap_no`,
 1 AS `bakiye`,
 1 AS `para_birimi`,
 1 AS `hesap_durumu`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_kullanicilar_maskeli`
--

DROP TABLE IF EXISTS `vw_kullanicilar_maskeli`;
/*!50001 DROP VIEW IF EXISTS `vw_kullanicilar_maskeli`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_kullanicilar_maskeli` AS SELECT 
 1 AS `id`,
 1 AS `ad_soyad`,
 1 AS `email`,
 1 AS `rol_id`,
 1 AS `durum`,
 1 AS `olusturma_tarihi`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_yuksek_riskli_islemler`
--

DROP TABLE IF EXISTS `vw_yuksek_riskli_islemler`;
/*!50001 DROP VIEW IF EXISTS `vw_yuksek_riskli_islemler`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_yuksek_riskli_islemler` AS SELECT 
 1 AS `id`,
 1 AS `kaynak_hesap_id`,
 1 AS `hedef_hesap_id`,
 1 AS `tutar`,
 1 AS `islem_tipi`,
 1 AS `eski_bakiye_kaynak`,
 1 AS `yeni_bakiye_kaynak`,
 1 AS `eski_bakiye_hedef`,
 1 AS `yeni_bakiye_hedef`,
 1 AS `islem_zamani`,
 1 AS `durum`,
 1 AS `aciklama`,
 1 AS `is_fraud_etiketi`,
 1 AS `fraud_tahmin_skoru`,
 1 AS `fraud_model_id`,
 1 AS `fraud_tahmin_tarihi`,
 1 AS `fraud_risk_seviye`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'odeme_sistemi'
--
/*!50003 DROP FUNCTION IF EXISTS `fn_fraud_risk_seviye` */;
ALTER DATABASE `odeme_sistemi` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_fraud_risk_seviye`(p_skor DECIMAL(5,4)) RETURNS varchar(20) CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci
    DETERMINISTIC
BEGIN
    IF p_skor IS NULL THEN
        RETURN 'Bilinmiyor';
    ELSEIF p_skor < 0.30 THEN
        RETURN 'Düşük';
    ELSEIF p_skor < 0.70 THEN
        RETURN 'Orta';
    ELSE
        RETURN 'Yüksek';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `odeme_sistemi` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
/*!50003 DROP FUNCTION IF EXISTS `fn_mask_email` */;
ALTER DATABASE `odeme_sistemi` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_mask_email`(p_email VARCHAR(100)) RETURNS varchar(100) CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci
    DETERMINISTIC
BEGIN
    DECLARE at_pos INT;
    DECLARE name_part VARCHAR(100);
    DECLARE domain_part VARCHAR(100);

    SET at_pos = INSTR(p_email, '@');

    IF at_pos = 0 THEN
        RETURN p_email;
    END IF;

    SET name_part = LEFT(p_email, at_pos - 1);
    SET domain_part = SUBSTRING(p_email, at_pos);

    IF CHAR_LENGTH(name_part) <= 2 THEN
        RETURN CONCAT(LEFT(name_part,1), '***', domain_part);
    END IF;

    RETURN CONCAT(LEFT(name_part,1), REPEAT('*', CHAR_LENGTH(name_part)-2), RIGHT(name_part,1), domain_part);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `odeme_sistemi` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_para_transfer` */;
ALTER DATABASE `odeme_sistemi` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_para_transfer`(
    IN p_kaynak_hesap_id INT,
    IN p_hedef_hesap_id  INT,
    IN p_tutar           DECIMAL(18,2)
)
BEGIN
    DECLARE v_bakiye_kaynak DECIMAL(18,2);
    DECLARE v_bakiye_hedef  DECIMAL(18,2);

    IF p_kaynak_hesap_id = p_hedef_hesap_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Kaynak ve hedef hesap farklı olmalıdır';
    END IF;

    IF p_tutar <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Tutar 0 dan büyük olmalıdır';
    END IF;

    START TRANSACTION;

    SELECT bakiye INTO v_bakiye_kaynak
    FROM hesaplar
    WHERE id = p_kaynak_hesap_id
    FOR UPDATE;

    IF v_bakiye_kaynak < p_tutar THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Yetersiz bakiye';
    END IF;

    SELECT bakiye INTO v_bakiye_hedef
    FROM hesaplar
    WHERE id = p_hedef_hesap_id
    FOR UPDATE;

    UPDATE hesaplar
    SET bakiye = bakiye - p_tutar
    WHERE id = p_kaynak_hesap_id;

    UPDATE hesaplar
    SET bakiye = bakiye + p_tutar
    WHERE id = p_hedef_hesap_id;

    INSERT INTO islemler (
        kaynak_hesap_id, hedef_hesap_id, tutar, islem_tipi,
        eski_bakiye_kaynak, yeni_bakiye_kaynak,
        eski_bakiye_hedef,  yeni_bakiye_hedef
    ) VALUES (
        p_kaynak_hesap_id, p_hedef_hesap_id, p_tutar, 'TRANSFER',
        v_bakiye_kaynak, v_bakiye_kaynak - p_tutar,
        v_bakiye_hedef,  v_bakiye_hedef + p_tutar
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `odeme_sistemi` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_para_yukle` */;
ALTER DATABASE `odeme_sistemi` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_para_yukle`(
    IN p_hedef_hesap_id INT,
    IN p_tutar DECIMAL(18,2),
    IN p_aciklama VARCHAR(255),
    OUT p_sonuc VARCHAR(100)
)
BEGIN
    DECLARE v_eski_bakiye DECIMAL(18,2);
    DECLARE v_yeni_bakiye DECIMAL(18,2);

    -- Hata yakalama
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_sonuc = 'HATA: İşlem sırasında bir hata oluştu';
    END;

    START TRANSACTION;

    IF p_tutar <= 0 THEN
        SET p_sonuc = 'HATA: Yükleme tutarı 0''dan büyük olmalıdır';
        ROLLBACK;
    ELSE
        -- Hesap bakiyesini kilitleyip oku
        SELECT bakiye INTO v_eski_bakiye
        FROM hesaplar
        WHERE id = p_hedef_hesap_id AND durum = 'AKTIF'
        FOR UPDATE;

        SET v_yeni_bakiye = v_eski_bakiye + p_tutar;

        -- Hesabı güncelle
        UPDATE hesaplar
        SET bakiye = v_yeni_bakiye
        WHERE id = p_hedef_hesap_id;

        -- İşlem kaydı oluştur (YUKLEME)
        INSERT INTO islemler (
            kaynak_hesap_id, hedef_hesap_id, tutar, islem_tipi,
            eski_bakiye_kaynak, yeni_bakiye_kaynak,
            eski_bakiye_hedef, yeni_bakiye_hedef,
            durum, aciklama
        ) VALUES (
            NULL, p_hedef_hesap_id, p_tutar, 'YUKLEME',
            NULL, NULL,
            v_eski_bakiye, v_yeni_bakiye,
            'BASARILI', p_aciklama
        );

        COMMIT;
        SET p_sonuc = 'BAŞARILI: Yükleme tamamlandı';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `odeme_sistemi` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;

--
-- Final view structure for view `vw_gunluk_islem_sayilari`
--

/*!50001 DROP VIEW IF EXISTS `vw_gunluk_islem_sayilari`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_gunluk_islem_sayilari` AS select cast(`i`.`islem_zamani` as date) AS `islem_tarih`,count(0) AS `islem_sayisi` from `islemler` `i` group by cast(`i`.`islem_zamani` as date) order by `islem_tarih` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_hesap_islem_ozet`
--

/*!50001 DROP VIEW IF EXISTS `vw_hesap_islem_ozet`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_hesap_islem_ozet` AS select `i`.`id` AS `id`,`i`.`islem_zamani` AS `islem_zamani`,`i`.`islem_tipi` AS `islem_tipi`,`i`.`tutar` AS `tutar`,`ks`.`hesap_no` AS `kaynak_hesap_no`,`hs`.`hesap_no` AS `hedef_hesap_no`,`i`.`durum` AS `durum`,`i`.`fraud_tahmin_skoru` AS `fraud_tahmin_skoru`,`fn_fraud_risk_seviye`(`i`.`fraud_tahmin_skoru`) AS `fraud_risk_seviye` from ((`islemler` `i` left join `hesaplar` `ks` on((`ks`.`id` = `i`.`kaynak_hesap_id`))) left join `hesaplar` `hs` on((`hs`.`id` = `i`.`hedef_hesap_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_kullanici_hesap_bakiyeleri`
--

/*!50001 DROP VIEW IF EXISTS `vw_kullanici_hesap_bakiyeleri`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_kullanici_hesap_bakiyeleri` AS select `k`.`id` AS `kullanici_id`,`k`.`ad_soyad` AS `ad_soyad`,`k`.`email` AS `email`,`h`.`id` AS `hesap_id`,`h`.`hesap_no` AS `hesap_no`,`h`.`bakiye` AS `bakiye`,`h`.`para_birimi` AS `para_birimi`,`h`.`durum` AS `hesap_durumu` from (`kullanicilar` `k` join `hesaplar` `h` on((`h`.`kullanici_id` = `k`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_kullanicilar_maskeli`
--

/*!50001 DROP VIEW IF EXISTS `vw_kullanicilar_maskeli`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_kullanicilar_maskeli` AS select `kullanicilar`.`id` AS `id`,`kullanicilar`.`ad_soyad` AS `ad_soyad`,`fn_mask_email`(`kullanicilar`.`email`) AS `email`,`kullanicilar`.`rol_id` AS `rol_id`,`kullanicilar`.`durum` AS `durum`,`kullanicilar`.`olusturma_tarihi` AS `olusturma_tarihi` from `kullanicilar` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_yuksek_riskli_islemler`
--

/*!50001 DROP VIEW IF EXISTS `vw_yuksek_riskli_islemler`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_yuksek_riskli_islemler` AS select `i`.`id` AS `id`,`i`.`kaynak_hesap_id` AS `kaynak_hesap_id`,`i`.`hedef_hesap_id` AS `hedef_hesap_id`,`i`.`tutar` AS `tutar`,`i`.`islem_tipi` AS `islem_tipi`,`i`.`eski_bakiye_kaynak` AS `eski_bakiye_kaynak`,`i`.`yeni_bakiye_kaynak` AS `yeni_bakiye_kaynak`,`i`.`eski_bakiye_hedef` AS `eski_bakiye_hedef`,`i`.`yeni_bakiye_hedef` AS `yeni_bakiye_hedef`,`i`.`islem_zamani` AS `islem_zamani`,`i`.`durum` AS `durum`,`i`.`aciklama` AS `aciklama`,`i`.`is_fraud_etiketi` AS `is_fraud_etiketi`,`i`.`fraud_tahmin_skoru` AS `fraud_tahmin_skoru`,`i`.`fraud_model_id` AS `fraud_model_id`,`i`.`fraud_tahmin_tarihi` AS `fraud_tahmin_tarihi`,`fn_fraud_risk_seviye`(`i`.`fraud_tahmin_skoru`) AS `fraud_risk_seviye` from `islemler` `i` where (((`i`.`fraud_tahmin_skoru` is not null) and (`i`.`fraud_tahmin_skoru` >= 0.70)) or (`i`.`is_fraud_etiketi` = 1)) */;
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

-- Dump completed on 2025-12-23 16:43:56
