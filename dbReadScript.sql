-- Ziel: finde ratios für folders
-- FOLDERNAME
-- EXPLAIN
SELECT F.path, RB.recommendedAction, RB.ratio, RB.weight FROM FOLDER F
	LEFT JOIN FOLDERNAME FN ON FN.name = F.name
	LEFT JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;
-- duration / fetch
-- 20:13:55	SELECT F.path, RB.recommendedAction, RB.ratio, RB.weight FROM FOLDER F  LEFT JOIN FOLDERNAME FN ON FN.name = F.name  LEFT JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID  ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction
-- 124270 row(s) returned
--       duration  / fetched
-- run 1 0.875 sec / 0.234 sec
-- run 2 0.797 sec / 0.234 sec
-- after db adaption for file.folder
-- 124270 row(s) returned
-- run 1 0.907 sec / 0.218 sec
-- run 2 0.859 sec / 0.219 sec
-- after db indexing
-- 124270 row(s) returned
-- run 1 0.860 sec / 0.203 sec
-- run 2 0.828 sec / 0.203 sec

-- Ziel: finde ratios für 1 file
-- FILENAME
-- EXPLAIN 
SELECT F.name, FO.path, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	LEFT JOIN FILENAME FN ON F.name = FN.name
	LEFT JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
    LEFT JOIN FOLDER FO ON F.folderID = FO.ID
	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;
-- 20:15:23	SELECT F.name, FO.path, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F  LEFT JOIN FILENAME FN ON F.name = FN.name  LEFT JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID     LEFT JOIN FOLDER FO ON F.folderID = FO.ID  ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction
-- 483802 row(s) returned
--       duration  / fetched
-- run 1 3.562 sec / 0.766 sec
-- run 2 3.656 sec / 0.813 sec

-- optimization: using redundancy on file path variable
-- EXPLAIN 
SELECT F.name, F.folder, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	LEFT JOIN FILENAME FN ON F.name = FN.name
	LEFT JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;
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

-- FOLDERNAME
-- EXPLAIN 
SELECT F.name, FO.path, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	LEFT JOIN FOLDER FO ON F.folderID = FO.ID
	LEFT JOIN FOLDERNAME FN ON FN.name = FO.name
	LEFT JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;
-- 20:16:40	SELECT F.name, FO.path, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F  LEFT JOIN FOLDER FO ON F.folderID = FO.ID  LEFT JOIN FOLDERNAME FN ON FN.name = FO.name  LEFT JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID  ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction
-- 483802 row(s) returned
--       duration  / fetched
-- run 1 3.656 sec / 0.765 sec
-- run 2 3.875 sec / 0.750 sec

-- optimization: using redundancy on file path variable
-- EXPLAIN 
SELECT F.name, F.folder, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	LEFT JOIN FOLDER FO ON F.folderID = FO.ID
	LEFT JOIN FOLDERNAME FN ON FN.name = FO.name
	LEFT JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;
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

-- FILETYPE
-- EXPLAIN
SELECT F.name, FO.path, F.filetype, FT.fileending as 'IDENTIFIED FILEENDING',  RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	LEFT JOIN FILETYPE FT ON F.filetype = FT.fileending
	LEFT JOIN RATIOBASIS RB ON FT.ratiobasisID = RB.ID
    LEFT JOIN FOLDER FO ON F.folderID = FO.ID
	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;
-- 20:17:51	SELECT F.name, FO.path, F.filetype, FT.fileending as 'IDENTIFIED FILEENDING',  RB.recommendedAction, RB.ratio, RB.weight FROM FILE F  LEFT JOIN FILETYPE FT ON F.filetype = FT.fileending  LEFT JOIN RATIOBASIS RB ON FT.ratiobasisID = RB.ID     LEFT JOIN FOLDER FO ON F.folderID = FO.ID  ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction
-- 483802 row(s) returned
--       duration  / fetched
-- run 1 2.125 sec / 0.750 sec
-- run 2 2.203 sec / 0.766 sec

-- optimization: using redundancy on file path variable
-- EXPLAIN
SELECT F.name, F.folder, F.filetype, FT.fileending as 'IDENTIFIED FILEENDING',  RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	LEFT JOIN FILETYPE FT ON F.filetype = FT.fileending
	LEFT JOIN RATIOBASIS RB ON FT.ratiobasisID = RB.ID
	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;
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

