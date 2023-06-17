SET PROFILING = 1;
-- CALL DROP_INDEX_IF_EXISTS('folder', 'ix_folder_name');
CALL DROP_INDEX_IF_EXISTS('folder', 'idx_folder_path');
CALL DROP_INDEX_IF_EXISTS('file', 'idx_file_name');
CALL DROP_INDEX_IF_EXISTS('file', 'idx_file_filetype');
-- CALL DROP_INDEX_IF_EXISTS('file', 'idx_file_sizeInBytes');

LOAD DATA INFILE '../data/DBS_folder_analysis_driveD_neu.csv' INTO TABLE folder
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@lastModifiedTSD, path, name, @parentFolderID, ID)
SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),
	parentFolderID = nullIf(@parentFolderID, '')
;

LOAD DATA INFILE '../data/DBS_file_analysis_driveD_neu.csv' INTO TABLE file
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@lastModifiedTSD, @sizeInBytes, @lastAccessedTSD, name, filetype, folderID, @folder, sizeAsString, @creationTSD)
SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),
	sizeInBytes = 	(case
						when @sizeInBytes >= 0 then @sizeInBytes
                            -- todo: fix this, could also be relevant for certain positive sizeInBytes values, e.g. for size 5 GB
						else 2147483647 + (2147483648 + @sizeInBytes)
							-- todo: fix this, can even be multiple times, e.g. 7.4 mg --> 3 times, check with human readable size
					end),
	lastAccessedTSD = STR_TO_DATE(@lastAccessedTSD, '%d.%m.%Y %H:%i:%s'),
    creationTSD = STR_TO_DATE(@creationTSD, '%d.%m.%Y %H:%i:%s'),
    folder = (SELECT path FROM folder WHERE id = folderID)
;

LOAD DATA INFILE '../data/DBS_folder_analysis_driveC_neu.csv' INTO TABLE folder
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@lastModifiedTSD, path, name, @parentFolderID, ID)
SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),
	parentFolderID = nullIf(@parentFolderID, '')
;

LOAD DATA INFILE '../data/DBS_file_analysis_driveC_neu.csv' INTO TABLE file
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@lastModifiedTSD, @sizeInBytes, @lastAccessedTSD, name, filetype, folderID, @folder, sizeAsString, @creationTSD)
SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),
	sizeInBytes = 	(case
						when @sizeInBytes >= 0 then @sizeInBytes
                            -- todo: fix this, could also be relevant for certain positive sizeInBytes values, e.g. for size 5 GB
						else 2147483647 + (2147483648 + @sizeInBytes)
							-- todo: fix this, can even be multiple times, e.g. 7.4 mg --> 3 times, check with human readable size
					end),
	lastAccessedTSD = STR_TO_DATE(@lastAccessedTSD, '%d.%m.%Y %H:%i:%s'),
    creationTSD = STR_TO_DATE(@creationTSD, '%d.%m.%Y %H:%i:%s'),
    folder = (SELECT path FROM folder WHERE id = folderID)
;

-- CREATE INDEX ix_folder_name on folder(name ASC);
CREATE INDEX idx_folder_path on folder(path ASC);
CREATE INDEX idx_file_name on file(name ASC);
CREATE INDEX idx_file_filetype on file(filetype ASC);
-- CREATE INDEX idx_file_sizeInBytes on file(sizeInBytes ASC);

COMMIT;
SET PROFILING = 0;
SHOW PROFILES;