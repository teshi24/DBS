LOAD DATA INFILE '../data/DBS_folder_analysis.csv' INTO TABLE folder
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@lastModifiedTSD, path, name, @parentFolderID, ID)
SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),
	parentFolderID = nullIf(@parentFolderID, '')
;

SELECT * FROM fsc.folder;
SELECT count(*) FROM fsc.folder;
-- file driveD - empty table
-- 17:52:04	LOAD DATA INFILE '../data/DBS_folder_analysis_driveD.csv' INTO TABLE folder FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (@lastModifiedTSD, path, name, @parentFolderID, ID) SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),  parentFolderID = nullIf(@parentFolderID, '')	7708 row(s) affected, 21 warning(s): 1264 Out of range value for column 'lastModifiedTSD' at row 1 1265 Data truncated for column 'name' at row 333 1265 Data truncated for column 'name' at row 334 1265 Data truncated for column 'name' at row 342 1265 Data truncated for column 'name' at row 647 1265 Data truncated for column 'name' at row 657 1265 Data truncated for column 'name' at row 1095 1265 Data truncated for column 'name' at row 1096 1265 Data truncated for column 'name' at row 1097 1265 Data truncated for column 'name' at row 1098 1265 Data truncated for column 'name' at row 1099 1265 Data truncated for column 'name' at row 1100 1265 Data truncated for column 'name' at row 1308 1265 Data truncated for column 'name' at row 1310 1265 Data truncated for column 'name' at row 1312 1265 Data truncated for column 'name' at row 1318 1265 Data truncated for column 'name' at row 1319 1265 Data truncated for column 'name' at row 1416 1265 Data truncated for column 'name' at row 1423 1265 Data truncated for column 'name' at row 1505 1265 Data truncated for column 'name' at row 1569
--          Records: 7708  Deleted: 0  Skipped: 0  Warnings: 21	0.250 sec
-- 17:52:04	SELECT * FROM fsc.folder	7708 row(s) returned	0.000 sec / 0.016 sec
-- 17:52:05	SELECT count(*) FROM fsc.folder	1 row(s) returned	0.000 sec / 0.000 sec
-- run 2
-- 20:10:58	LOAD DATA INFILE '../data/DBS_folder_analysis_driveD.csv' INTO TABLE folder FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (@lastModifiedTSD, path, name, @parentFolderID, ID) SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),  parentFolderID = nullIf(@parentFolderID, '')	7708 row(s) affected, 21 warning(s): 1264 Out of range value for column 'lastModifiedTSD' at row 1 1265 Data truncated for column 'name' at row 333 1265 Data truncated for column 'name' at row 334 1265 Data truncated for column 'name' at row 342 1265 Data truncated for column 'name' at row 647 1265 Data truncated for column 'name' at row 657 1265 Data truncated for column 'name' at row 1095 1265 Data truncated for column 'name' at row 1096 1265 Data truncated for column 'name' at row 1097 1265 Data truncated for column 'name' at row 1098 1265 Data truncated for column 'name' at row 1099 1265 Data truncated for column 'name' at row 1100 1265 Data truncated for column 'name' at row 1308 1265 Data truncated for column 'name' at row 1310 1265 Data truncated for column 'name' at row 1312 1265 Data truncated for column 'name' at row 1318 1265 Data truncated for column 'name' at row 1319 1265 Data truncated for column 'name' at row 1416 1265 Data truncated for column 'name' at row 1423 1265 Data truncated for column 'name' at row 1505 1265 Data truncated for column 'name' at row 1569
--          Records: 7708  Deleted: 0  Skipped: 0  Warnings: 21	0.235 sec
-- 20:10:59	SELECT * FROM fsc.folder	7708 row(s) returned	0.000 sec / 0.015 sec
-- 20:10:59	SELECT count(*) FROM fsc.folder	1 row(s) returned	0.000 sec / 0.000 sec
-- after adding folder information + improved size of path / name
-- 20:38:44	LOAD DATA INFILE '../data/DBS_folder_analysis_driveD.csv' INTO TABLE folder FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (@lastModifiedTSD, path, name, @parentFolderID, ID) SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),  parentFolderID = nullIf(@parentFolderID, '')	7708 row(s) affected, 1 warning(s): 1264 Out of range value for column 'lastModifiedTSD' at row 1 
--          Records: 7708  Deleted: 0  Skipped: 0  Warnings: 1	0.250 sec
-- 20:38:45	SELECT * FROM fsc.folder	7708 row(s) returned	0.000 sec / 0.016 sec
-- 20:38:45	SELECT count(*) FROM fsc.folder	1 row(s) returned	0.000 sec / 0.000 sec


