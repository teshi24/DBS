USE `fsc`;
-- möglichst einschränken 
-- > erst ganz am schluss left join auf die Files wos nötig ist --> done
-- Funktionen im Where und Order by sparsam
-- zwischentabellen brauchen keine sortierung, eigenentlich nur am schluss --> done
/*
set profiling = 1;
-- select * from folder_foldername_preAnalysis;
-- select * from folder_foldername_preAnalysis_duplicatedFolders;
select * from FOLDER_FOLDERNAME_ANALYSIS;

SELECT * FROM FILE_FILENAME_ANALYSIS;
SELECT * FROM FILE_FOLDERNAME_ANALYSIS;
SELECT * FROM FILE_FILETYPE_ANALYSIS;
SELECT * FROM file_size_analysis;
select * from file_lastAccessed_analysis;
*/

set profiling = 1;
START TRANSACTION;

DROP TABLE IF EXISTS file_consolidatedRatios;
CREATE TABLE file_consolidatedRatios (
   PRIMARY KEY (id), 
   -- adding additional tables for calculations which will be done later
   B_ratio int,  D_ratio int, N_ratio int, no_ratio_count int, recommendation varchar(10), recommendationRatio int
) AS
-- explain
SELECT f.id, f.folder, f.folderid, f.name, f.lastAccessedTSD, f.sizeAsString, f.sizeInBytes, f.filetype
        , fna.recommendedAction as fna_recommendedAction, fna.ratio * fna.weight / 100 as fna_weightedRatio
		, ffna.recommendedAction as ffna_recommendedAction, ffna.ratio * ffna.weight / 100 as ffna_weightedRatio
		, fsa.recommendedAction as fta_recommendedAction, fta.ratio * fta.weight / 100 as fta_weightedRatio
		, fsa.recommendedAction as fsa_recommendedAction, fsa.ratio * fsa.weight / 100 as fsa_weightedRatio
		, flaa.recommendedAction as flaa_recommendedAction, flaa.ratio * flaa.weight / 100 as flaa_weightedRatio
FROM
  file f
  	LEFT JOIN file_filename_analysis fna on fna.id = f.id
	LEFT JOIN FILE_FOLDERNAME_ANALYSIS ffna on ffna.id = f.id
	LEFT JOIN FILE_FILETYPE_ANALYSIS fta on fta.id = f.id
	LEFT JOIN file_size_analysis fsa on fsa.id = f.id
	LEFT JOIN file_lastAccessed_analysis flaa on flaa.id = f.id
;
-- select * from file_consolidatedRatios;

DELIMITER //
DROP PROCEDURE IF EXISTS calculateConsolidatedRatios //
CREATE PROCEDURE calculateConsolidatedRatios()
BEGIN
  SET SQL_SAFE_UPDATES=0;
  -- explain
  UPDATE file_consolidatedRatios m  
  SET
    m.B_ratio = IF(m.fna_recommendedAction = 'B', m.fna_weightedRatio, 0) + IF(m.ffna_recommendedAction = 'B', m.ffna_weightedRatio, 0) +IF(m.fta_recommendedAction = 'B', m.fta_weightedRatio, 0) +IF(m.fsa_recommendedAction = 'B', m.fsa_weightedRatio, 0) +IF(m.flaa_recommendedAction = 'B', m.flaa_weightedRatio, 0),
    m.D_ratio = IF(m.fna_recommendedAction = 'D', m.fna_weightedRatio, 0) + IF(m.ffna_recommendedAction = 'D', m.ffna_weightedRatio, 0) + IF(m.fta_recommendedAction = 'D', m.fta_weightedRatio, 0) +IF(m.fsa_recommendedAction = 'D', m.fsa_weightedRatio, 0) +IF(m.flaa_recommendedAction = 'D', m.flaa_weightedRatio, 0),
    m.N_ratio = IF(m.fna_recommendedAction = 'N', m.fna_weightedRatio, 0) + IF(m.ffna_recommendedAction = 'N', m.ffna_weightedRatio, 0) + IF(m.fta_recommendedAction = 'N', m.fta_weightedRatio, 0) +IF(m.fsa_recommendedAction = 'N', m.fsa_weightedRatio, 0) +IF(m.flaa_recommendedAction = 'N', m.flaa_weightedRatio, 0),
    m.no_ratio_count = IF(m.fna_recommendedAction IS NULL, 1, 0) + IF(m.ffna_recommendedAction IS NULL, 1, 0) + IF(m.fta_recommendedAction IS NULL, 1, 0) +IF(m.fsa_recommendedAction  IS NULL, 1, 0) +IF(m.flaa_recommendedAction IS NULL, 1, 0)
  ;
  
  CREATE INDEX ix_fileConsolidatedRatios_dratio on file_consolidatedratios (D_ratio ASC);
  CREATE INDEX ix_fileConsolidatedRatios_nratio on file_consolidatedratios (N_ratio ASC);
  CREATE INDEX ix_fileConsolidatedRatios_bratio on file_consolidatedratios (B_ratio ASC);

  -- explain
  UPDATE file_consolidatedRatios m
  SET
    m.recommendation = CASE
							WHEN m.N_ratio >= D_ratio AND m.N_ratio >= B_ratio THEN 'N'
							WHEN m.D_ratio > B_ratio THEN 'D'
							WHEN m.B_ratio > D_ratio THEN 'B'
							WHEN m.D_ratio = B_ratio THEN 'B/D'
							ELSE null
						END,
	m.recommendationRatio = CASE
							WHEN m.N_ratio >= D_ratio AND m.N_ratio >= B_ratio THEN m.N_ratio
							WHEN m.D_ratio >= B_ratio THEN m.D_ratio
							WHEN m.B_ratio > D_ratio THEN m.B_ratio
							ELSE null
						END
  ;
  SET SQL_SAFE_UPDATES=1;
