USE `fsc`;
SET profiling = 1;
START TRANSACTION;

-- Ziel: finde ratios für folders
-- FOLDERNAME

DROP TABLE IF exists folder_foldername_preAnalysis;
CREATE TABLE folder_foldername_preAnalysis (PRIMARY KEY (folderID, ratiobasisID)) AS
-- / EXPLAIN
SELECT F.id AS 'folderID', F.path, FN.id AS 'foldernameID', FN.ratiobasisID, RB.recommendedAction, RB.ratio, RB.weight
    FROM FOLDER F
    JOIN FOLDERNAME FN ON fn.id IN (
		SELECT innerFN.id FROM FOLDERNAME innerFN
			WHERE F.path LIKE innerFN.name
    )
    JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
    GROUP BY folderID, ratiobasisID;
 
-- CREATE INDEX ix_folderFoldernamePreAnalysis_weightRatio on folder_foldername_preAnalysis(weight asc, ratio asc);
-- CREATE INDEX ix_folderFoldernamePreAnalysis_weight on folder_foldername_preAnalysis(weight asc);
-- CREATE INDEX ix_folderFoldernamePreAnalysis_ratio on folder_foldername_preAnalysis(ratio asc);

-- explain
-- SELECT * FROM folder_foldername_preAnalysis;

DROP TABLE IF EXISTS folder_foldername_preAnalysis_duplicatedFolders;
CREATE TABLE folder_foldername_preAnalysis_duplicatedFolders (PRIMARY KEY (folderId)) AS
-- explain
  SELECT folderId /*, COUNT(*) */ FROM folder_foldername_preAnalysis F
  GROUP BY folderId
  HAVING COUNT(*) > 1;

-- SELECT * FROM folder_foldername_preAnalysis_duplicatedFolders;

DROP TABLE IF EXISTS FOLDER_FOLDERNAME_ANALYSIS;
CREATE TABLE FOLDER_FOLDERNAME_ANALYSIS (PRIMARY KEY (folderID)) AS 
-- explain
	SELECT f.* FROM folder_foldername_preAnalysis F
       JOIN folder_foldername_preAnalysis_duplicatedFolders df ON F.folderId =  df.folderId
	   WHERE f.weight = (
		  SELECT MAX(innerF.weight)
		  FROM folder_foldername_preAnalysis innerF
		  WHERE innerF.folderID = F.folderID
		) AND f.ratio = (
		  SELECT MAX(innerF.ratio)
		  FROM folder_foldername_preAnalysis innerF
		  WHERE innerF.folderID = F.folderID
		);

-- SELECT * FROM FOLDER_FOLDERNAME_ANALYSIS;

INSERT IGNORE INTO FOLDER_FOLDERNAME_ANALYSIS (`folderID`, `path`, `foldernameID`, `ratiobasisID`, `recommendedAction`, `ratio`, `weight`)
-- explain
	SELECT * FROM folder_foldername_preAnalysis F;

SELECT * FROM FOLDER_FOLDERNAME_ANALYSIS;

COMMIT;
SHOW PROFILES;

-- Ziel: finde ratios für 1 file (filename)
-- FILENAME todo: this is probably not working
DROP TABLE IF EXISTS FILE_FILENAME_ANALYSIS;

CREATE TABLE FILE_FILENAME_ANALYSIS (PRIMARY KEY (ID)) AS
-- / EXPLAIN
SELECT F.id, F.name, F.folder, F.folderId, FN.ratiobasisID, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	JOIN FILENAME FN ON F.name = FN.name
    JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID;

SELECT * FROM FILE_FILENAME_ANALYSIS;

COMMIT;
SHOW PROFILES;
 
-- Ziel: finde ratios für 1 file (foldername)
-- FOLDERNAME
DROP TABLE IF EXISTS FILE_FOLDERNAME_ANALYSIS;
CREATE TABLE FILE_FOLDERNAME_ANALYSIS (PRIMARY KEY (ID)) AS
-- / EXPLAIN
SELECT F.id, F.name, F.folder, F.folderId, FN.ratiobasisID, FN.recommendedAction, FN.ratio, FN.weight
    FROM FILE F
    JOIN FOLDER_FOLDERNAME_ANALYSIS FN ON F.folderID = FN.folderID;

SELECT * FROM FILE_FOLDERNAME_ANALYSIS;

COMMIT;
SHOW PROFILES;
 
-- Ziel: finde ratios für 1 file (filetype)    
-- FILETYPE
DROP TABLE IF exists FILE_FILETYPE_ANALYSIS;
CREATE TABLE FILE_FILETYPE_ANALYSIS (PRIMARY KEY (ID)) AS
-- / EXPLAIN
SELECT F.id, F.name, F.folder, F.filetype, FT.fileending AS 'IDENTIFIED FILEENDING',  FT.ratiobasisID, RB.recommendedAction, RB.ratio, RB.weight
    FROM FILE F
    JOIN FILETYPE FT ON F.filetype = FT.fileending
    JOIN RATIOBASIS RB ON FT.ratiobasisID = RB.ID;