-- file driveC - preloaded driveD data
-- 17:55:37	LOAD DATA INFILE '../data/DBS_folder_analysis_driveC.csv' INTO TABLE folder FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (@lastModifiedTSD, path, name, @parentFolderID, ID) SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),  parentFolderID = nullIf(@parentFolderID, '')	116562 row(s) affected, 64 warning(s): 1264 Out of range value for column 'lastModifiedTSD' at row 1 1265 Data truncated for column 'name' at row 1176 1265 Data truncated for column 'name' at row 1584 1265 Data truncated for column 'name' at row 1585 1265 Data truncated for column 'name' at row 1586 1265 Data truncated for column 'name' at row 1587 1265 Data truncated for column 'name' at row 1588 1265 Data truncated for column 'name' at row 1590 1265 Data truncated for column 'name' at row 1591 1265 Data truncated for column 'name' at row 1592 1265 Data truncated for column 'name' at row 1593 1265 Data truncated for column 'name' at row 1715 1264 Out of range value for column 'lastModifiedTSD' at row 1953 1264 Out of range value for column 'lastModifiedTSD' at row 1973 1264 Out of range value for column 'lastModifiedTSD' at row 1974 1264 Out of range value for column 'lastModifiedTSD' at row 1977 1264 Out of range value for column 'lastModifiedTSD' at row 1981 1264 Out of range value for column 'lastModifiedTSD' at row 1982 1265 Data truncated for column 'name' at row 2073 1265 Data truncated for column 'name' at row 2080 1265 Data truncated for column 'name' at row 2084 1265 Data truncated for column 'name' at row 2085 1265 Data truncated for column 'name' at row 2087 1265 Data truncated for column 'name' at row 2089 1265 Data truncated for column 'name' at row 2095 1265 Data truncated for column 'name' at row 2102 1265 Data truncated for column 'name' at row 2108 1264 Out of range value for column 'lastModifiedTSD' at row 2128 1264 Out of range value for column 'lastModifiedTSD' at row 2133 1265 Data truncated for column 'name' at row 2242 1265 Data truncated for column 'name' at row 2247 1265 Data truncated for column 'name' at row 2252 1265 Data truncated for column 'name' at row 2269 1265 Data truncated for column 'name' at row 2271 1265 Data truncated for column 'name' at row 2273 1265 Data truncated for column 'name' at row 2275 1265 Data truncated for column 'name' at row 2277 1265 Data truncated for column 'name' at row 2279 1265 Data truncated for column 'name' at row 2281 1265 Data truncated for column 'name' at row 2283 1265 Data truncated for column 'name' at row 2285 1265 Data truncated for column 'name' at row 2287 1265 Data truncated for column 'name' at row 2289 1265 Data truncated for column 'name' at row 2291 1265 Data truncated for column 'name' at row 2293 1265 Data truncated for column 'name' at row 2295 1265 Data truncated for column 'name' at row 2297 1265 Data truncated for column 'name' at row 2299 1265 Data truncated for column 'name' at row 2301 1265 Data truncated for column 'name' at row 2303 1265 Data truncated for column 'name' at row 2305 1265 Data truncated for column 'name' at row 2307 1265 Data truncated for column 'name' at row 2309 1265 Data truncated for column 'name' at row 2311 1265 Data truncated for column 'name' at row 2313 1265 Data truncated for column 'name' at row 2315 1265 Data truncated for column 'name' at row 2317 1265 Data truncated for column 'name' at row 2319 1265 Data truncated for column 'name' at row 2321 1265 Data truncated for column 'name' at row 2323 1265 Data truncated for column 'name' at row 2325 1265 Data truncated for column 'name' at row 2327 1265 Data truncated for column 'name' at row 2329 1265 Data truncated for column 'name' at row 2331
--          Records: 116562  Deleted: 0  Skipped: 0  Warnings: 44637	4.953 sec
-- 17:55:42	SELECT * FROM fsc.folder	124270 row(s) returned	0.000 sec / 0.594 sec
-- 17:55:43	SELECT count(*) FROM fsc.folder	1 row(s) returned	0.062 sec / 0.000 sec
-- run 2
-- 20:12:24	LOAD DATA INFILE '../data/DBS_folder_analysis_driveC.csv' INTO TABLE folder FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (@lastModifiedTSD, path, name, @parentFolderID, ID) SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),  parentFolderID = nullIf(@parentFolderID, '')	116562 row(s) affected, 64 warning(s): 1264 Out of range value for column 'lastModifiedTSD' at row 1 1265 Data truncated for column 'name' at row 1176 1265 Data truncated for column 'name' at row 1584 1265 Data truncated for column 'name' at row 1585 1265 Data truncated for column 'name' at row 1586 1265 Data truncated for column 'name' at row 1587 1265 Data truncated for column 'name' at row 1588 1265 Data truncated for column 'name' at row 1590 1265 Data truncated for column 'name' at row 1591 1265 Data truncated for column 'name' at row 1592 1265 Data truncated for column 'name' at row 1593 1265 Data truncated for column 'name' at row 1715 1264 Out of range value for column 'lastModifiedTSD' at row 1953 1264 Out of range value for column 'lastModifiedTSD' at row 1973 1264 Out of range value for column 'lastModifiedTSD' at row 1974 1264 Out of range value for column 'lastModifiedTSD' at row 1977 1264 Out of range value for column 'lastModifiedTSD' at row 1981 1264 Out of range value for column 'lastModifiedTSD' at row 1982 1265 Data truncated for column 'name' at row 2073 1265 Data truncated for column 'name' at row 2080 1265 Data truncated for column 'name' at row 2084 1265 Data truncated for column 'name' at row 2085 1265 Data truncated for column 'name' at row 2087 1265 Data truncated for column 'name' at row 2089 1265 Data truncated for column 'name' at row 2095 1265 Data truncated for column 'name' at row 2102 1265 Data truncated for column 'name' at row 2108 1264 Out of range value for column 'lastModifiedTSD' at row 2128 1264 Out of range value for column 'lastModifiedTSD' at row 2133 1265 Data truncated for column 'name' at row 2242 1265 Data truncated for column 'name' at row 2247 1265 Data truncated for column 'name' at row 2252 1265 Data truncated for column 'name' at row 2269 1265 Data truncated for column 'name' at row 2271 1265 Data truncated for column 'name' at row 2273 1265 Data truncated for column 'name' at row 2275 1265 Data truncated for column 'name' at row 2277 1265 Data truncated for column 'name' at row 2279 1265 Data truncated for column 'name' at row 2281 1265 Data truncated for column 'name' at row 2283 1265 Data truncated for column 'name' at row 2285 1265 Data truncated for column 'name' at row 2287 1265 Data truncated for column 'name' at row 2289 1265 Data truncated for column 'name' at row 2291 1265 Data truncated for column 'name' at row 2293 1265 Data truncated for column 'name' at row 2295 1265 Data truncated for column 'name' at row 2297 1265 Data truncated for column 'name' at row 2299 1265 Data truncated for column 'name' at row 2301 1265 Data truncated for column 'name' at row 2303 1265 Data truncated for column 'name' at row 2305 1265 Data truncated for column 'name' at row 2307 1265 Data truncated for column 'name' at row 2309 1265 Data truncated for column 'name' at row 2311 1265 Data truncated for column 'name' at row 2313 1265 Data truncated for column 'name' at row 2315 1265 Data truncated for column 'name' at row 2317 1265 Data truncated for column 'name' at row 2319 1265 Data truncated for column 'name' at row 2321 1265 Data truncated for column 'name' at row 2323 1265 Data truncated for column 'name' at row 2325 1265 Data truncated for column 'name' at row 2327 1265 Data truncated for column 'name' at row 2329 1265 Data truncated for column 'name' at row 2331
--          Records: 116562  Deleted: 0  Skipped: 0  Warnings: 44637	3.907 sec
-- 20:12:28	SELECT * FROM fsc.folder	124270 row(s) returned	0.000 sec / 1.562 sec
-- 20:12:30	SELECT count(*) FROM fsc.folder	1 row(s) returned	0.031 sec / 0.000 sec
-- after adding folder information + improved size of path / name
-- 20:44:36	LOAD DATA INFILE '../data/DBS_folder_analysis_driveC.csv' INTO TABLE folder FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (@lastModifiedTSD, path, name, @parentFolderID, ID) SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),  parentFolderID = nullIf(@parentFolderID, '')	116562 row(s) affected, 9 warning(s): 1264 Out of range value for column 'lastModifiedTSD' at row 1 1264 Out of range value for column 'lastModifiedTSD' at row 1953 1264 Out of range value for column 'lastModifiedTSD' at row 1973 1264 Out of range value for column 'lastModifiedTSD' at row 1974 1264 Out of range value for column 'lastModifiedTSD' at row 1977 1264 Out of range value for column 'lastModifiedTSD' at row 1981 1264 Out of range value for column 'lastModifiedTSD' at row 1982 1264 Out of range value for column 'lastModifiedTSD' at row 2128 1264 Out of range value for column 'lastModifiedTSD' at row 2133
--          Records: 116562  Deleted: 0  Skipped: 0  Warnings: 9	4.141 sec
-- 20:44:40	SELECT * FROM fsc.folder	124270 row(s) returned	0.000 sec / 0.453 sec
-- 20:44:41	SELECT count(*) FROM fsc.folder	1 row(s) returned	0.031 sec / 0.000 sec