END //
DELIMITER ;

CALL calculateConsolidatedRatios();

-- CREATE INDEX ix_fileConsolidatedRatios_recommendation on file_consolidatedratios (recommendation);
CREATE INDEX ix_fileConsolidatedRatios_folderId on file_consolidatedRatios (folderId);

-- explain
SELECT f.id, f.folder, f.name, f.lastAccessedTSD, f.sizeAsString, f.sizeInBytes, f.filetype
, f.recommendation, f.recommendationRatio from file_consolidatedRatios f;

COMMIT;
SHOW PROFILES;

-- folder analysis
DROP TABLE IF EXISTS folderPreAnalysis;
CREATE TABLE folderPreAnalysis (PRIMARY KEY (folderId, recommendation)) as
-- explain
 SELECT f.folderId, f.folder, f.recommendation, AVG(f.recommendationRatio) as recommendationRatio, COUNT(*) as recommendationTypeCount
 FROM file_consolidatedRatios f
 GROUP BY f.folderid, f.recommendation;

-- CREATE INDEX ix_folderPreAnalysis_recommendationRatio on folderPreAnalysis (recommendationRatio);
-- CREATE INDEX ix_folderPreAnalysis_recommendation on folderPreAnalysis (recommendation);

DROP TABLE IF EXISTS folderPreAnalysis_duplicatedFolders;
CREATE TABLE folderPreAnalysis_duplicatedFolders (PRIMARY KEY (folderId)) as
-- explain
  SELECT folderId /*, COUNT(*) */ from folderPreAnalysis F
  GROUP BY folderId
  HAVING COUNT(*) > 1;

DROP TABLE IF EXISTS FOLDER_ANALYSIS;
CREATE TABLE FOLDER_ANALYSIS (PRIMARY KEY (folderID)) as 
-- explain
	SELECT f.*, sum(fileCr.sizeInBytes) as sizeInBytes, count(*) as countOfFiles, max(fileCr.lastAccessedTSD) as lastAccessedTSD FROM folderPreAnalysis F
       JOIN folderPreAnalysis_duplicatedFolders df on F.folderId = df.folderId
       JOIN file_consolidatedRatios fileCr on f.folderId = fileCr.folderId
	   WHERE f.recommendationRatio = (
		  SELECT MAX(innerF.recommendationRatio)
		  FROM folderPreAnalysis innerF
		  WHERE innerF.folderID = F.folderID
		) AND f.recommendation = (
		  SELECT MAX(innerF.recommendation)
		  FROM folderPreAnalysis innerF
		  WHERE innerF.folderID = F.folderID
        )
        GROUP BY f.folderId;
INSERT IGNORE INTO folder_analysis (`folderId`, `folder`, `recommendation`, `recommendationRatio`, `recommendationTypeCount`, `sizeInBytes`, `countOfFiles`, `lastAccessedTSD`)
	-- explain
    SELECT f.*, sum(fileCr.sizeInBytes) AS sizeInBytes, count(*) AS countOfFiles, max(fileCr.lastAccessedTSD) AS lastAccessedTSD FROM folderPreAnalysis F
    JOIN file_consolidatedRatios fileCr ON f.folderId = fileCr.folderId
		GROUP BY f.folderId;

-- CREATE INDEX ix_folderAnalysis_recommendationRatioNSizeInBytes ON folder_analysis (recommendationRatio DESC, sizeInBytes DESC);

-- explain
SELECT * FROM folder_analysis f
 ORDER BY f.recommendationRatio DESC, f.sizeInBytes DESC;

COMMIT;
SHOW PROFILES;
 -- SHOW PROFILE FOR QUERY 1;
SET PROFILING = 0;
