set profiling = 1;
call drop_index_if_exists('folder', 'ix_folder_name');
call drop_index_if_exists('file', 'ix_file_name');
call drop_index_if_exists('file', 'ix_file_filetype');
call drop_index_if_exists('file', 'ix_file_sizeInBytes');

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

create index ix_folder_name on folder(name asc);
create index ix_file_name on file(name asc);
create index ix_file_filetype on file(filetype asc);
create index ix_file_sizeInBytes on file(sizeInBytes asc);

set profiling = 0;
show profiles;