LOAD DATA INFILE '../data/DBS_file_analysis.csv' INTO TABLE file
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

SELECT * FROM fsc.file;
SELECT count(*) FROM fsc.file;

-- file driveD - empty table
-- 17:52:05	LOAD DATA INFILE '../data/DBS_file_analysis_driveD.csv' INTO TABLE file FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (@lastModifiedTSD, @sizeInBytes, @lastAccessedTSD, name, filetype, folderID, @dummy, sizeAsString, @creationTSD) SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),  sizeInBytes =  (case       when @sizeInBytes >= 0 then @sizeInBytes       else 2147483647 + (2147483648 + @sizeInBytes) -- todo: fix this, can even be multiple times, e.g. 7.4 mg --> 3 times, check with human readable size      end),  lastAccessedTSD = STR_TO_DATE(@lastAccessedTSD, '%d.%m.%Y %H:%i:%s'),     creationTSD = STR_TO_DATE(@creationTSD, '%d.%m.%Y %H:%i:%s')	136533 row(s) affected, 64 warning(s): 1265 Data truncated for column 'name' at row 607 1265 Data truncated for column 'name' at row 643 1265 Data truncated for column 'name' at row 660 1265 Data truncated for column 'name' at row 664 1265 Data truncated for column 'name' at row 672 1265 Data truncated for column 'name' at row 686 1265 Data truncated for column 'name' at row 726 1265 Data truncated for column 'name' at row 733 1265 Data truncated for column 'name' at row 735 1265 Data truncated for column 'name' at row 900 1265 Data truncated for column 'name' at row 901 1265 Data truncated for column 'name' at row 902 1265 Data truncated for column 'name' at row 903 1265 Data truncated for column 'name' at row 905 1265 Data truncated for column 'name' at row 906 1265 Data truncated for column 'name' at row 907 1265 Data truncated for column 'name' at row 908 1265 Data truncated for column 'name' at row 909 1265 Data truncated for column 'name' at row 910 1265 Data truncated for column 'name' at row 912 1265 Data truncated for column 'name' at row 914 1265 Data truncated for column 'name' at row 915 1265 Data truncated for column 'name' at row 916 1265 Data truncated for column 'name' at row 919 1265 Data truncated for column 'name' at row 920 1265 Data truncated for column 'name' at row 929 1265 Data truncated for column 'name' at row 930 1265 Data truncated for column 'name' at row 932 1265 Data truncated for column 'name' at row 938 1265 Data truncated for column 'name' at row 941 1265 Data truncated for column 'name' at row 947 1265 Data truncated for column 'name' at row 949 1265 Data truncated for column 'name' at row 957 1265 Data truncated for column 'name' at row 958 1265 Data truncated for column 'name' at row 959 1265 Data truncated for column 'name' at row 961 1265 Data truncated for column 'name' at row 962 1265 Data truncated for column 'name' at row 963 1265 Data truncated for column 'name' at row 969 1265 Data truncated for column 'name' at row 979 1265 Data truncated for column 'name' at row 980 1265 Data truncated for column 'name' at row 996 1265 Data truncated for column 'name' at row 1006 1265 Data truncated for column 'name' at row 1040 1265 Data truncated for column 'name' at row 1050 1265 Data truncated for column 'name' at row 1070 1265 Data truncated for column 'name' at row 1071 1265 Data truncated for column 'name' at row 1072 1265 Data truncated for column 'name' at row 1073 1265 Data truncated for column 'name' at row 1075 1265 Data truncated for column 'name' at row 1076 1265 Data truncated for column 'name' at row 1077 1265 Data truncated for column 'name' at row 1078 1265 Data truncated for column 'name' at row 1079 1265 Data truncated for column 'name' at row 1080 1265 Data truncated for column 'name' at row 1089 1265 Data truncated for column 'name' at row 1092 1265 Data truncated for column 'name' at row 1093 1265 Data truncated for column 'name' at row 1095 1265 Data truncated for column 'name' at row 1097 1265 Data truncated for column 'name' at row 1104 1265 Data truncated for column 'name' at row 1107 1265 Data truncated for column 'name' at row 1116 1265 Data truncated for column 'name' at row 1118
--          Records: 136533  Deleted: 0  Skipped: 0  Warnings: 2061	2.594 sec
-- 17:52:07	SELECT * FROM fsc.file	136533 row(s) returned	0.000 sec / 0.438 sec
-- 17:52:08	SELECT count(*) FROM fsc.file	1 row(s) returned	0.047 sec / 0.000 sec
-- run 2
-- 20:10:59	LOAD DATA INFILE '../data/DBS_file_analysis_driveD.csv' INTO TABLE file FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (@lastModifiedTSD, @sizeInBytes, @lastAccessedTSD, name, filetype, folderID, @dummy, sizeAsString, @creationTSD) SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),  sizeInBytes =  (case       when @sizeInBytes >= 0 then @sizeInBytes       else 2147483647 + (2147483648 + @sizeInBytes) -- todo: fix this, can even be multiple times, e.g. 7.4 mg --> 3 times, check with human readable size      end),  lastAccessedTSD = STR_TO_DATE(@lastAccessedTSD, '%d.%m.%Y %H:%i:%s'),     creationTSD = STR_TO_DATE(@creationTSD, '%d.%m.%Y %H:%i:%s')	136533 row(s) affected, 64 warning(s): 1265 Data truncated for column 'name' at row 607 1265 Data truncated for column 'name' at row 643 1265 Data truncated for column 'name' at row 660 1265 Data truncated for column 'name' at row 664 1265 Data truncated for column 'name' at row 672 1265 Data truncated for column 'name' at row 686 1265 Data truncated for column 'name' at row 726 1265 Data truncated for column 'name' at row 733 1265 Data truncated for column 'name' at row 735 1265 Data truncated for column 'name' at row 900 1265 Data truncated for column 'name' at row 901 1265 Data truncated for column 'name' at row 902 1265 Data truncated for column 'name' at row 903 1265 Data truncated for column 'name' at row 905 1265 Data truncated for column 'name' at row 906 1265 Data truncated for column 'name' at row 907 1265 Data truncated for column 'name' at row 908 1265 Data truncated for column 'name' at row 909 1265 Data truncated for column 'name' at row 910 1265 Data truncated for column 'name' at row 912 1265 Data truncated for column 'name' at row 914 1265 Data truncated for column 'name' at row 915 1265 Data truncated for column 'name' at row 916 1265 Data truncated for column 'name' at row 919 1265 Data truncated for column 'name' at row 920 1265 Data truncated for column 'name' at row 929 1265 Data truncated for column 'name' at row 930 1265 Data truncated for column 'name' at row 932 1265 Data truncated for column 'name' at row 938 1265 Data truncated for column 'name' at row 941 1265 Data truncated for column 'name' at row 947 1265 Data truncated for column 'name' at row 949 1265 Data truncated for column 'name' at row 957 1265 Data truncated for column 'name' at row 958 1265 Data truncated for column 'name' at row 959 1265 Data truncated for column 'name' at row 961 1265 Data truncated for column 'name' at row 962 1265 Data truncated for column 'name' at row 963 1265 Data truncated for column 'name' at row 969 1265 Data truncated for column 'name' at row 979 1265 Data truncated for column 'name' at row 980 1265 Data truncated for column 'name' at row 996 1265 Data truncated for column 'name' at row 1006 1265 Data truncated for column 'name' at row 1040 1265 Data truncated for column 'name' at row 1050 1265 Data truncated for column 'name' at row 1070 1265 Data truncated for column 'name' at row 1071 1265 Data truncated for column 'name' at row 1072 1265 Data truncated for column 'name' at row 1073 1265 Data truncated for column 'name' at row 1075 1265 Data truncated for column 'name' at row 1076 1265 Data truncated for column 'name' at row 1077 1265 Data truncated for column 'name' at row 1078 1265 Data truncated for column 'name' at row 1079 1265 Data truncated for column 'name' at row 1080 1265 Data truncated for column 'name' at row 1089 1265 Data truncated for column 'name' at row 1092 1265 Data truncated for column 'name' at row 1093 1265 Data truncated for column 'name' at row 1095 1265 Data truncated for column 'name' at row 1097 1265 Data truncated for column 'name' at row 1104 1265 Data truncated for column 'name' at row 1107 1265 Data truncated for column 'name' at row 1116 1265 Data truncated for column 'name' at row 1118 
--          Records: 136533  Deleted: 0  Skipped: 0  Warnings: 2061	2.422 sec
-- 20:11:01	SELECT * FROM fsc.file	136533 row(s) returned	0.000 sec / 0.391 sec
-- 20:11:02	SELECT count(*) FROM fsc.file	1 row(s) returned	0.093 sec / 0.000 sec
-- after adding folder information + improved size of path / name
-- 20:38:45	LOAD DATA INFILE '../data/DBS_file_analysis_driveD.csv' INTO TABLE file FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (@lastModifiedTSD, @sizeInBytes, @lastAccessedTSD, name, filetype, folderID, folder, sizeAsString, @creationTSD) SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),  sizeInBytes =  (case       when @sizeInBytes >= 0 then @sizeInBytes       else 2147483647 + (2147483648 + @sizeInBytes) -- todo: fix this, can even be multiple times, e.g. 7.4 mg --> 3 times, check with human readable size      end),  lastAccessedTSD = STR_TO_DATE(@lastAccessedTSD, '%d.%m.%Y %H:%i:%s'),     creationTSD = STR_TO_DATE(@creationTSD, '%d.%m.%Y %H:%i:%s')	136533 row(s) affected, 3 warning(s): 1366 Incorrect string value: '\xF0\x9F\x99\x8E\xF0\x9F...' for column `fsc`.`file`.`name` at row 72768 1366 Incorrect string value: '\xF0\x9F\x8E\x89 2...' for column `fsc`.`file`.`name` at row 89128 1366 Incorrect string value: '\xF0\x9F\x8E\x89 2...' for column `fsc`.`file`.`name` at row 126328
--          Records: 136533  Deleted: 0  Skipped: 0  Warnings: 3	2.719 sec
-- 20:38:47	SELECT * FROM fsc.file	136533 row(s) returned	0.015 sec / 0.532 sec
-- 20:38:49	SELECT count(*) FROM fsc.file	1 row(s) returned	0.062 sec / 0.000 sec


