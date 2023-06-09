-- SQL-Dump FileSystemChecker
--
-- Host: 127.0.0.1
-- Server-Version: 10.4.28-MariaDB
-- PHP-Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

SET PROFILING = 1;

--
-- Datenbank: `fsc`
--
DROP DATABASE IF EXISTS `fsc`;
CREATE DATABASE `fsc` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `fsc`;


-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `ratiobasis`
--

CREATE TABLE `ratiobasis` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `ratio` INT NOT NULL,
  `weight` INT NOT NULL,
  `recommendedAction` ENUM('D', 'B', 'N') NULL COMMENT 'D = Delete, B = Backup, N = Nothing, don\\\'t touch!\', null = no specific action recommended by this entry alone',
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `idratiobasis_UNIQUE` (`ID` ASC))
ENGINE = InnoDB;

--
-- Daten für Tabelle `ratiobasis`
--

INSERT INTO `ratiobasis` (`ID`, `ratio`, `weight`, `recommendedAction`) VALUES
(1, 100, 80, 'D'),
(2, 90, 80, 'D'),
(3, 80, 80, 'D'),
(4, 70, 80, 'D'),
(5, 90, 50, 'D'),
(6, 80, 50, 'D'),
(7, 70, 50, 'D'),
(8, 60, 50, 'D'),
(9, 50, 50, 'D'),
(10, 40, 50, 'D'),
(11, 80, 50, 'B'),
(12, 50, 50, 'B'),
(13, 100, 100, 'N'),
(14, 50, 50, 'N');

COMMIT;
SHOW PROFILES;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `filename`
--

CREATE TABLE `filename` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `ratiobasisID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `idfilename_UNIQUE` (`ID` ASC),
--  UNIQUE INDEX `idx_filename_name_UNIQUE` (`name` ASC),
  INDEX `fk_filename_ratiobasis_idx` (`ratiobasisID` ASC),
  CONSTRAINT `fk_filename_ratiobasis`
    FOREIGN KEY (`ratiobasisID`)
    REFERENCES `ratiobasis` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

--
-- Daten für Tabelle `filename`
--

INSERT INTO `filename` (`ID`, `name`, `ratiobasisID`) VALUES
(1, 'Pagefile.sys', 12),
(2, 'Swapfile.sys', 12);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `filetype`
--

CREATE TABLE `filetype` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `fileending` VARCHAR(20) NOT NULL,
  `ratiobasisID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `idfiletype_UNIQUE` (`ID` ASC),
  -- INDEX `idx_filetype_fileending` (fileending ASC),
  INDEX `fk_filetype_ratiobasis_idx` (`ratiobasisID` ASC),
  CONSTRAINT `fk_filetype_ratiobasis`
    FOREIGN KEY (`ratiobasisID`)
    REFERENCES `ratiobasis` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

--
-- Daten für Tabelle `filetype`
--

INSERT INTO `filetype` (`ID`, `fileending`, `ratiobasisID`) VALUES
(1, 'DMP', 2),
(2, '.log', 2),
(3, '.tmp', 2),
(4, '.msi', 2),
(5, '.png', 11),
(6, '.jpg', 11),
(7, '.jpeg', 11),
(8, '.mp4', 11),
(9, '.mp3', 11),
(10, '.docx', 12),
(11, '.pdf', 12),
(12, '.pptx', 12);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `foldername`
--