SELECT * FROM FILE_FILETYPE_ANALYSIS;

COMMIT;
SHOW PROFILES;

-- Ziel: finde ratios für 1 file (size)
-- SIZE
DROP TABLE IF exists file_size_analysis;
CREATE TABLE file_size_analysis (PRIMARY KEY (ID)) AS
-- EXPLAIN
SELECT F.id, F.name, F.folder, F.sizeInBytes, F.sizeAsString,
       S.sizeInBytes AS minSizeInBytes, S.id AS "sizeId", S.sizeInBytes AS 'treshhold sizeInBytes', S.sizeAsString AS 'treshhold sizeAsString', S.ratiobasisID,
       RB.recommendedAction, RB.ratio, RB.weight
 FROM FILE F
	JOIN SIZE S ON S.sizeInBytes = (
        SELECT MIN(innerS.sizeInBytes)
        FROM SIZE innerS
        WHERE innerS.sizeInBytes >= F.sizeInBytes
    )
    JOIN RATIOBASIS RB ON S.ratiobasisID = RB.ID;

-- EXPLAIN
SELECT * FROM file_size_analysis;

COMMIT;
SHOW PROFILES;
 
-- Ziel: finde ratios für 1 file (last accessed)
-- DATE - last accessed (first without checking fileloccation)
DROP TABLE IF EXISTS foldertypes;
CREATE TABLE foldertypes (PRIMARY KEY (id)) AS
-- explain
  SELECT f.id, 'S' as 'type' FROM FOLDER f
    where f.path like '%:\\\\Windows' or f.path like '%:\\\\Windows\\\\%'
     or f.path like '%\\\\Program Files' or f.path like '%\\\\Program Files\\\\%'
     or f.path like '%\\\\Program Files (x86)' or f.path like '%\\\\Program Files (x86)\\\\%'
     or f.path like '%\\\\Programme' or f.path like '%\\\\Programme\\\\%'
;
INSERT IGNORE INTO foldertypes (id, type)
-- explain
  SELECT f.id, 'R' FROM FOLDER f
    WHERE f.path like '%\\\\$RECYCLE.BIN' or f.path like '%\\\\$RECYCLE.BIN\\\\%'
;
INSERT IGNORE INTO foldertypes (id, type)
-- explain
  SELECT f.id, 'B' FROM FOLDER f
    WHERE f.path like '%\\\\Sicherungen' or f.path like '%\\\\Sicherungen\\\\%'
      or f.path like '%\\\\backup' or f.path like '%\\\\backup\\\\%'
;
INSERT IGNORE INTO foldertypes (id, type)
-- explain
  SELECT f.id, 'P' FROM FOLDER f
    WHERE f.path like '%\\\\Documents' or f.path like '%\\\\Documents\\\\%'
     or f.path like '%\\\\Dokumente' or f.path like '%\\\\Dokumente\\\\%'
     or f.path like '%\\\\Music' or f.path like '%\\\\Music\\\\%'
     or f.path like '%\\\\Musik' or f.path like '%\\\\Musik\\\\%'
     or f.path like '%\\\\Videos' or f.path like '%\\\\Videos\\\\%'
     or f.path like '%\\\\Pictures' or f.path like '%\\\\Pictures\\\\%'
     or f.path like '%\\\\Bilder' or f.path like '%\\\\Bilder\\\\%'
     or f.path like '%\\\\Contacts' or f.path like '%\\\\Contacts\\\\%'
     or f.path like '%\\\\OneDrive' or f.path like '%\\\\OneDrive\\\\%'
;
INSERT IGNORE INTO foldertypes (id, type)
-- explain
   SELECT f.id, 'A' FROM FOLDER f;

DROP TABLE IF exists file_lastAccessed_analysis;
CREATE TABLE file_lastAccessed_analysis (PRIMARY KEY (ID)) AS
-- explain 
  SELECT F.id, F.name, F.folder, F.lastAccessedTSD,
         DATEDIFF(NOW(), F.lastAccessedTSD) AS differenceToToday, d.days AS 'tresholdDays',
         D.ratiobasisId, RB.recommendedAction, RB.ratio, RB.weight
    FROM FILE F
    JOIN foldertypes ft ON ft.id = f.folderID 
    JOIN date d ON d.lastAccess = 1 AND d.type = ft.type AND d.days = (
	SELECT MIN(innerD.days)
            FROM date innerD
            WHERE innerD.days >= DATEDIFF(NOW(), F.lastAccessedTSD)
                  AND innerD.lastAccess = 1
                  AND innerD.type = ft.type
    )
    JOIN ratiobasis rb on rb.ID = d.ratiobasisID
;

SELECT * FROM file_lastAccessed_analysis;

COMMIT;
SET PROFILING = 0;
SHOW PROFILES;
-- SHOW PROFILE FOR QUERY 1;