-- SIZE
-- EXPLAIN
SELECT F.name, FO.path, F.sizeInBytes, F.sizeAsString, 
       S.sizeInBytes as 'treshhold sizeInBytes',
       S.sizeAsString as 'treshhold sizeAsString',
       RB.recommendedAction, RB.ratio, RB.weight
       FROM FILE F
LEFT JOIN FOLDER FO ON F.folderID = FO.ID
LEFT JOIN SIZE S ON F.sizeInBytes <= S.sizeInBytes
LEFT JOIN RATIOBASIS RB ON S.ratiobasisID = RB.ID
GROUP BY F.name, FO.path, F.sizeInBytes, F.sizeAsString
		 HAVING min(S.sizeInBytes) = S.sizeInBytes
ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc,
		 recommendedAction, F.sizeInBytes desc;


-- 20:19:11	SELECT F.name, FO.path, F.sizeInBytes, F.sizeAsString, S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString', RB.recommendedAction, RB.ratio, RB.weight  FROM FILE F  LEFT JOIN FOLDER FO ON F.folderID = FO.ID  LEFT JOIN SIZE S ON F.sizeInBytes <= S.sizeInBytes  LEFT JOIN RATIOBASIS RB ON S.ratiobasisID = RB.ID     GROUP BY F.name, FO.path, F.sizeInBytes, F.sizeAsString     Having min(S.sizeInBytes) = S.sizeInBytes  ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction, F.sizeInBytes desc
-- 410108 row(s) returned
--       duration  / fetched
-- run 1 51.000 sec / 1.015 sec
-- run 2 48.750 sec / 1.078 sec

-- optimization: using redundancy on file path variable
-- EXPLAIN
SELECT F.name, F.folder, F.sizeInBytes, F.sizeAsString, S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString', RB.recommendedAction, RB.ratio, RB.weight
 FROM FILE F
	LEFT JOIN SIZE S ON F.sizeInBytes <= S.sizeInBytes
	LEFT JOIN RATIOBASIS RB ON S.ratiobasisID = RB.ID
    GROUP BY F.name, F.folder, F.sizeInBytes, F.sizeAsString
    Having min(S.sizeInBytes) = S.sizeInBytes
	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction, F.sizeInBytes desc;
-- 25:58:58 SELECT F.name, F.folder, F.sizeInBytes, F.sizeAsString, S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString', RB.recommendedAction, RB.ratio, RB.weight  FROM FILE F  LEFT JOIN SIZE S ON F.sizeInBytes <= S.sizeInBytes  LEFT JOIN RATIOBASIS RB ON S.ratiobasisID = RB.ID     GROUP BY F.name, F.folder, F.sizeInBytes, F.sizeAsString     Having min(S.sizeInBytes) = S.sizeInBytes  ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction, F.sizeInBytes desc
-- 458733 row(s) returned
--       duration  / fetched
-- run 1 19.656 sec / 1.172 sec
-- run 2 19.250 sec / 1.187 sec
-- after db indexing
-- 458733 row(s) returned
--       duration  / fetched
-- run 1 27.516 sec / 1.203 sec
-- run 2 24.313 sec / 1.203 sec
-- ! seems even to be worse

-- TODO: extract explain statements again for optimization round 3 - after db indexing

-- DATE - last accessed (first without checking fileloccation)
-- EXPLAIN
SELECT filedata.folder, filedata.name, filedata.lastAccessedTSD, fileData.differenceToToday, D.days as 'treshhold days', RB.recommendedAction, RB.ratio, RB.weight from date D
JOIN (
	SELECT F.name, F.folder, F.lastAccessedTSD, DATEDIFF(NOW(), F.lastAccessedTSD) as differenceToToday, min(innerD.days) as minDays
		FROM FILE F
		LEFT JOIN date innerD on innerD.lastAccess = 1 and DATEDIFF(NOW(), F.lastAccessedTSD) <= innerD.days
		GROUP BY F.name, F.folder, F.lastAccessedTSD
    ) fileData on D.days = minDays and D.lastAccess = 1
