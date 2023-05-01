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
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;

--
-- Daten für Tabelle `ratiobasis`
--

INSERT INTO `ratiobasis` (`ID`, `ratio`, `weight`, `recommendedAction`) VALUES
(1, 100, 80, 'D'),
(2, 90, 80, 'D'),
(3, 80, 80, 'D'),
(4, 70, 80, 'D'),
(5, 70, 50, 'D'),
(6, 60, 50, 'D'),
(7, 50, 50, 'D'),
(8, 40, 50, 'D'),
(9, 80, 50, 'B'),
(10, 50, 50, 'B'),
(11, 100, 100, 'N');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `filename`
--

CREATE TABLE `filename` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `ratiobasisID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  CONSTRAINT `fk_filename_ratiobasis1`
    FOREIGN KEY (`ratiobasisID`)
    REFERENCES `ratiobasis` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

--
-- Daten für Tabelle `filename`
--

INSERT INTO `filename` (`ID`, `name`, `ratiobasisID`) VALUES
(1, 'Pagefile.sys', 11),
(2, 'Swapfile.sys', 11);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `filetype`
--

CREATE TABLE `filetype` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `fileending` VARCHAR(20) NOT NULL,
  `ratiobasisID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_filetype_ratiobasis1_idx` (`ratiobasisID` ASC),
  CONSTRAINT `fk_filetype_ratiobasis1`
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
(5, '.png', 9),
(6, '.jpg', 9),
(7, '.jpeg', 9),
(8, '.mp4', 9),
(9, '.mp3', 9),
(10, '.docx', 10),
(11, '.pdf', 10),
(12, '.pptx', 10);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `foldername`
--

CREATE TABLE `foldername` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `ratiobasisID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  CONSTRAINT `fk_foldername_ratiobasis1`
    FOREIGN KEY (`ratiobasisID`)
    REFERENCES `ratiobasis` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
--
-- Daten für Tabelle `foldername`
--

INSERT INTO `foldername` (`ID`, `name`, `ratiobasisID`) VALUES
(1, 'System32', 11),
(2, 'WinSxS', 11),
(3, 'System Volume Information', 11),
(21, 'C:\\Windows\\Temp', 1),
(22, 'C:\\Windows\\Downloaded Program Files', 1),
(23, 'C:\\Windows\\LiveKernelReports', 1),
(24, 'C:\\Program Files\\rempl', 1),
(25, 'C:\\Users\\%userprofiles%\\Downloads', 1),
(26, 'C:\\Users\\%userprofiles%\\AppData\\Local\\Google\\Chrome\\User Data\\Default\\Cache', 1),
(27, 'C:\\Users\\%userprofiles%\\AppData\\Local\\Mozilla\\Firefox', 1),
(28, 'C:\\Users\\%userprofiles%\\AppData\\Local\\Microsoft\\Internet Explorer\\CacheStorage', 1),
(29, 'C:\\Windows\\Logs\\CBS', 1),
(30, 'C:\\Windows\\SoftwareDistribution\\Download', 1),
(31, 'C:\\Users\\%userprofiles%\\AppData\\Local\\Temp', 1),
(32, 'C:\\Windows\\Prefetch', 1),
(33, 'C:\\Users\\%userprofiles%\\AppData\\Local\\CrashDumps', 1),
(34, 'C:\\ProgramData\\Microsoft\\Windows\\WER\\ReportArchive', 1),
(35, 'C:\\Users\\%userprofiles%\\Documents', 9),
(36, 'C:\\Users\\%userprofiles%\\Bilder', 9);

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
  CONSTRAINT `fk_size_ratiobasis1`
    FOREIGN KEY (`ratiobasisID`)
    REFERENCES `ratiobasis` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


--
-- Daten für Tabelle `size`
--

INSERT INTO `size` (`ID`, `sizeInBytes`, `ratiobasisID`, `sizeAsString`) VALUES
(1,        51200, 8, "50 KB"),
(2,      1048576, 7, "1 MB"),
(3,     15728640, 7, "15 MB"),
(4,   1073741824, 6, "1 GB"),
(5,  10737418240, 5, "10 GB"),
(6, 107374182400, 5, "100 GB");

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
  CONSTRAINT `fk_date_ratiobasis1`
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
(6, 60, 'A', 0, 1, 6),
(7, 30, 'A', 0, 1, 7),
(8, 14, 'A', 0, 1, 8),
(9, 360, 'P', 0, 1, 9),
(10, 180, 'P', 0, 1, 10);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `folder`
--

CREATE TABLE `folder` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `path` VARCHAR(255) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `lastModifiedTSD` TIMESTAMP NULL,
  `parentFolderID` INT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `path_name_UNIQUE` (`path`, `name` ASC),
  UNIQUE INDEX `idfolder_UNIQUE` (`ID` ASC),
  INDEX `fk_folder_folder1_idx` (`parentFolderID` ASC),
  CONSTRAINT `fk_folder_folder1`
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
  `name` VARCHAR(45) NOT NULL,
  `lastAccessedTSD` TIMESTAMP NULL,
  `lastModifiedTSD` TIMESTAMP NULL,
  `creationTSD` TIMESTAMP NULL,
  `sizeInBytes` BIGINT NOT NULL,
  `sizeAsString` VARCHAR(20) NOT NULL,
  `filetype` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `idfile_UNIQUE` (`ID` ASC),
  CONSTRAINT `fk_file_folder1`
    FOREIGN KEY (`folderID`)
    REFERENCES `folder` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
  )
ENGINE = InnoDB;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
