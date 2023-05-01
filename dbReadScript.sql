-- Ziel: finde ratios für folders
-- FOLDERNAME
SELECT F.path, RB.recommendedAction, RB.ratio, RB.weight FROM FOLDER F
	LEFT JOIN FOLDERNAME FN ON FN.name = F.name
	LEFT JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;

-- Ziel: finde ratios für 1 file
-- FILENAME
SELECT F.name, FO.path, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	LEFT JOIN FILENAME FN ON F.name = FN.name
	LEFT JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
    LEFT JOIN FOLDER FO ON F.id = F.folderID
	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;

-- FOLDERNAME
SELECT F.name, FO.path, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	LEFT JOIN FOLDER FO ON F.folderID = FO.ID
	LEFT JOIN FOLDERNAME FN ON FN.name = FO.name
	LEFT JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;
    
-- FILETYPE
SELECT * FROM FILE F
	LEFT JOIN FILETYPE FT ON F.filetype = FT.fileending
	LEFT JOIN RATIOBASIS RB ON FT.ratiobasisID = RB.ID
	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;

-- SIZE
SELECT F.name, FO.path, F.sizeInBytes, F.sizeAsString, S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString', RB.recommendedAction, RB.ratio, RB.weight
 FROM FILE F
	LEFT JOIN FOLDER FO ON F.folderID = FO.ID
	LEFT JOIN SIZE S ON F.sizeInBytes <= S.sizeInBytes
	LEFT JOIN RATIOBASIS RB ON S.ratiobasisID = RB.ID
    GROUP BY F.name, FO.path, F.sizeInBytes, F.sizeAsString
    Having min(S.sizeInBytes) = S.sizeInBytes
	ORDER BY F.sizeInBytes desc, ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;
    
-- date - last accessed (first without checking any files
SELECT F.name, FO.path, F.lastAccessedTSD, D.days 'treshhold days', D.type, RB.recommendedAction, RB.ratio, RB.weight
 FROM FILE F
	LEFT JOIN FOLDER FO ON F.folderID = FO.ID
	JOIN DATE D ON 1 = D.lastAccess AND D.days >= (CURRENT_DATE() - F.lastAccessedTSD)
	LEFT JOIN RATIOBASIS RB ON D.ratiobasisID = RB.ID
    GROUP BY F.name, FO.path, F.lastAccessedTSD
    Having min(D.days)
	ORDER BY ISNULL(RB.ratio), RB.ratio desc, RB.weight desc, recommendedAction;