-- file driveC - preloaded driveD data
-- 17:55:44	LOAD DATA INFILE '../data/DBS_file_analysis_driveC.csv' INTO TABLE file FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (@lastModifiedTSD, @sizeInBytes, @lastAccessedTSD, name, filetype, folderID, @dummy, sizeAsString, @creationTSD) SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),  sizeInBytes =  (case       when @sizeInBytes >= 0 then @sizeInBytes       else 2147483647 + (2147483648 + @sizeInBytes) -- todo: fix this, can even be multiple times, e.g. 7.4 mg --> 3 times, check with human readable size      end),  lastAccessedTSD = STR_TO_DATE(@lastAccessedTSD, '%d.%m.%Y %H:%i:%s'),     creationTSD = STR_TO_DATE(@creationTSD, '%d.%m.%Y %H:%i:%s')	347269 row(s) affected, 64 warning(s): 1265 Data truncated for column 'name' at row 4946 1265 Data truncated for column 'name' at row 4947 1265 Data truncated for column 'name' at row 4948 1265 Data truncated for column 'name' at row 4949 1265 Data truncated for column 'name' at row 4950 1265 Data truncated for column 'name' at row 4951 1265 Data truncated for column 'name' at row 4952 1265 Data truncated for column 'name' at row 4953 1265 Data truncated for column 'name' at row 4954 1265 Data truncated for column 'name' at row 4955 1265 Data truncated for column 'name' at row 4956 1265 Data truncated for column 'name' at row 4957 1265 Data truncated for column 'name' at row 4958 1265 Data truncated for column 'name' at row 4959 1265 Data truncated for column 'name' at row 4960 1265 Data truncated for column 'name' at row 4961 1265 Data truncated for column 'name' at row 4962 1265 Data truncated for column 'name' at row 4963 1265 Data truncated for column 'name' at row 4964 1265 Data truncated for column 'name' at row 4965 1265 Data truncated for column 'name' at row 4966 1265 Data truncated for column 'name' at row 4967 1265 Data truncated for column 'name' at row 4968 1265 Data truncated for column 'name' at row 4969 1265 Data truncated for column 'name' at row 4970 1265 Data truncated for column 'name' at row 4971 1265 Data truncated for column 'name' at row 4972 1265 Data truncated for column 'name' at row 4973 1265 Data truncated for column 'name' at row 4974 1265 Data truncated for column 'name' at row 4975 1265 Data truncated for column 'name' at row 6784 1265 Data truncated for column 'name' at row 6788 1265 Data truncated for column 'name' at row 6790 1265 Data truncated for column 'name' at row 6795 1265 Data truncated for column 'name' at row 6799 1265 Data truncated for column 'name' at row 6801 1265 Data truncated for column 'name' at row 6803 1265 Data truncated for column 'name' at row 6804 1265 Data truncated for column 'name' at row 6810 1265 Data truncated for column 'name' at row 6812 1265 Data truncated for column 'name' at row 6813 1265 Data truncated for column 'name' at row 6949 1265 Data truncated for column 'name' at row 6950 1265 Data truncated for column 'name' at row 6976 1265 Data truncated for column 'name' at row 6977 1265 Data truncated for column 'name' at row 7024 1265 Data truncated for column 'name' at row 7025 1265 Data truncated for column 'name' at row 7026 1265 Data truncated for column 'name' at row 7069 1265 Data truncated for column 'name' at row 7070 1265 Data truncated for column 'name' at row 7084 1265 Data truncated for column 'name' at row 7085 1265 Data truncated for column 'name' at row 7194 1265 Data truncated for column 'name' at row 7215 1265 Data truncated for column 'name' at row 7309 1265 Data truncated for column 'name' at row 7310 1265 Data truncated for column 'name' at row 7439 1265 Data truncated for column 'name' at row 7454 1265 Data truncated for column 'name' at row 7471 1265 Data truncated for column 'name' at row 7557 1265 Data truncated for column 'name' at row 7558 1265 Data truncated for column 'name' at row 7574 1265 Data truncated for column 'name' at row 7575 1265 Data truncated for column 'name' at row 7590
--          Records: 347269  Deleted: 0  Skipped: 0  Warnings: 144355	6.828 sec
-- 17:55:50	SELECT * FROM fsc.file	483802 row(s) returned	0.000 sec / 2.563 sec
-- 17:55:56	SELECT count(*) FROM fsc.file	1 row(s) returned	0.093 sec / 0.000 sec
-- run 2
-- 20:12:30	LOAD DATA INFILE '../data/DBS_file_analysis_driveC.csv' INTO TABLE file FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (@lastModifiedTSD, @sizeInBytes, @lastAccessedTSD, name, filetype, folderID, @dummy, sizeAsString, @creationTSD) SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),  sizeInBytes =  (case       when @sizeInBytes >= 0 then @sizeInBytes       else 2147483647 + (2147483648 + @sizeInBytes) -- todo: fix this, can even be multiple times, e.g. 7.4 mg --> 3 times, check with human readable size      end),  lastAccessedTSD = STR_TO_DATE(@lastAccessedTSD, '%d.%m.%Y %H:%i:%s'),     creationTSD = STR_TO_DATE(@creationTSD, '%d.%m.%Y %H:%i:%s')	347269 row(s) affected, 64 warning(s): 1265 Data truncated for column 'name' at row 4946 1265 Data truncated for column 'name' at row 4947 1265 Data truncated for column 'name' at row 4948 1265 Data truncated for column 'name' at row 4949 1265 Data truncated for column 'name' at row 4950 1265 Data truncated for column 'name' at row 4951 1265 Data truncated for column 'name' at row 4952 1265 Data truncated for column 'name' at row 4953 1265 Data truncated for column 'name' at row 4954 1265 Data truncated for column 'name' at row 4955 1265 Data truncated for column 'name' at row 4956 1265 Data truncated for column 'name' at row 4957 1265 Data truncated for column 'name' at row 4958 1265 Data truncated for column 'name' at row 4959 1265 Data truncated for column 'name' at row 4960 1265 Data truncated for column 'name' at row 4961 1265 Data truncated for column 'name' at row 4962 1265 Data truncated for column 'name' at row 4963 1265 Data truncated for column 'name' at row 4964 1265 Data truncated for column 'name' at row 4965 1265 Data truncated for column 'name' at row 4966 1265 Data truncated for column 'name' at row 4967 1265 Data truncated for column 'name' at row 4968 1265 Data truncated for column 'name' at row 4969 1265 Data truncated for column 'name' at row 4970 1265 Data truncated for column 'name' at row 4971 1265 Data truncated for column 'name' at row 4972 1265 Data truncated for column 'name' at row 4973 1265 Data truncated for column 'name' at row 4974 1265 Data truncated for column 'name' at row 4975 1265 Data truncated for column 'name' at row 6784 1265 Data truncated for column 'name' at row 6788 1265 Data truncated for column 'name' at row 6790 1265 Data truncated for column 'name' at row 6795 1265 Data truncated for column 'name' at row 6799 1265 Data truncated for column 'name' at row 6801 1265 Data truncated for column 'name' at row 6803 1265 Data truncated for column 'name' at row 6804 1265 Data truncated for column 'name' at row 6810 1265 Data truncated for column 'name' at row 6812 1265 Data truncated for column 'name' at row 6813 1265 Data truncated for column 'name' at row 6949 1265 Data truncated for column 'name' at row 6950 1265 Data truncated for column 'name' at row 6976 1265 Data truncated for column 'name' at row 6977 1265 Data truncated for column 'name' at row 7024 1265 Data truncated for column 'name' at row 7025 1265 Data truncated for column 'name' at row 7026 1265 Data truncated for column 'name' at row 7069 1265 Data truncated for column 'name' at row 7070 1265 Data truncated for column 'name' at row 7084 1265 Data truncated for column 'name' at row 7085 1265 Data truncated for column 'name' at row 7194 1265 Data truncated for column 'name' at row 7215 1265 Data truncated for column 'name' at row 7309 1265 Data truncated for column 'name' at row 7310 1265 Data truncated for column 'name' at row 7439 1265 Data truncated for column 'name' at row 7454 1265 Data truncated for column 'name' at row 7471 1265 Data truncated for column 'name' at row 7557 1265 Data truncated for column 'name' at row 7558 1265 Data truncated for column 'name' at row 7574 1265 Data truncated for column 'name' at row 7575 1265 Data truncated for column 'name' at row 7590
--          Records: 347269  Deleted: 0  Skipped: 0  Warnings: 144355	7.047 sec
-- 20:12:37	SELECT * FROM fsc.file	483802 row(s) returned	0.000 sec / 2.609 sec
-- 20:12:43	SELECT count(*) FROM fsc.file	1 row(s) returned	0.140 sec / 0.000 sec
-- after adding folder information + improved size of path / name
-- 20:44:41	LOAD DATA INFILE '../data/DBS_file_analysis_driveC.csv' INTO TABLE file FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (@lastModifiedTSD, @sizeInBytes, @lastAccessedTSD, name, filetype, folderID, folder, sizeAsString, @creationTSD) SET lastModifiedTSD = STR_TO_DATE(@lastModifiedTSD, '%d.%m.%Y %H:%i:%s'),  sizeInBytes =  (case       when @sizeInBytes >= 0 then @sizeInBytes       else 2147483647 + (2147483648 + @sizeInBytes) -- todo: fix this, can even be multiple times, e.g. 7.4 mg --> 3 times, check with human readable size      end),  lastAccessedTSD = STR_TO_DATE(@lastAccessedTSD, '%d.%m.%Y %H:%i:%s'),     creationTSD = STR_TO_DATE(@creationTSD, '%d.%m.%Y %H:%i:%s')	347269 row(s) affected, 10 warning(s): 1265 Data truncated for column 'sizeAsString' at row 19143 1411 Incorrect datetime value: 'BASH_HISTORY-Datei' for function str_to_date 1265 Data truncated for column 'sizeAsString' at row 19144 1411 Incorrect datetime value: 'GITCONFIG-Datei' for function str_to_date 1265 Data truncated for column 'sizeAsString' at row 19145 1411 Incorrect datetime value: 'LESSHST-Datei' for function str_to_date 1265 Data truncated for column 'sizeAsString' at row 19146 1411 Incorrect datetime value: 'Verknüpfung' for function str_to_date 1265 Data truncated for column 'sizeAsString' at row 19147 1411 Incorrect datetime value: 'Anwendung' for function str_to_date
--          Records: 347269  Deleted: 0  Skipped: 0  Warnings: 10	7.704 sec
-- 20:44:49	SELECT * FROM fsc.file	483802 row(s) returned	0.000 sec / 8.265 sec
-- 20:45:01	SELECT count(*) FROM fsc.file	1 row(s) returned	0.140 sec / 0.000 sec
