CREATE DATABASE  IF NOT EXISTS `moca` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `moca`;
-- MySQL dump 10.13  Distrib 8.0.17, for macos10.14 (x86_64)
--
-- Host: localhost    Database: moca
-- ------------------------------------------------------
-- Server version	8.0.17

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
-- Table structure for table `board`
--

DROP TABLE IF EXISTS `board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `board` (
  `boardNo` int(11) NOT NULL AUTO_INCREMENT,
  `boardTitle` varchar(30) DEFAULT NULL,
  `boardContent` text,
  `boardImg` varchar(45) DEFAULT NULL,
  `boardInsertDate` datetime DEFAULT NULL,
  `boardDeleteDate` datetime DEFAULT NULL,
  PRIMARY KEY (`boardNo`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board`
--

LOCK TABLES `board` WRITE;
/*!40000 ALTER TABLE `board` DISABLE KEYS */;
INSERT INTO `board` VALUES (1,'점심 뭐먹었냐 다들?','배고픈데 점심 추천좀ㅠ','39CD48B4-339C-4C78-9749-8A909C7D7E8A.jpeg','2020-09-11 00:00:00',NULL);
/*!40000 ALTER TABLE `board` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `brand`
--

DROP TABLE IF EXISTS `brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `brand` (
  `brandNo` int(11) NOT NULL AUTO_INCREMENT,
  `brandName` varchar(45) DEFAULT NULL,
  `brandImg` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`brandNo`),
  UNIQUE KEY `brandNo_UNIQUE` (`brandNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brand`
--

LOCK TABLES `brand` WRITE;
/*!40000 ALTER TABLE `brand` DISABLE KEYS */;
/*!40000 ALTER TABLE `brand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `have`
--

DROP TABLE IF EXISTS `have`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `have` (
  `brand_brandNo` int(11) NOT NULL,
  `menu_menuNo` int(11) NOT NULL,
  KEY `fk_have_brand1_idx` (`brand_brandNo`),
  KEY `fk_have_menu1_idx` (`menu_menuNo`),
  CONSTRAINT `fk_have_brand1` FOREIGN KEY (`brand_brandNo`) REFERENCES `brand` (`brandNo`),
  CONSTRAINT `fk_have_menu1` FOREIGN KEY (`menu_menuNo`) REFERENCES `menu` (`menuNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `have`
--

LOCK TABLES `have` WRITE;
/*!40000 ALTER TABLE `have` DISABLE KEYS */;
/*!40000 ALTER TABLE `have` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `like`
--

DROP TABLE IF EXISTS `like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `like` (
  `userInfo_userEmail` varchar(30) NOT NULL,
  `menu_menuNo` int(11) NOT NULL,
  KEY `fk_like_userInfo1_idx` (`userInfo_userEmail`),
  KEY `fk_like_menu1_idx` (`menu_menuNo`),
  CONSTRAINT `fk_like_menu1` FOREIGN KEY (`menu_menuNo`) REFERENCES `menu` (`menuNo`),
  CONSTRAINT `fk_like_userInfo1` FOREIGN KEY (`userInfo_userEmail`) REFERENCES `userinfo` (`userEmail`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `like`
--

LOCK TABLES `like` WRITE;
/*!40000 ALTER TABLE `like` DISABLE KEYS */;
/*!40000 ALTER TABLE `like` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu`
--

DROP TABLE IF EXISTS `menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu` (
  `menuNo` int(11) NOT NULL AUTO_INCREMENT,
  `menuName` varchar(45) DEFAULT NULL,
  `menuPrice` int(11) DEFAULT NULL,
  `menuImg` varchar(45) DEFAULT NULL,
  `menuCalorie` varchar(10) DEFAULT NULL,
  `menuInformation` varchar(100) DEFAULT NULL,
  `menuCategory` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`menuNo`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu`
--

LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` VALUES (1,'아메리카노',4100,NULL,NULL,NULL,NULL),(2,'카페라떼',4600,NULL,NULL,NULL,NULL),(3,'딸기요거트스무디',5500,NULL,NULL,NULL,NULL),(4,'민트캐모마일티',4800,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `register`
--

DROP TABLE IF EXISTS `register`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `register` (
  `userInfo_userEmail` varchar(30) NOT NULL,
  `board_boardNo` int(11) NOT NULL,
  KEY `fk_write_userInfo1_idx` (`userInfo_userEmail`),
  KEY `fk_write_board1_idx` (`board_boardNo`),
  CONSTRAINT `fk_write_board1` FOREIGN KEY (`board_boardNo`) REFERENCES `board` (`boardNo`),
  CONSTRAINT `fk_write_userInfo1` FOREIGN KEY (`userInfo_userEmail`) REFERENCES `userinfo` (`userEmail`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `register`
--

LOCK TABLES `register` WRITE;
/*!40000 ALTER TABLE `register` DISABLE KEYS */;
INSERT INTO `register` VALUES ('test',1);
/*!40000 ALTER TABLE `register` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `reviewNo` int(11) NOT NULL AUTO_INCREMENT,
  `userInfo_userEmail` varchar(30) NOT NULL,
  `menu_menuNo` int(11) NOT NULL,
  `reviewContent` text,
  `reviewStar` double DEFAULT NULL,
  `reviewImg` varchar(50) DEFAULT NULL,
  `reviewInsertDate` datetime DEFAULT NULL,
  PRIMARY KEY (`reviewNo`),
  KEY `fk_review_userInfo_idx` (`userInfo_userEmail`),
  KEY `fk_review_menu1_idx` (`menu_menuNo`),
  CONSTRAINT `fk_review_menu1` FOREIGN KEY (`menu_menuNo`) REFERENCES `menu` (`menuNo`),
  CONSTRAINT `fk_review_userInfo` FOREIGN KEY (`userInfo_userEmail`) REFERENCES `userinfo` (`userEmail`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` VALUES (1,'test',1,'아메리카노는 맛있는데 직원이 불친절해요;;;',2,'B93BD703-EEF7-46B5-982C-9D89BA265112.jpeg','2020-08-07 00:00:00'),(2,'test1',3,'요거트 스무디 쫀득쫀득하고 최고에용 크~~~',3.5,'39CD48B4-339C-4C78-9749-8A909C7D7E8A.jpeg','2020-12-07 00:00:00'),(3,'test2',4,'양치한듯 상쾌해져요ㅎㅎ 시원쓰~',4,'32B67765-6759-414A-B911-3C3F8FA2B4F9.jpeg','2021-02-07 00:00:00'),(4,'test',2,'카페라떼 두유로 시켰는데 우유로 왔네요ㅠ 근데 맛은있음',2.5,NULL,'2021-02-20 00:00:00');
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tip`
--

DROP TABLE IF EXISTS `tip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tip` (
  `tipNo` int(11) NOT NULL AUTO_INCREMENT,
  `tipImg` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`tipNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tip`
--

LOCK TABLES `tip` WRITE;
/*!40000 ALTER TABLE `tip` DISABLE KEYS */;
/*!40000 ALTER TABLE `tip` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userInfo`
--

DROP TABLE IF EXISTS `userInfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userInfo` (
  `userEmail` varchar(30) NOT NULL,
  `userPw` varchar(20) NOT NULL,
  `userNickname` varchar(10) DEFAULT NULL,
  `userName` varchar(10) NOT NULL,
  `userPhone` varchar(15) NOT NULL,
  `userBirth` date DEFAULT NULL,
  `userImg` varchar(50) DEFAULT NULL,
  `userInsertDate` datetime DEFAULT NULL,
  `userDeleteDate` datetime DEFAULT NULL,
  PRIMARY KEY (`userEmail`),
  UNIQUE KEY `userEmail_UNIQUE` (`userEmail`),
  UNIQUE KEY `userNickname_UNIQUE` (`userNickname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userInfo`
--

LOCK TABLES `userInfo` WRITE;
/*!40000 ALTER TABLE `userInfo` DISABLE KEYS */;
INSERT INTO `userInfo` VALUES ('test','test','테스트','테스트','010-1234-5678',NULL,NULL,'2020-01-01 00:00:00',NULL),('test1','test1','테슽테슽','테슽테슽','010-1234-5678',NULL,NULL,'2020-05-01 00:00:00',NULL),('test2','test2','텟텟텟','텟텟텟','010-1234-5678',NULL,NULL,'2021-01-01 00:00:00',NULL);
/*!40000 ALTER TABLE `userInfo` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-02-25 15:09:26
