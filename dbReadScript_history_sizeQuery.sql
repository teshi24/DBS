USE `fsc`;
set profiling = 1;
-- möglichst einschränken 
-- > erst ganz am schluss left join auf die Files wos nötig ist --> done
-- Funktionen im Where und Order by sparsam
-- zwischentabellen brauchen keine sortierung, eigenentlich nur am schluss --> done

-- todo: add also the analysis data to it now...
/*
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
-- FILENAME
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
*/

-- Ziel: finde ratios für 1 file (size)
-- SIZE
/*
set profiling = 0;
DROP TABLE IF exists fileDataWithMinSizeReference;
set profiling = 1;

CREATE TABLE fileDataWithMinSizeReference AS
-- explain
SELECT F.id, F.name, F.folder, F.sizeInBytes, F.sizeAsString, S.sizeInBytes as minSizeInBytes
 FROM FILE F
	JOIN SIZE S ON F.sizeInBytes <= S.sizeInBytes
    GROUP BY F.id
    Having min(S.sizeInBytes) = S.sizeInBytes;
-- having mit funktionen - ist performance engpass, analog zum where --> todo: minimums agreggieren
-- created index for improving performance

set profiling = 0; -- todo: consider to check if this is worth the time, cause it seem to take also 5 seconds
create index ix_fileDataWithMinSizeReference_minSizeInBytes on fileDataWithMinSizeReference(minSizeInBytes asc);
set profiling = 1;

EXPLAIN
SELECT filedata.id, filedata.name, filedata.folder, filedata.sizeInBytes, filedata.sizeAsString, S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString', S.ratiobasisID
	FROM size s
	JOIN fileDataWithMinSizeReference filedata ON filedata.minSizeInBytes = S.sizeInBytes;
-- optimization: saved sizeID
 CREATE TABLE fileDataWithMinSizeReference AS
-- EXPLAIN
 SELECT F.id, F.name, F.folder, F.sizeInBytes, F.sizeAsString, S.sizeInBytes as minSizeInBytes, S.id as "sizeId"
 FROM FILE F
	JOIN SIZE S ON F.sizeInBytes <= S.sizeInBytes
    GROUP BY F.id
    Having min(S.sizeInBytes) = S.sizeInBytes;

-- EXPLAIN
SELECT filedata.id, filedata.name, filedata.folder, filedata.sizeInBytes, filedata.sizeAsString, S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString', S.ratiobasisID
	FROM size s
	JOIN fileDataWithMinSizeReference filedata ON filedata.sizeId = S.id;
    
optimization: use subquery instead of group by having min
set profiling = 0;
DROP TABLE IF exists fileDataWithMinSizeReference;
set profiling = 1;

 CREATE TABLE fileDataWithMinSizeReference AS
-- EXPLAIN
SELECT F.id, F.name, F.folder, F.sizeInBytes, F.sizeAsString, S.sizeInBytes as minSizeInBytes, S.id as "sizeId"
 FROM FILE F
	JOIN SIZE S ON S.sizeInBytes = (
        SELECT MIN(innerS.sizeInBytes)
        FROM SIZE innerS
        WHERE innerS.sizeInBytes > F.sizeInBytes
    );

-- EXPLAIN
SELECT filedata.id, filedata.name, filedata.folder, filedata.sizeInBytes, filedata.sizeAsString, S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString', S.ratiobasisID
FROM size s
JOIN fileDataWithMinSizeReference filedata ON filedata.sizeId = S.id;
*/
/* this optimization approach would be working, however, it takes longer than the one chosen below
set profiling = 0;
DROP TABLE IF exists fileDataWithMinSizeReference;
set profiling = 1;
 CREATE TABLE fileDataWithMinSizeReference AS
-- EXPLAIN
 SELECT F.id, F.name, F.folder, F.sizeInBytes, F.sizeAsString, (select S.id from size s
   where s.sizeInBytes > f.sizeInBytes
   order by s.sizeInBytes ASC
   limit 1) as "sizeId"
 FROM FILE F;
-- EXPLAIN
SELECT filedata.id, filedata.name, filedata.folder, filedata.sizeInBytes, filedata.sizeAsString, S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString', S.ratiobasisID
	FROM size s
	JOIN fileDataWithMinSizeReference filedata ON filedata.sizeId = S.id;

/* this approach is not working, since this mysql version does not support window functions
set profiling = 0;
DROP TABLE IF exists fileDataWithMinSizeReference;
set profiling = 1;
 CREATE TABLE fileDataWithMinSizeReference AS
-- EXPLAIN
 SELECT F.id, F.name, F.folder, F.sizeInBytes, F.sizeAsString, S.sizeInBytes as minSizeInBytes, S.id as "sizeId"
 FROM (
   SELECT F.*, ROW_NUMBER() OVER (partition by F.ID ORDER BY S.sizeInBytes ASC) AS row_num -- minimum, maximum should be desc
       FROM file f
       join size s on s.sizeInBytes > f.sizeInBytes
) as f
 join size s on s.id = f.id and s.sizeInBytes = f.sizeInBytes
 where f.row_num = 1;

-- EXPLAIN
SELECT filedata.id, filedata.name, filedata.folder, filedata.sizeInBytes, filedata.sizeAsString, S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString', S.ratiobasisID
	FROM size s
	JOIN fileDataWithMinSizeReference filedata ON filedata.sizeId = S.id;
*/

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

/*
-- Ziel: finde ratios für 1 file (last accessed)
-- DATE - last accessed (first without checking fileloccation)
set profiling = 0;
DROP TABLE IF EXISTS fileDataWithMinDaysReference;
set profiling = 1;

CREATE TABLE fileDataWithMinDaysReference AS 
-- explain
SELECT F.id, F.name, F.folder, F.lastAccessedTSD, DATEDIFF(NOW(), F.lastAccessedTSD) as differenceToToday, min(D.days) as minDays FROM FILE F
		JOIN date D on D.lastAccess = 1 and DATEDIFF(NOW(), F.lastAccessedTSD) <= D.days
		GROUP BY F.id;
                -- todo: hier datediff anders berechnen um index zu nutzen
-- created index for improving performance

set profiling = 0; -- todo: check if this is worth the time as it seem to take also 1 second
create index ix_fileDataWithMinDaysReference_minDays on fileDataWithMinDaysReference(minDays asc);
set profiling = 1;

-- EXPLAIN
SELECT filedata.id, filedata.folder, filedata.name, filedata.lastAccessedTSD, fileData.differenceToToday, D.days as 'treshhold days', D.ratiobasisId
	from date D
	JOIN fileDataWithMinDaysReference fileData on D.days = fileData.minDays and D.lastAccess = 1
	GROUP BY fileData.id, D.ratiobasisId, D.days -- todo: remove as probably not necessary, sice it is already "grouped" in filedata with reference
	;

*/

 show profiles;
 -- show profile for query 1;
set profiling = 0;
