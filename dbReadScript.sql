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

-- SIZE
-- EXPLAIN
SELECT F.name, FO.path, F.sizeInBytes, F.sizeAsString, S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString', RB.recommendedAction, RB.ratio, RB.weight
 FROM FILE F
	LEFT JOIN FOLDER FO ON F.folderID = FO.ID
	LEFT JOIN SIZE S ON F.sizeInBytes <= S.sizeInBytes
	LEFT JOIN RATIOBASIS RB ON S.ratiobasisID = RB.ID
    GROUP BY F.name, FO.path, F.sizeInBytes, F.sizeAsString
    Having min(S.sizeInBytes) = S.sizeInBytes
	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction, F.sizeInBytes desc;
-- 20:19:11	SELECT F.name, FO.path, F.sizeInBytes, F.sizeAsString, S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString', RB.recommendedAction, RB.ratio, RB.weight  FROM FILE F  LEFT JOIN FOLDER FO ON F.folderID = FO.ID  LEFT JOIN SIZE S ON F.sizeInBytes <= S.sizeInBytes  LEFT JOIN RATIOBASIS RB ON S.ratiobasisID = RB.ID     GROUP BY F.name, FO.path, F.sizeInBytes, F.sizeAsString     Having min(S.sizeInBytes) = S.sizeInBytes  ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction, F.sizeInBytes desc
-- 410108 row(s) returned
--       duration  / fetched
-- run 1 51.000 sec / 1.015 sec
-- run 2 48.750 sec / 1.078 sec

-- DATE - last accessed (first without checking fileloccation)
-- EXPLAIN
SELECT filedata.path, filedata.name, filedata.lastAccessedTSD, fileData.differenceToToday, D.days as 'treshhold days', RB.recommendedAction, RB.ratio, RB.weight from date D
JOIN (
	SELECT F.name, FO.path, F.lastAccessedTSD, DATEDIFF(NOW(), F.lastAccessedTSD) as differenceToToday, min(innerD.days) as minDays
		FROM FILE F
		LEFT JOIN FOLDER FO ON F.folderID = FO.ID
		LEFT JOIN date innerD on innerD.lastAccess = 1 and DATEDIFF(NOW(), F.lastAccessedTSD) <= innerD.days
		GROUP BY F.name, FO.path, F.lastAccessedTSD
    ) fileData on D.days = minDays and D.lastAccess = 1
LEFT JOIN ratiobasis rb on D.ratiobasisId = rb.ID 
GROUP BY fileData.name, fileData.path, fileData.lastAccessedTSD, fileData.differenceToToday, D.ratiobasisId, D.days
ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction, filedata.path, filedata.name;
-- 20:22:00	SELECT filedata.path, filedata.name, filedata.lastAccessedTSD, fileData.differenceToToday, D.days as 'treshhold days', RB.recommendedAction, RB.ratio, RB.weight from date D JOIN (  SELECT F.name, FO.path, F.lastAccessedTSD, DATEDIFF(NOW(), F.lastAccessedTSD) as differenceToToday, min(innerD.days) as minDays   FROM FILE F   LEFT JOIN FOLDER FO ON F.folderID = FO.ID   LEFT JOIN date innerD on innerD.lastAccess = 1 and DATEDIFF(NOW(), F.lastAccessedTSD) <= innerD.days   GROUP BY F.name, FO.path, F.lastAccessedTSD     ) fileData on D.days = minDays and D.lastAccess = 1 LEFT JOIN ratiobasis rb on D.ratiobasisId = rb.ID  GROUP BY fileData.name, fileData.path, fileData.lastAccessedTSD, fileData.differenceToToday, D.ratiobasisId, D.days ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction, filedata.path, filedata.name
-- 389888 row(s) returned
--       duration  / fetched
-- run 1 77.469 sec / 3.187 sec
-- run 2 75.359 sec / 3.125 sec

