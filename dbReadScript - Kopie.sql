 set profiling = 1;
-- CREATE UNIQUE INDEX IX_RATIOS ON RATIOBASIS(ratio, weight, recommendedAction);
-- DROP INDEX IX_RATIOS ON RATIOBASIS;
-- CREATE INDEX IX_RATIOBASIS_RATIO ON RATIOBASIS(ratio);
-- CREATE INDEX IX_RATIOBASIS_weight ON RATIOBASIS(weight);
-- CREATE INDEX IX_RATIOBASIS_recommendedAction ON RATIOBASIS(recommendedAction);
-- removed order by recommended Action and therefore removed index again
-- drop index IX_RATIOBASIS_recommendedAction on ratiobasis;
-- not gotten better, removed ratio basis indizes again
-- drop index IX_RATIOBASIS_weight on ratiobasis;
-- changed ISNULL(RB.ratio), RB.ratio desc to isnull(RB.ratio) asc

-- CREATE INDEX IX_FILE_FILENAME ON FILE (name, folder, lastAccessedTSD);
-- not gotten better, removed FILE indizes again
-- drop index IX_FILE_FILENAME on FILE;
-- CREATE INDEX IX_FILE_NAME ON FILE (name);
-- CREATE INDEX IX_FILE_lastAccessedTSD ON FILE (lastAccessedTSD);
-- CREATE INDEX IX_FILE_folder ON FILE (folder);
-- CREATE INDEX IX_size_sizeInBytes on SIZE (sizeInBytes);
-- CREATE INDEX IX_file_sizeInBytes on file (sizeInBytes);
-- removed again, made it worse
-- drop index IX_size_sizeInBytes on SIZE;
-- drop index IX_file_sizeInBytes on file;

-- Ziel: finde ratios für folders
-- FOLDERNAME
-- EXPLAIN
SELECT F.path, RB.recommendedAction, RB.ratio, RB.weight FROM FOLDER F
	LEFT JOIN FOLDERNAME FN ON FN.name = F.name
	LEFT JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
	ORDER BY ISNULL(RB.ratio) asc, RB.weight desc;

-- Ziel: finde ratios für 1 file
-- FILENAME
-- optimization: using redundancy on file path variable
-- EXPLAIN 
SELECT F.name, F.folder, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	LEFT JOIN FILENAME FN ON F.name = FN.name
	LEFT JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
	ORDER BY ISNULL(RB.ratio) asc, RB.weight desc;

-- FOLDERNAME
-- optimization: using redundancy on file path variable
-- EXPLAIN 
SELECT F.name, F.folder, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	LEFT JOIN FOLDER FO ON F.folderID = FO.ID
	LEFT JOIN FOLDERNAME FN ON FN.name = FO.name
	LEFT JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
	ORDER BY ISNULL(RB.ratio) asc, RB.weight desc;

-- FILETYPE
-- optimization: using redundancy on file path variable
-- EXPLAIN
SELECT F.name, F.folder, F.filetype, FT.fileending as 'IDENTIFIED FILEENDING',  RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	LEFT JOIN FILETYPE FT ON F.filetype = FT.fileending
	LEFT JOIN RATIOBASIS RB ON FT.ratiobasisID = RB.ID
	ORDER BY ISNULL(RB.ratio) asc, RB.weight desc;

-- SIZE
-- optimization: using redundancy on file path variable
-- EXPLAIN
-- SELECT F.name, F.folder, F.sizeInBytes, F.sizeAsString, S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString', RB.recommendedAction, RB.ratio, RB.weight
--  FROM FILE F
-- 	LEFT JOIN SIZE S ON F.sizeInBytes <= S.sizeInBytes
-- 	LEFT JOIN RATIOBASIS RB ON S.ratiobasisID = RB.ID
--     GROUP BY F.name, F.folder, F.sizeInBytes, F.sizeAsString
--     Having min(S.sizeInBytes) = S.sizeInBytes
-- 	   ORDER BY ISNULL(RB.ratio) asc, RB.weight desc, F.sizeInBytes desc;
    
-- further improvement with different table
DROP TABLE IF EXISTS fileDataWithMinSizeReference;
CREATE TABLE fileDataWithMinSizeReference AS 
-- ; explain
SELECT F.name, F.folder, F.sizeInBytes, F.sizeAsString, S.sizeInBytes as minSizeInBytes
 FROM FILE F
	LEFT JOIN SIZE S ON F.sizeInBytes <= S.sizeInBytes
    GROUP BY F.name, F.folder, F.sizeInBytes, F.sizeAsString
    Having min(S.sizeInBytes) = S.sizeInBytes;
-- created index for improving performance
-- CREATE INDEX ix_fileDataWithMinSizeReference_sizeInBytes on  fileDataWithMinSizeReference(sizeInBytes);
CREATE INDEX ix_fileDataWithMinSizeReference_minSizeInBytes on  fileDataWithMinSizeReference(minSizeInBytes);

-- explain
SELECT filedata.name, filedata.folder, filedata.sizeInBytes, filedata.sizeAsString, S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString', RB.recommendedAction, RB.ratio, RB.weight
	FROM size s
	JOIN fileDataWithMinSizeReference filedata ON filedata.minSizeInBytes = S.sizeInBytes
	LEFT JOIN RATIOBASIS RB ON S.ratiobasisID = RB.ID
	ORDER BY ISNULL(RB.ratio) asc, RB.weight desc, filedata.sizeInBytes desc;

-- DATE - last accessed (first without checking fileloccation)
-- optimization: using materalized table
DROP TABLE IF EXISTS fileDataWithMinDaysReference;
CREATE TABLE fileDataWithMinDaysReference AS 
-- ; explain
SELECT F.name, F.folder, F.lastAccessedTSD, DATEDIFF(NOW(), F.lastAccessedTSD) as differenceToToday, min(D.days) as minDays FROM FILE F
		LEFT JOIN date D on D.lastAccess = 1 and DATEDIFF(NOW(), F.lastAccessedTSD) <= D.days
		GROUP BY F.name, F.folder, F.lastAccessedTSD;
-- created index for improving performance
CREATE INDEX ix_filedata_minDays on  fileDataWithMinDaysReference(minDays);

-- EXPLAIN 
SELECT filedata.folder, filedata.name, filedata.lastAccessedTSD, fileData.differenceToToday, D.days as 'treshhold days', RB.recommendedAction, RB.ratio, RB.weight
from date D
JOIN fileDataWithMinDaysReference fileData on D.days = fileData.minDays and D.lastAccess = 1
LEFT JOIN ratiobasis rb on D.ratiobasisId = rb.ID 
-- GROUP BY fileData.name, fileData.folder, fileData.lastAccessedTSD, fileData.differenceToToday, D.ratiobasisId, D.days -- not necessary, sice it is already "grouped" in filedata with reference
ORDER BY differenceToToday desc, ISNULL(RB.ratio) asc, RB.weight desc, filedata.folder, filedata.name;

show profiles;
 -- show profile for query 1;
 -- show profile for query 2;
 -- show profile for query 3;
 -- show profile for query 4;
 -- show profile for query 5;
 -- show profile for query 6;
 -- show profile for query 7;
 -- show profile for query 8;
 -- show profile for query 9;
 
 set profiling = 0;