CREATE TABLE `foldername` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `ratiobasisID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `idfoldername_UNIQUE` (`ID` ASC),
 -- UNIQUE INDEX `idx_foldername_name_UNIQUE` (`name` ASC),
  INDEX `fk_foldername_ratiobasis_idx` (`ratiobasisID` ASC),
  CONSTRAINT `fk_foldername_ratiobasis`
    FOREIGN KEY (`ratiobasisID`)
    REFERENCES `ratiobasis` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

--
-- Daten für Tabelle `foldername`
--
INSERT INTO `foldername` (`ID`, `name`, `ratiobasisID`) VALUES
(1, '%System32%', 13),
(2, '%WinSxS%', 13),
(3, '%System Volume Information%', 13),
(4, 'C:\\Windows\\Temp%', 1),
(5, 'C:\\Windows\\Downloaded Program Files%', 1),
(6, 'C:\\Windows\\LiveKernelReports%', 1),
(7, 'C:\\Program Files\\rempl%', 1),
(8, 'C:\\Users\\%\\Downloads%', 1),
(9, 'C:\\Users\\%\\AppData\\Local\\Google\\Chrome\\User Data\\Default\\Cache%', 1),
(10, 'C:\\Users\\%\\AppData\\Local\\Mozilla\\Firefox%', 1),
(11, 'C:\\Users\\%\\AppData\\Local\\Microsoft\\Internet Explorer\\CacheStorage%', 1),
(12, 'C:\\Windows\\Logs\\CBS%', 1),
(13, 'C:\\Windows\\SoftwareDistribution\\Download%', 1),
(14, 'C:\\Users\\%\\AppData\\Local\\Temp%', 1),
(15, 'C:\\Windows\\Prefetch%', 1),
(16, 'C:\\Users\\%\\AppData\\Local\\CrashDumps%', 1),
(17, 'C:\\ProgramData\\Microsoft\\Windows\\WER\\ReportArchive%', 1),
(18, 'C:\\Users\\%\\Documents%', 11),
(19, '%Temp%', 2),
(20, '%Download%', 3),
(21, '%Cache%', 2),
(22, '%LiveKernelReports%', 1),
(23, '%rempl%', 1),
(24, '%logs%', 3),
(25, '%crashdumps%', 1),
(26, '%reportarchive%', 1),
(27, '%Bilder%', 11),
(28, '%Documents%', 11);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `size`
--
CREATE TABLE `size` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `sizeInBytes` BIGINT NOT NULL,
  `ratiobasisID` INT NOT NULL,
  `sizeAsString` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `idsize_UNIQUE` (`ID` ASC),
  UNIQUE INDEX `idx_size_sizeInBytes_unique` (sizeInBytes ASC),
  INDEX `fk_size_ratiobasis_idx` (`ratiobasisID` ASC),
  CONSTRAINT `fk_size_ratiobasis`
    FOREIGN KEY (`ratiobasisID`)
    REFERENCES `ratiobasis` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

--
-- Daten für Tabelle `size`
--

INSERT INTO `size` (`ID`, `sizeInBytes`, `ratiobasisID`, `sizeAsString`) VALUES
(1,        51200, 10, "50 KB"),
(2,      1048576, 9, "1 MB"),
(3,     15728640, 8, "15 MB"),
(4,   1073741824, 7, "1 GB"),
(5,  10737418240, 6, "10 GB"),
(6, 107374182400, 5, "100 GB");

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `date`
--
CREATE TABLE `date` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `days` INT NOT NULL,
  `type` ENUM('R', 'A', 'P') NOT NULL DEFAULT 'A' COMMENT 'R = Recycle Bin, A = Anywhere, P = Personal Files',
  `created` TINYINT NOT NULL,
  `lastAccess` TINYINT NOT NULL,
  `ratiobasisID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `iddate_UNIQUE` (`ID` ASC),
  INDEX `idx_date_lastAccessAndDays` (lastAccess ASC, days ASC),
  UNIQUE INDEX `idx_date_lastAccessAndTypeAndDays` (lastAccess ASC, type ASC, days ASC),
  INDEX `fk_date_ratiobasis_idx` (`ratiobasisID` ASC),
  CONSTRAINT `fk_date_ratiobasis`
    FOREIGN KEY (`ratiobasisID`)
    REFERENCES `ratiobasis` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

--
-- Daten für Tabelle `date`
--

INSERT INTO `date` (`ID`, `days`, `type`, `created`, `lastAccess`, `ratiobasisID`) VALUES
(1, 60, 'R', 1, 0, 1),
(2, 30, 'R', 1, 0, 2),
(3, 14, 'R', 1, 0, 3),
(4, 1, 'R', 1, 0, 4),
(5, 999999, 'A', 0, 1, 5),
(6, 360, 'A', 0, 1, 6),
(7, 180, 'A', 0, 1, 7),
(8, 60, 'A', 0, 1, 8),
(9, 30, 'A', 0, 1, 9),
(10, 14, 'A', 0, 1, 10),
(11, 360, 'P', 0, 1, 11),
(12, 180, 'P', 0, 1, 12),
(13, 0, 'R', 1, 1, 14),
(14, 0, 'A', 1, 1, 14),
(15, 0, 'P', 1, 1, 14);

COMMIT;
SHOW PROFILES;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `folder`
--

CREATE TABLE `folder` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `path` VARCHAR(255) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `lastModifiedTSD` TIMESTAMP NULL,
  `parentFolderID` INT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `idx_folder_pathAndName_UNIQUE` (`path`, `name` ASC),
  UNIQUE INDEX `idfolder_UNIQUE` (`ID` ASC),
  INDEX `fk_folder_folder_idx` (`parentFolderID` ASC),
  CONSTRAINT `fk_folder_folder`
    FOREIGN KEY (`parentFolderID`)
    REFERENCES `folder` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `file`
--

CREATE TABLE `file` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `folderID` INT NOT NULL,
  `folder` VARCHAR(255) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `lastAccessedTSD` TIMESTAMP NULL,
  `lastModifiedTSD` TIMESTAMP NULL,
  `creationTSD` TIMESTAMP NULL,
  `sizeInBytes` BIGINT NOT NULL,
  `sizeAsString` VARCHAR(20) NOT NULL,
  `filetype` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `idfile_UNIQUE` (`ID` ASC),
  INDEX `fk_file_folder_idx` (`folderID` ASC),
  CONSTRAINT `fk_file_folder`
    FOREIGN KEY (`folderID`)
    REFERENCES `folder` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
  )
ENGINE = InnoDB;

COMMIT;
SHOW PROFILES;

DELIMITER $$
DROP PROCEDURE IF EXISTS drop_index_if_exists $$
CREATE PROCEDURE drop_index_if_exists(in theTable varchar(128), in theIndexName varchar(128) )
BEGIN
 IF((SELECT COUNT(*) AS index_exists FROM information_schema.statistics WHERE TABLE_SCHEMA = DATABASE() and table_name =
theTable AND index_name = theIndexName) > 0) THEN
   SET @s = CONCAT('DROP INDEX ' , theIndexName , ' ON ' , theTable);
   PREPARE stmt FROM @s;
   EXECUTE stmt;
 END IF;
END $$
DELIMITER ;

COMMIT;

SET PROFILING = 0;
SHOW PROFILES;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
