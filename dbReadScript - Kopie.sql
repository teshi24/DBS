USE `fsc`;
set profiling = 1;

-- möglichst einschränken 
-- > erst ganz am schluss left join auf die Files wos nötig ist --> done
-- Funktionen im Where und Order by sparsam
-- zwischentabellen brauchen keine sortierung, eigenentlich nur am schluss --> done

-- create index ix_folder_name on folder(name asc);
-- create index ix_file_name on file(name asc);
-- create index ix_file_filetype on file(filetype asc);
-- create index ix_filetype_fileending on filetype(fileending asc);
-- todo: maybe add this when queries are corrected -- create index ix_size_sizeInBytes on size(sizeInBytes asc);

-- create index ix_date_lastAccessNDays on date(lastAccess asc, days asc);
-- todo: maybe add this when queries are corrected -- create index ix_date_lastAccess on date(lastAccess asc);
-- todo: maybe add this when queries are corrected -- create index ix_date_days on date(days asc);
-- todo: check difference for 7 - if no difference, remove single items

-- Ziel: finde ratios für folders
-- FOLDERNAME
--  EXPLAIN
-- SELECT F.path, RB.recommendedAction, RB.ratio, RB.weight FROM FOLDER F
	-- JOIN FOLDERNAME FN ON FN.name = F.name
	-- JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
	-- ; -- ORDER BY ISNULL(RB.ratio) asc, RB.weight desc;
-- optimization: save FKs and relevant data only
-- EXPLAIN
SELECT F.id, F.path, FN.ratiobasisID FROM FOLDER F
	JOIN FOLDERNAME FN ON FN.name = F.name;

-- Ziel: finde ratios für 1 file
-- FILENAME
-- optimization: using redundancy on file path variable
-- EXPLAIN 
-- SELECT F.name, F.folder, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	-- JOIN FILENAME FN ON F.name = FN.name
	-- JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
	-- ; -- ORDER BY ISNULL(RB.ratio) asc, RB.weight desc;
-- optimization: save FKs and relevant data only
-- EXPLAIN 
SELECT F.id, F.name, F.folder, FN.ratiobasisID FROM FILE F
	JOIN FILENAME FN ON F.name = FN.name;

-- FOLDERNAME
-- optimization: using redundancy on file path variable
-- EXPLAIN 
-- SELECT F.name, F.folder, RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	-- JOIN FOLDER FO ON F.folderID = FO.ID
	-- JOIN FOLDERNAME FN ON FN.name = FO.name
	-- JOIN RATIOBASIS RB ON FN.ratiobasisID = RB.ID
	-- ; -- ORDER BY ISNULL(RB.ratio) asc, RB.weight desc;
-- optimization: save FKs and relevant data only
-- EXPLAIN
SELECT F.id, F.name, F.folder, FN.ratiobasisID FROM FILE F
	JOIN FOLDER FO ON F.folderID = FO.ID
	JOIN FOLDERNAME FN ON FN.name = FO.name;
    
-- FILETYPE
-- optimization: using redundancy on file path variable
-- EXPLAIN
-- SELECT F.name, F.folder, F.filetype, FT.fileending as 'IDENTIFIED FILEENDING',  RB.recommendedAction, RB.ratio, RB.weight FROM FILE F
	-- JOIN FILETYPE FT ON F.filetype = FT.fileending
	-- JOIN RATIOBASIS RB ON FT.ratiobasisID = RB.ID
	-- ; -- ORDER BY ISNULL(RB.ratio) asc, RB.weight desc;
-- optimization: save FKs and relevant data only
-- EXPLAIN
SELECT F.id, F.name, F.folder, F.filetype, FT.fileending as 'IDENTIFIED FILEENDING',  FT.ratiobasisID FROM FILE F
	JOIN FILETYPE FT ON F.filetype = FT.fileending;

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
        
-- having mit funktionen - ist performance engpass, analog zum where --> minimums agreggieren
    
-- further improvement with different table
DROP TABLE IF EXISTS fileDataWithMinSizeReference;
CREATE TABLE fileDataWithMinSizeReference AS 
-- explain
SELECT F.id, F.name, F.folder, F.sizeInBytes, F.sizeAsString, S.sizeInBytes as minSizeInBytes
 FROM FILE F
	JOIN SIZE S ON F.sizeInBytes <= S.sizeInBytes
    GROUP BY F.id
    Having min(S.sizeInBytes) = S.sizeInBytes;
-- created index for improving performance
create index ix_fileDataWithMinSizeReference_minSizeInBytes on fileDataWithMinSizeReference(minSizeInBytes asc);

--  explain
-- SELECT filedata.name, filedata.folder, filedata.sizeInBytes, filedata.sizeAsString, S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString', RB.recommendedAction, RB.ratio, RB.weight
	-- FROM size s
	-- JOIN fileDataWithMinSizeReference filedata ON filedata.minSizeInBytes = S.sizeInBytes
	-- JOIN RATIOBASIS RB ON S.ratiobasisID = RB.ID
	-- ; -- ORDER BY ISNULL(RB.ratio) asc, RB.weight desc, filedata.sizeInBytes desc;
-- optimization: save FKs and relevant data only
-- EXPLAIN
SELECT filedata.id, filedata.name, filedata.folder, filedata.sizeInBytes, filedata.sizeAsString, S.sizeInBytes as 'treshhold sizeInBytes', S.sizeAsString as 'treshhold sizeAsString', S.ratiobasisID
	FROM size s
	JOIN fileDataWithMinSizeReference filedata ON filedata.minSizeInBytes = S.sizeInBytes;

-- DATE - last accessed (first without checking fileloccation)
-- optimization: using materalized table
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
-- SELECT filedata.folder, filedata.name, filedata.lastAccessedTSD, fileData.differenceToToday, D.days as 'treshhold days', RB.recommendedAction, RB.ratio, RB.weight
   -- from date D
   -- JOIN fileDataWithMinDaysReference fileData on D.days = fileData.minDays and D.lastAccess = 1
   -- JOIN ratiobasis rb on D.ratiobasisId = rb.ID 
   -- GROUP BY fileData.name, fileData.folder, fileData.lastAccessedTSD, fileData.differenceToToday, D.ratiobasisId, D.days -- not necessary, sice it is already "grouped" in filedata with reference
   -- ; -- ORDER BY differenceToToday desc, ISNULL(RB.ratio) asc, RB.weight desc, filedata.name, filedata.folder;
-- optimization: save FKs and relevant data only
-- EXPLAIN
SELECT filedata.id, filedata.folder, filedata.name, filedata.lastAccessedTSD, fileData.differenceToToday, D.days as 'treshhold days', D.ratiobasisId
	from date D
	JOIN fileDataWithMinDaysReference fileData on D.days = fileData.minDays and D.lastAccess = 1
	GROUP BY fileData.id, D.ratiobasisId, D.days -- not necessary, sice it is already "grouped" in filedata with reference
	;
    
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