LEFT JOIN ratiobasis rb on D.ratiobasisId = rb.ID 
GROUP BY fileData.name, fileData.folder, fileData.lastAccessedTSD, fileData.differenceToToday, D.ratiobasisId, D.days
ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction, filedata.folder, filedata.name;
-- 20:22:00	SELECT filedata.path, filedata.name, filedata.lastAccessedTSD, fileData.differenceToToday, D.days as 'treshhold days', RB.recommendedAction, RB.ratio, RB.weight from date D JOIN (  SELECT F.name, FO.path, F.lastAccessedTSD, DATEDIFF(NOW(), F.lastAccessedTSD) as differenceToToday, min(innerD.days) as minDays   FROM FILE F   LEFT JOIN FOLDER FO ON F.folderID = FO.ID   LEFT JOIN date innerD on innerD.lastAccess = 1 and DATEDIFF(NOW(), F.lastAccessedTSD) <= innerD.days   GROUP BY F.name, FO.path, F.lastAccessedTSD     ) fileData on D.days = minDays and D.lastAccess = 1 LEFT JOIN ratiobasis rb on D.ratiobasisId = rb.ID  GROUP BY fileData.name, fileData.path, fileData.lastAccessedTSD, fileData.differenceToToday, D.ratiobasisId, D.days ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction, filedata.path, filedata.name
-- 389888 row(s) returned
--       duration  / fetched
-- run 1 77.469 sec / 3.187 sec
-- run 2 75.359 sec / 3.125 sec

-- optimization: using redundancy on file path variable
-- EXPLAIN

SELECT filedata.folder, filedata.name, filedata.lastAccessedTSD, 
       fileData.differenceToToday, D.days as 'treshhold days', 
       RB.recommendedAction, RB.ratio, RB.weight 
       from date D
JOIN (
		SELECT F.name, F.folder, F.lastAccessedTSD,
			   DATEDIFF(NOW(), F.lastAccessedTSD) as differenceToToday,
			   min(innerD.days) as minDays
			   FROM FILE F
		LEFT JOIN date innerD on innerD.lastAccess = 1 
					and DATEDIFF(NOW(), F.lastAccessedTSD) <= innerD.days
		GROUP BY F.name, F.folder, F.lastAccessedTSD
	) fileData on D.days = minDays and D.lastAccess = 1
LEFT JOIN ratiobasis rb on D.ratiobasisId = rb.ID 
GROUP BY fileData.name, fileData.folder, fileData.lastAccessedTSD, 
		 fileData.differenceToToday, D.ratiobasisId, D.days
ORDER BY differenceToToday desc, ISNULL(RB.ratio), RB.ratio desc, 
		 RB.weight desc, recommendedAction, filedata.folder, filedata.name;
         
         
         
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
		LEFT JOIN date D on D.lastAccess = 1 and DATEDIFF(NOW(), F.lastAccessedTSD) <= D.days
		GROUP BY F.name, F.folder, F.lastAccessedTSD;
-- 21:25:18	DROP TABLE IF EXISTS fileDataWithMinDaysReference
-- 21:25:18	CREATE TABLE fileDataWithMinDaysReference AS  SELECT F.name, F.folder, F.lastAccessedTSD, DATEDIFF(NOW(), F.lastAccessedTSD) as differenceToToday, min(innerD.days) as minDays   FROM FILE F   LEFT JOIN date innerD on innerD.lastAccess = 1 and DATEDIFF(NOW(), F.lastAccessedTSD) <= innerD.days   GROUP BY F.name, F.folder, F.lastAccessedTSD	
-- 456129 row(s) affected - Records: 456129  Duplicates: 0  Warnings: 0
--       duration drop table / duration table creation
-- run 1           0.016 sec / 25.953 sec
-- run 2           0.015 sec / 26.297 sec

-- EXPLAIN
SELECT filedata.folder, filedata.name, filedata.lastAccessedTSD, fileData.differenceToToday, D.days as 'treshhold days', RB.recommendedAction, RB.ratio, RB.weight from date D
JOIN fileDataWithMinDaysReference fileData on D.days = fileData.minDays and D.lastAccess = 1
LEFT JOIN ratiobasis rb on D.ratiobasisId = rb.ID 
GROUP BY fileData.name, fileData.folder, fileData.lastAccessedTSD, fileData.differenceToToday, D.ratiobasisId, D.days
ORDER BY differenceToToday desc, ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction, filedata.folder, filedata.name;
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
