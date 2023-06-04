USE `fsc`;
set profiling = 1;
-- möglichst einschränken 
-- > erst ganz am schluss left join auf die Files wos nötig ist --> done
-- Funktionen im Where und Order by sparsam
-- zwischentabellen brauchen keine sortierung, eigenentlich nur am schluss --> done

-- todo: add also the analysis data to it now...
-- Ziel: finde ratios für folders
-- FOLDERNAME
-- /*
set profiling = 0;
DROP TABLE IF exists FOLDER_FOLDERNAME_ANALYSIS;
set profiling = 1;

CREATE TABLE FOLDER_FOLDERNAME_ANALYSIS (primary key (ID)) AS
-- / EXPLAIN
SELECT F.id, F.path, FN.ratiobasisID, RB.recommendedAction, RB.ratio, RB.weight FROM FOLDER F
	JOIN FOLDERNAME FN ON FN.name = F.name
    JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID;

SELECT * FROM FOLDER_FOLDERNAME_ANALYSIS;

-- Ziel: finde ratios für 1 file (filename)
-- FILENAME todo: this is probably not working
-- /*
set profiling = 0;
DROP TABLE IF exists FILE_FILENAME_ANALYSIS;
set profiling = 1;

CREATE TABLE FILE_FILENAME_ANALYSIS (primary key (ID)) AS
-- / EXPLAIN
SELECT F.id, F.name, F.folder, F.folderId, FN.ratiobasisID, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	JOIN FILENAME FN ON F.name = FN.name
    JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID;

SELECT * FROM FILE_FILENAME_ANALYSIS;

-- Ziel: finde ratios für 1 file (foldername)
-- FOLDERNAME
-- /*
set profiling = 0;
DROP TABLE IF exists FILE_FOLDERNAME_ANALYSIS;
set profiling = 1;

CREATE TABLE FILE_FOLDERNAME_ANALYSIS (primary key (ID)) AS
-- / EXPLAIN
SELECT F.id, F.name, F.folder, F.folderId, FN.ratiobasisID, FN.recommendedAction, FN.ratio, FN.weight FROM FILE F
	JOIN FOLDER_FOLDERNAME_ANALYSIS FN ON F.folderID = FN.ID;

 SELECT * FROM FILE_FOLDERNAME_ANALYSIS;

-- Ziel: finde ratios für 1 file (filetype)    
-- FILETYPE
--  /*
set profiling = 0;
DROP TABLE IF exists FILE_FILETYPE_ANALYSIS;
set profiling = 1;

CREATE TABLE FILE_FILETYPE_ANALYSIS (primary key (ID)) AS
-- / EXPLAIN
SELECT F.id, F.name, F.folder, F.filetype, FT.fileending as 'IDENTIFIED FILEENDING',  FT.ratiobasisID, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	JOIN FILETYPE FT ON F.filetype = FT.fileending
    JOIN RATIOBASIS RB ON FT.ratiobasisID = RB.ID;

SELECT * FROM FILE_FILETYPE_ANALYSIS;

-- Ziel: finde ratios für 1 file (size)
-- SIZE
set profiling = 0;
DROP TABLE IF exists fileDataWithMinSizeReference;
set profiling = 1;

 CREATE TABLE fileDataWithMinSizeReference AS
-- EXPLAIN
SELECT F.id, F.name, F.folder, F.sizeInBytes, F.sizeAsString,
       S.sizeInBytes as minSizeInBytes, S.id as "sizeId", S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString', S.ratiobasisID,
       RB.recommendedAction, RB.ratio, RB.weight
 FROM FILE F
	JOIN SIZE S ON S.sizeInBytes = (
        SELECT MIN(innerS.sizeInBytes)
        FROM SIZE innerS
        WHERE innerS.sizeInBytes > F.sizeInBytes
    )
    JOIN RATIOBASIS RB ON S.ratiobasisID = RB.ID;

-- EXPLAIN
SELECT * FROM fileDataWithMinSizeReference;

-- Ziel: finde ratios für 1 file (last accessed)
-- DATE - last accessed (first without checking fileloccation)
-- /*
-- todo: used for creation of this data, but could probably be included in foldername analysis
set profiling = 0;
DROP TABLE IF EXISTS foldertypes;
set profiling = 1;

set profiling = 0;
CREATE TABLE foldertypes (PRIMARY KEY (id)) as
select f.id, 'S' as 'type' FROM FOLDER f
where f.path like '%:\\\\Windows' or f.path like '%:\\\\Windows\\\\%'
   or f.path like '%\\\\Program Files%' or f.path like '%\\\\Program Files\\\\%'
   or f.path like '%\\\\Program Files (x86)%' or f.path like '%\\\\Program Files (x86)\\\\%'
   or f.path like '%\\\\Programme%' or f.path like '%\\\\Programme\\\\%'
;
INSERT IGNORE INTO foldertypes (id, type)
select f.id, 'B' FROM FOLDER f
where f.path like '%\\\\Sicherungen%' or f.path like '%\\\\Sicherungen\\\\%'
   or f.path like '%\\\\backup%' or f.path like '%\\\\backup\\\\%'
;
INSERT IGNORE INTO foldertypes (id, type)
select f.id, 'P' FROM FOLDER f
where f.path like '%\\\\Documents%' or f.path like '%\\\\Documents\\\\%'
   or f.path like '%\\\\Music%' or f.path like '%\\\\Music\\\\%'
   or f.path like '%\\\\Videos%' or f.path like '%\\\\Videos\\\\%'
   or f.path like '%\\\\Pictures%' or f.path like '%\\\\Pictures\\\\%'
   or f.path like '%\\\\Contacts%' or f.path like '%\\\\Contacts\\\\%'
   or f.path like '%\\\\OneDrive%' or f.path like '%\\\\OneDrive\\\\%'
;
INSERT IGNORE INTO foldertypes (id, type)
select f.id, 'A' FROM FOLDER f;
set profiling = 1;
-- */

set profiling = 0;
DROP TABLE IF exists fileDataWithMinDaysReference;
set profiling = 1;

CREATE TABLE fileDataWithMinDaysReference AS 
-- explain
SELECT F.id, F.name, F.folder, F.lastAccessedTSD, DATEDIFF(NOW(), F.lastAccessedTSD) as differenceToToday, d.days as 'tresholdDays', D.ratiobasisId
 FROM FILE F
    JOIN foldertypes ft on ft.id = f.id 
	JOIN date d ON d.lastAccess = 1 and d.type = ft.type and d.days = (
		select min(innerD.days)
        from date innerD
        where innerD.days >= DATEDIFF(NOW(), F.lastAccessedTSD) and innerD.lastAccess = 1 and innerD.type = ft.type
    ); /* todo: could be further improved when the function is not used here...*/
 
-- EXPLAIN
SELECT filedata.id, filedata.folder, filedata.name, filedata.lastAccessedTSD, fileData.differenceToToday, fileData.tresholdDays, fileData.ratiobasisId
	from fileDataWithMinDaysReference fileData;
	
 show profiles;
 -- show profile for query 1;
set profiling = 0;
