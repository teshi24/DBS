-- Ziel: finde ratios für folders
-- FOLDERNAME
-- EXPLAIN
SELECT F.path, RB.recommendedAction, RB.ratio, RB.weight FROM FOLDER F
	LEFT JOIN FOLDERNAME FN ON FN.name = F.name
	LEFT JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;
-- duration / fetch
-- 0.032 sec / 0.000 sec
-- 0.015 sec / 0.032 sec

-- Ziel: finde ratios für 1 file
-- FILENAME
-- EXPLAIN 
SELECT F.name, FO.path, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	LEFT JOIN FILENAME FN ON F.name = FN.name
	LEFT JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
    LEFT JOIN FOLDER FO ON F.folderID = FO.ID
	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;
-- 136.047 sec / 0.140 sec


-- FOLDERNAME
-- EXPLAIN 
SELECT F.name, FO.path, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	LEFT JOIN FOLDER FO ON F.folderID = FO.ID
	LEFT JOIN FOLDERNAME FN ON FN.name = FO.name
	LEFT JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;
-- 0.922 sec / 0.188 sec
    
-- FILETYPE
-- EXPLAIN
SELECT F.name, FO.path, F.filetype, FT.fileending as 'IDENTIFIED FILEENDING',  RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	LEFT JOIN FILETYPE FT ON F.filetype = FT.fileending
	LEFT JOIN RATIOBASIS RB ON FT.ratiobasisID = RB.ID
    LEFT JOIN FOLDER FO ON F.folderID = FO.ID
	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;
-- 0.985 sec / 0.406 sec

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
-- 11.063 sec / 0.344 sec

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
-- 12.672 sec / 0.312 sec
