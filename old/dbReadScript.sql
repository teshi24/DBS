use fsc;
set profiling = 1;

-- Ziel: finde ratios für folders
-- FOLDERNAME

-- drop table if exists xx_foldername_analyse;
CREATE TABLE xx_foldername_analyse (primary key (id)) as
-- explain
SELECT F.id, F.path, RB.recommendedAction, RB.ratio, RB.weight FROM FOLDER F
	JOIN FOLDERNAME FN ON FN.name = F.name
	JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
;
SELECT * from xx_foldername_analyse as fa
; -- 	ORDER BY ISNULL(fa.ratio), fa.ratio desc, fa.weight desc, fa.recommendedAction;

-- Ziel: finde ratios für 1 file
-- filepath

-- optimization: using redundancy on file path variable
-- EXPLAIN 
-- drop table if exists xx_filepath_analyse;

CREATE TABLE xx_filepath_analyse (primary key (id)) as
-- explain
SELECT F.id, F.name, F.folder, fa.recommendedAction, fa.ratio, fa.weight FROM FILE F
	JOIN xx_foldername_analyse fa ON F.folderID = fa.ID
-- 	ORDER BY ISNULL(fa.ratio), fa.ratio desc, fa.weight desc, fa.recommendedAction
;
select * from xx_filepath_analyse;
	-- 	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;
-- 20:51:29	SELECT F.name, F.folder, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F  LEFT JOIN FILENAME FN ON F.name = FN.name  LEFT JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID  ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction
-- 483802 row(s) returned
--       duration  / fetched
-- run 1 1.750 sec / 0.688 sec
-- run 2 1.687 sec / 0.703 sec
-- after db indexing
-- 483802 row(s) returned
--       duration  / fetched
-- run 1 1.875 sec / 0.672 sec
-- run 2 1.844 sec / 0.703 sec
-- ! seems even to be worse

-- Filename
-- EXPLAIN 

-- optimization: using redundancy on file path variable
-- drop table if exists xx_filename_analyse;

CREATE TABLE xx_filename_analyse (primary key (id)) as
-- EXPLAIN 
SELECT F.id, F.name, F.folder, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	JOIN filename FN ON FN.name = F.name
	JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
	; -- ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;

select * from xx_filename_analyse;

SELECT F.name, FO.path, F.filetype, FT.fileending as ‘IDENTIFIED FILEENDING’, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	LEFT JOIN FILETYPE FT ON F.filetype = FT.fileending
	LEFT JOIN RATIOBASIS RB ON FT.ratiobasisID = RB.ID
	LEFT JOIN FOLDER FO ON F.folderID = FO.ID
	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction
;

-- 20:56:08	SELECT F.name, F.folder, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F  LEFT JOIN FOLDER FO ON F.folderID = FO.ID  LEFT JOIN FOLDERNAME FN ON FN.name = FO.name  LEFT JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID  ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction
-- 483802 row(s) returned
--       duration  / fetched
-- run 1 2.141 sec / 0.687 sec
-- run 2 2.281 sec / 0.703 sec
-- after db indexing
-- 483802 row(s) returned
--       duration  / fetched
-- run 1 3.157 sec / 1.328 sec
-- run 2 2.140 sec / 0.703 sec
-- ! seems even to be worse

SELECT filedata.path, filedata.name, filedata.lastAccessedTSD, fileData.differenceToToday, D.days as 'treshhold days', RB.recommendedAction, RB.ratio, RB.weight from date D
JOIN (
	SELECT F.name, FO.path, F.lastAccessedTSD,
	DATEDIFF(NOW(), F.lastAccessedTSD) as differenceToToday, min(innerD.days) as minDays
		FROM FILE F
        LEFT JOIN FOLDER FO ON F.folderID = FO.ID
		LEFT JOIN date innerD on innerD.lastAccess = 1
				and DATEDIFF(NOW(), F.lastAccessedTSD) <= innerD.days
		GROUP BY F.name, FO.path, F.lastAccessedTSD
    ) fileData on D.days = minDays and D.lastAccess = 1
LEFT JOIN ratiobasis rb on D.ratiobasisId = rb.ID 
GROUP BY fileData.name, fileData.path, fileData.lastAccessedTSD, fileData.differenceToToday, 	D.ratiobasisId, D.days
ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction, filedata.path, 	filedata.name
;
select * from date;
CREATE TABLE file_lastAccessed_analysis (PRIMARY KEY (ID)) AS 
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


-- FILETYPE
-- EXPLAIN
-- optimization: using redundancy on file path variable

-- drop table if exists xx_filetype_analyse;
CREATE TABLE xx_filetype_analyse (primary key (id)) as
-- EXPLAIN
SELECT F.id, F.name, F.folder, F.filetype, FT.fileending as 'IDENTIFIED FILEENDING',  RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	JOIN FILETYPE FT ON F.filetype = FT.fileending
	JOIN RATIOBASIS RB ON FT.ratiobasisID = RB.ID
	;-- ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;
