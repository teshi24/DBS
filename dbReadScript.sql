USE `fsc`;
set profiling = 1;

-- möglichst einschränken 
-- > erst ganz am schluss left join auf die Files wos nötig ist --> done
-- Funktionen im Where und Order by sparsam
-- zwischentabellen brauchen keine sortierung, eigenentlich nur am schluss --> done

-- Ziel: finde ratios für folders
-- FOLDERNAME
-- EXPLAIN
SELECT F.id, F.path, FN.ratiobasisID FROM FOLDER F
	JOIN FOLDERNAME FN ON FN.name = F.name;

-- Ziel: finde ratios für 1 file (filename)
-- FILENAME
-- EXPLAIN 
SELECT F.id, F.name, F.folder, FN.ratiobasisID FROM FILE F
	JOIN FILENAME FN ON F.name = FN.name;

-- Ziel: finde ratios für 1 file (foldername)
-- FOLDERNAME
-- EXPLAIN
SELECT F.id, F.name, F.folder, FN.ratiobasisID FROM FILE F
	JOIN FOLDER FO ON F.folderID = FO.ID
	JOIN FOLDERNAME FN ON FN.name = FO.name;

-- Ziel: finde ratios für 1 file (filetype)    
-- FILETYPE
-- EXPLAIN
SELECT F.id, F.name, F.folder, F.filetype, FT.fileending as 'IDENTIFIED FILEENDING',  FT.ratiobasisID FROM FILE F
	JOIN FILETYPE FT ON F.filetype = FT.fileending;

-- Ziel: finde ratios für 1 file (size)
-- SIZE
DROP TABLE IF EXISTS fileDataWithMinSizeReference;
CREATE TABLE fileDataWithMinSizeReference AS 
-- explain
SELECT F.id, F.name, F.folder, F.sizeInBytes, F.sizeAsString, S.sizeInBytes as minSizeInBytes
 FROM FILE F
	JOIN SIZE S ON F.sizeInBytes <= S.sizeInBytes
    GROUP BY F.id
    Having min(S.sizeInBytes) = S.sizeInBytes;
-- having mit funktionen - ist performance engpass, analog zum where --> todo: minimums agreggieren

-- created index for improving performance
create index ix_fileDataWithMinSizeReference_minSizeInBytes on fileDataWithMinSizeReference(minSizeInBytes asc);

-- EXPLAIN
SELECT filedata.id, filedata.name, filedata.folder, filedata.sizeInBytes, filedata.sizeAsString, S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString', S.ratiobasisID
	FROM size s
	JOIN fileDataWithMinSizeReference filedata ON filedata.minSizeInBytes = S.sizeInBytes;

-- Ziel: finde ratios für 1 file (last accessed)
-- DATE - last accessed (first without checking fileloccation)
DROP TABLE IF EXISTS fileDataWithMinDaysReference;
CREATE TABLE fileDataWithMinDaysReference AS 
-- explain
SELECT F.id, F.name, F.folder, F.lastAccessedTSD, DATEDIFF(NOW(), F.lastAccessedTSD) as differenceToToday, min(D.days) as minDays FROM FILE F
		JOIN date D on D.lastAccess = 1 and DATEDIFF(NOW(), F.lastAccessedTSD) <= D.days
		GROUP BY F.id;
                -- todo: hier datediff anders berechnen um index zu nutzen
-- created index for improving performance
create index ix_fileDataWithMinDaysReference_minDays on fileDataWithMinDaysReference(minDays asc);

-- EXPLAIN
SELECT filedata.id, filedata.folder, filedata.name, filedata.lastAccessedTSD, fileData.differenceToToday, D.days as 'treshhold days', D.ratiobasisId
	from date D
	JOIN fileDataWithMinDaysReference fileData on D.days = fileData.minDays and D.lastAccess = 1
	GROUP BY fileData.id, D.ratiobasisId, D.days -- todo: remove as probably not necessary, sice it is already "grouped" in filedata with reference
	;

show profiles;
 -- show profile for query 1;
set profiling = 0;
