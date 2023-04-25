-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema fsc
-- -----------------------------------------------------
-- fileSystemChecker
DROP SCHEMA IF EXISTS `fsc` ;

-- -----------------------------------------------------
-- Schema fsc
--
-- fileSystemChecker
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `fsc` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
SHOW WARNINGS;
USE `fsc` ;

-- -----------------------------------------------------
-- Table `fsc`.`file`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fsc`.`file` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fsc`.`file` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `folderID` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `lastAccess` TIMESTAMP NULL,
  `priority` VARCHAR(45) NULL,
  `changeDate` TIMESTAMP NULL,
  `lastSave` TIMESTAMP NULL,
  `creationDate` TIMESTAMP NULL,
  `size` DECIMAL NOT NULL,
  `filetype` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `idfile_UNIQUE` (`ID` ASC))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `fsc`.`folder`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fsc`.`folder` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fsc`.`folder` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `path` VARCHAR(255) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `modifyDate` TIMESTAMP NULL,
  `size` INT NULL COMMENT 'maybe anyway anywhere 0',
  `type` VARCHAR(45) NULL COMMENT 'maybe anyway everywhere \"Dateiordner\"...',
  `parentFolderID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `path_UNIQUE` (`path` ASC),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  UNIQUE INDEX `idfolder_UNIQUE` (`ID` ASC),
  INDEX `fk_folder_folder1_idx` (`parentFolderID` ASC),
  CONSTRAINT `fk_folder_file1`
    FOREIGN KEY (`ID`)
    REFERENCES `fsc`.`file` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_folder_folder1`
    FOREIGN KEY (`parentFolderID`)
    REFERENCES `fsc`.`folder` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `fsc`.`ratiobasis`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fsc`.`ratiobasis` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fsc`.`ratiobasis` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `ratio` DECIMAL NOT NULL,
  `weight` DECIMAL NOT NULL,
  `recommendedAction` ENUM('D', 'B', 'N') NULL COMMENT 'D = Delete, B = Backup, N = Nothing, don\\\'t touch!\', null = no specific action recommended by this entry alone',
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `fsc`.`filetype`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fsc`.`filetype` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fsc`.`filetype` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `fileending` VARCHAR(20) NOT NULL,
  `ratiobasisID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_filetype_ratiobasis1_idx` (`ratiobasisID` ASC),
  CONSTRAINT `fk_filetype_ratiobasis1`
    FOREIGN KEY (`ratiobasisID`)
    REFERENCES `fsc`.`ratiobasis` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `fsc`.`filename`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fsc`.`filename` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fsc`.`filename` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `ratiobasisID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  CONSTRAINT `fk_filename_ratiobasis1`
    FOREIGN KEY (`ratiobasisID`)
    REFERENCES `fsc`.`ratiobasis` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `fsc`.`foldername`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fsc`.`foldername` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fsc`.`foldername` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `ratiobasisID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  CONSTRAINT `fk_foldername_ratiobasis1`
    FOREIGN KEY (`ratiobasisID`)
    REFERENCES `fsc`.`ratiobasis` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `fsc`.`date`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fsc`.`date` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fsc`.`date` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `days` INT NOT NULL,
  `type` ENUM('R', 'A', 'P') NOT NULL DEFAULT 'A' COMMENT 'R = Recycle Bin, A = Anywhere, P = Personal Files',
  `created` TINYINT NOT NULL,
  `lastAccess` TINYINT NOT NULL,
  `ratiobasisID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  CONSTRAINT `fk_date_ratiobasis1`
    FOREIGN KEY (`ratiobasisID`)
    REFERENCES `fsc`.`ratiobasis` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `fsc`.`size`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fsc`.`size` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fsc`.`size` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `sizeInKB` INT NOT NULL,
  `ratiobasisID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  CONSTRAINT `fk_size_ratiobasis1`
    FOREIGN KEY (`ratiobasisID`)
    REFERENCES `fsc`.`ratiobasis` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