-- 20:57:50	SELECT F.name, F.folder, F.filetype, FT.fileending as 'IDENTIFIED FILEENDING',  RB.recommendedAction, RB.ratio, RB.weight FROM FILE F  LEFT JOIN FILETYPE FT ON F.filetype = FT.fileending  LEFT JOIN RATIOBASIS RB ON FT.ratiobasisID = RB.ID  ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction
-- 483802 row(s) returned
--       duration  / fetched
-- run 1 1.781 sec / 0.782 sec
-- run 2 1.938 sec / 0.766 sec
-- after db indexing
-- 483802 row(s) returned
--       duration  / fetched
-- run 1 2.016 sec / 0.765 sec
-- run 2 2.000 sec / 0.782 sec
-- ! seems even to be worse

SELECT * from xx_filetype_analyse;
-- SIZE
-- 20:19:11	SELECT F.name, FO.path, F.sizeInBytes, F.sizeAsString, S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString', RB.recommendedAction, RB.ratio, RB.weight  FROM FILE F  LEFT JOIN FOLDER FO ON F.folderID = FO.ID  LEFT JOIN SIZE S ON F.sizeInBytes <= S.sizeInBytes  LEFT JOIN RATIOBASIS RB ON S.ratiobasisID = RB.ID     GROUP BY F.name, FO.path, F.sizeInBytes, F.sizeAsString     Having min(S.sizeInBytes) = S.sizeInBytes  ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction, F.sizeInBytes desc
-- 410108 row(s) returned
--       duration  / fetched
-- run 1 51.000 sec / 1.015 sec
-- run 2 48.750 sec / 1.078 sec

-- DROP TABLE IF EXISTS fileDataWithMinSizeReference;
CREATE TABLE fileDataWithMinSizeReference AS 
-- explain
SELECT F.id, F.name, F.folder, F.sizeInBytes, F.sizeAsString, S.sizeInBytes as minSizeInBytes
 FROM FILE F
	JOIN SIZE S ON F.sizeInBytes <= S.sizeInBytes
    GROUP BY F.id
    Having min(S.sizeInBytes) = S.sizeInBytes;
-- created index for improving performance
-- create index ix_fileDataWithMinSizeReference_minSizeInBytes on fileDataWithMinSizeReference(minSizeInBytes asc);
--  explain
-- SELECT filedata.name, filedata.folder, filedata.sizeInBytes, filedata.sizeAsString, S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString', RB.recommendedAction, RB.ratio, RB.weight
	-- FROM size s
	-- JOIN fileDataWithMinSizeReference filedata ON filedata.minSizeInBytes = S.sizeInBytes
	-- JOIN RATIOBASIS RB ON S.ratiobasisID = RB.ID
	-- ; -- ORDER BY ISNULL(RB.ratio) asc, RB.weight desc, filedata.sizeInBytes desc;
-- optimization: save FKs and relevant data only
-- drop table if exists xx_size_analyse;

CREATE TABLE xx_size_analyse (primary key (id)) as
-- EXPLAIN
SELECT filedata.id, filedata.name, filedata.folder, filedata.sizeInBytes, filedata.sizeAsString, S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString'
-- , S.ratiobasisID
   , rb.ratio, rb.weight, rb.recommendedAction
	FROM size s
	JOIN fileDataWithMinSizeReference filedata ON filedata.minSizeInBytes = S.sizeInBytes
    join ratiobasis rb on rb.id = s.ratiobasisID
; -- 	ORDER BY ISNULL(rb.ratio), rb.ratio desc, rb.weight desc, recommendedAction, filedata.sizeInBytes;

select * from xx_size_analyse;


-- TODO: extract explain statements again for optimization round 3 - after db indexing

-- DATE - last accessed (first without checking fileloccation)
-- EXPLAIN
-- optimization: using redundancy on file path variable
-- EXPLAIN
         
         
-- 21:03:34	SELECT filedata.folder, filedata.name, filedata.lastAccessedTSD, fileData.differenceToToday, D.days as 'treshhold days', RB.recommendedAction, RB.ratio, RB.weight from date D JOIN (  SELECT F.name, F.folder, F.lastAccessedTSD, DATEDIFF(NOW(), F.lastAccessedTSD) as differenceToToday, min(innerD.days) as minDays   FROM FILE F   LEFT JOIN date innerD on innerD.lastAccess = 1 and DATEDIFF(NOW(), F.lastAccessedTSD) <= innerD.days   GROUP BY F.name, F.folder, F.lastAccessedTSD     ) fileData on D.days = minDays and D.lastAccess = 1 LEFT JOIN ratiobasis rb on D.ratiobasisId = rb.ID  GROUP BY fileData.name, fileData.folder, fileData.lastAccessedTSD, fileData.differenceToToday, D.ratiobasisId, D.days ORDER BY differenceToToday desc, ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction, filedata.folder, filedata.name
-- 457100 row(s) returned
--       duration  / fetched
-- run 1 48.203 sec / 3.734 sec
-- run 2 48.875 sec / 3.641 sec

