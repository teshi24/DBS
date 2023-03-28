-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
SHOW WARNINGS;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`filetype`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`filetype` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`filetype` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `id_UNIQUE` (`ID` ASC) VISIBLE,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`file`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`file` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`file` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `folderID` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `lastAccess` TIMESTAMP NULL,
  `priority` VARCHAR(45) NULL,
  `changeDate` TIMESTAMP NULL,
  `lastSave` TIMESTAMP NULL,
  `fileTypeID` INT NULL COMMENT 'todo: in eigene Klasse auslagern\n',
  `creationDate` TIMESTAMP NOT NULL,
  `size` DECIMAL NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `idfile_UNIQUE` (`ID` ASC) VISIBLE,
  INDEX `fk_file_filetype_idx` (`fileTypeID` ASC) VISIBLE,
  CONSTRAINT `fk_file_filetype`
    FOREIGN KEY (`fileTypeID`)
    REFERENCES `mydb`.`filetype` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`folder`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`folder` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`folder` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `path` VARCHAR(500) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `modifyDate` TIMESTAMP NULL,
  `size` INT NULL COMMENT 'maybe anyway anywhere 0',
  `type` VARCHAR(45) NULL COMMENT 'maybe anyway everywhere \"Dateiordner\"...',
  `parentFolderID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `path_UNIQUE` (`path` ASC) VISIBLE,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE,
  UNIQUE INDEX `idfolder_UNIQUE` (`ID` ASC) VISIBLE,
  INDEX `fk_folder_folder1_idx` (`parentFolderID` ASC) VISIBLE,
  CONSTRAINT `fk_folder_file1`
    FOREIGN KEY (`ID`)
    REFERENCES `mydb`.`file` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_folder_folder1`
    FOREIGN KEY (`parentFolderID`)
    REFERENCES `mydb`.`folder` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
