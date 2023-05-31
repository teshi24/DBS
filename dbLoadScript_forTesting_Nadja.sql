call drop_index_if_exists('folder', 'ix_folder_name');
call drop_index_if_exists('file', 'ix_file_name');
call drop_index_if_exists('file', 'ix_file_filetype');

LOAD DATA INFILE '../data/DBS_folder_analysis_driveD.csv' INTO TABLE folder
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@lastModifiedTSD, path, name, @parentFolderID, ID)
SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),
	parentFolderID = nullIf(@parentFolderID, '')
;

LOAD DATA INFILE '../data/DBS_file_analysis_driveD.csv' INTO TABLE file
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@lastModifiedTSD, @sizeInBytes, @lastAccessedTSD, name, filetype, folderID, folder, sizeAsString, @creationTSD)
SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),
	sizeInBytes = 	(case
						when @sizeInBytes >= 0 then @sizeInBytes
						else 2147483647 + (2147483648 + @sizeInBytes) -- todo: fix this, can even be multiple times, e.g. 7.4 mg --> 3 times, check with human readable size
					end),
	lastAccessedTSD = STR_TO_DATE(@lastAccessedTSD, '%d.%m.%Y %H:%i:%s'),
    creationTSD = STR_TO_DATE(@creationTSD, '%d.%m.%Y %H:%i:%s')
;

LOAD DATA INFILE '../data/DBS_folder_analysis_driveC.csv' INTO TABLE folder
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@lastModifiedTSD, path, name, @parentFolderID, ID)
SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),
	parentFolderID = nullIf(@parentFolderID, '')
;

LOAD DATA INFILE '../data/DBS_file_analysis_driveC.csv' INTO TABLE file
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@lastModifiedTSD, @sizeInBytes, @lastAccessedTSD, name, filetype, folderID, folder, sizeAsString, @creationTSD)
SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),
	sizeInBytes = 	(case
						when @sizeInBytes >= 0 then @sizeInBytes
						else 2147483647 + (2147483648 + @sizeInBytes) -- todo: fix this, can even be multiple times, e.g. 7.4 mg --> 3 times, check with human readable size
					end),
	lastAccessedTSD = STR_TO_DATE(@lastAccessedTSD, '%d.%m.%Y %H:%i:%s'),
    creationTSD = STR_TO_DATE(@creationTSD, '%d.%m.%Y %H:%i:%s')
;

create index ix_folder_name on folder(name asc);
create index ix_file_name on file(name asc);
create index ix_file_filetype on file(filetype asc);