-- optimization: using materalized table
DROP TABLE IF EXISTS fileDataWithMinDaysReference;
CREATE TABLE fileDataWithMinDaysReference AS 
-- ; explain
SELECT F.name, F.folder, F.lastAccessedTSD, DATEDIFF(NOW(), F.lastAccessedTSD) as differenceToToday, min(D.days) as minDays FROM FILE F
		 JOIN date D on D.lastAccess = 1 and DATEDIFF(NOW(), F.lastAccessedTSD) <= D.days
		GROUP BY F.name, F.folder, F.lastAccessedTSD;
-- 21:25:18	DROP TABLE IF EXISTS fileDataWithMinDaysReference
-- 21:25:18	CREATE TABLE fileDataWithMinDaysReference AS  SELECT F.name, F.folder, F.lastAccessedTSD, DATEDIFF(NOW(), F.lastAccessedTSD) as differenceToToday, min(innerD.days) as minDays   FROM FILE F   LEFT JOIN date innerD on innerD.lastAccess = 1 and DATEDIFF(NOW(), F.lastAccessedTSD) <= innerD.days   GROUP BY F.name, F.folder, F.lastAccessedTSD	
-- 456129 row(s) affected - Records: 456129  Duplicates: 0  Warnings: 0
--       duration drop table / duration table creation
-- run 1           0.016 sec / 25.953 sec
-- run 2           0.015 sec / 26.297 sec

DROP TABLE IF EXISTS xx_date_analyse;
CREATE TABLE xx_date_analyse as
-- EXPLAIN
SELECT filedata.folder, filedata.name, filedata.lastAccessedTSD, fileData.differenceToToday, D.days as 'treshhold days', RB.recommendedAction, RB.ratio, RB.weight from date D
 JOIN fileDataWithMinDaysReference fileData on D.days = fileData.minDays and D.lastAccess = 1
 JOIN ratiobasis rb on D.ratiobasisId = rb.ID 
;-- GROUP BY fileData.name, fileData.folder, fileData.lastAccessedTSD, fileData.differenceToToday, D.ratiobasisId, D.days
-- ORDER BY differenceToToday desc, ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction, filedata.folder, filedata.name;
-- 21:30:17	SELECT filedata.folder, filedata.name, filedata.lastAccessedTSD, fileData.differenceToToday, D.days as 'treshhold days', RB.recommendedAction, RB.ratio, RB.weight from date D JOIN fileDataWithMinDaysReference fileData on D.days = minDays and D.lastAccess = 1 LEFT JOIN ratiobasis rb on D.ratiobasisId = rb.ID  GROUP BY fileData.name, fileData.folder, fileData.lastAccessedTSD, fileData.differenceToToday, D.ratiobasisId, D.days ORDER BY differenceToToday desc, ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction, filedata.folder, filedata.name
-- 457100 row(s) returned
--       duration  / fetched
-- run 1 10.094 sec / 3.578 sec
-- run 2 9.953 sec / 3.594 sec
-- after db indexing
-- 457100 row(s) returned
--       duration  / fetched
-- run 1 15.922 sec / 3.531 sec
-- run 2 14.609 sec / 3.578 sec
-- ! seems even to be worse

select * from xx_date_analyse;

set profiling = 0;
show profiles;

-- CREATE INDEX `ix_filename_folder` on file(`name`, `folder` ASC);
-- CREATE INDEX IX_FILE_NAME ON FILE(name);
-- CREATE INDEX IX_FILE_FILETYPE ON FILE(filetype);
-- CREATE INDEX IX_FILE_SIZEINBYTES ON FILE(sizeInBytes);
-- CREATE INDEX IX_DATE_DAYS ON DATE(days);
-- CREATE INDEX IX_FOLDER_NAME ON FOLDER(name);
-- CREATE INDEX IX_FILETYPE_FILEENDING ON FILETYPE(fileending);
-- CREATE INDEX IX_SIZE_SIZEINBYTES ON SIZE(sizeInBytes);
-- CREATE INDEX IX_filedatawithmindaysreference_MINDAYS ON filedatawithmindaysreference(minDays);

-- DROP INDEX IX_FILENAME_FOLDER ON file;
-- DROP INDEX IX_FILE_NAME ON file;
-- DROP INDEX IX_FILE_FILETYPE ON file;
-- DROP INDEX IX_FILE_SIZEINBYTES ON file;
-- DROP INDEX IX_DATE_DAYS ON date;
-- DROP INDEX IX_FOLDER_NAME ON folder;
-- DROP INDEX IX_FILETYPE_FILEENDING ON filetype;
-- DROP INDEX IX_SIZE_SIZEINBYTES ON SIZE;
-- DROP INDEX IX_filedatawithmindaysreference_MINDAYS ON filedatawithmindaysreference;
-- DROP INDEX IX_RATIOS ON RATIOBASIS;

-- CREATE UNIQUE INDEX IX_RATIOS ON RATIOBASIS(ratio, weight, recommendedAction);
