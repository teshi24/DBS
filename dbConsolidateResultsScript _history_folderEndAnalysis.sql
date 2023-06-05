USE `fsc`;
-- möglichst einschränken 
-- > erst ganz am schluss left join auf die Files wos nötig ist --> done
-- Funktionen im Where und Order by sparsam
-- zwischentabellen brauchen keine sortierung, eigenentlich nur am schluss --> done
set profiling = 1;
-- select * from folder_foldername_preAnalysis;
-- select * from folder_foldername_preAnalysis_duplicatedFolders;
/*
select * from FOLDER_FOLDERNAME_ANALYSIS;

SELECT * FROM FILE_FILENAME_ANALYSIS;
SELECT * FROM FILE_FOLDERNAME_ANALYSIS;
SELECT * FROM FILE_FILETYPE_ANALYSIS;
SELECT * FROM file_size_analysis;
select * from file_lastAccessed_analysis;
*/

set profiling = 0;
DROP TABLE IF exists file_consolidatedRatios;
set profiling = 1;
create table file_consolidatedRatios (primary key (id)) as
-- explain
SELECT f.id, f.folder, f.folderid, f.name, f.lastAccessedTSD, f.sizeAsString, f.sizeInBytes, f.filetype
		/*
		, fna.ratiobasisID as 'fna_rbId', fna.ratio as 'fna_ratio', fna.weight as 'fna_weight',
        ffna.ratiobasisID as 'ffna_rbId', ffna.ratio as 'ffna_ratio', ffna.weight as 'ffna_weight',
		fta.ratiobasisID as 'fta_rbId', fta.ratio as 'fta_ratio', fta.weight as 'fta_weight',
		fsa.ratiobasisID as 'fsa_rbId', fsa.ratio as 'fsa_ratio', fsa.weight as 'fsa_weight',
		flaa.ratiobasisID as 'flaa_rbId', flaa.ratio as 'flaa_ratio', flaa.weight as 'flaa_weight'
        */
        , fna.recommendedAction as fna_recommendedAction, fna.ratio * fna.weight / 100 as fna_weighted_average
		, ffna.recommendedAction as ffna_recommendedAction, ffna.ratio * ffna.weight / 100 as ffna_weighted_average
		, fsa.recommendedAction as fta_recommendedAction, fta.ratio * fta.weight / 100 as fta_weighted_average
		, fsa.recommendedAction as fsa_recommendedAction, fsa.ratio * fsa.weight / 100 as fsa_weighted_average
		, flaa.recommendedAction as flaa_recommendedAction, flaa.ratio * flaa.weight / 100 as flaa_weighted_average
FROM
  file f
  	left join file_filename_analysis fna on fna.id = f.id
	left join FILE_FOLDERNAME_ANALYSIS ffna on ffna.id = f.id
	left join FILE_FILETYPE_ANALYSIS fta on fta.id = f.id
	left join file_size_analysis fsa on fsa.id = f.id
	left join file_lastAccessed_analysis flaa on flaa.id = f.id
;

select * from file_consolidatedRatios;

alter table file_consolidatedRatios
add B_ratio int,
add D_ratio int,
add N_ratio int,
add no_ratio_count int,
add recommendation varchar(10),
add recommendationRatio int;

DELIMITER //
DROP PROCEDURE IF EXISTS calculateConsolidatedRatios //
CREATE PROCEDURE calculateConsolidatedRatios()
BEGIN
  SET SQL_SAFE_UPDATES=0;
  UPDATE file_consolidatedRatios m
  SET
    m.B_ratio = IF(m.fna_recommendedAction = 'B', m.fna_weighted_average, 0) + IF(m.ffna_recommendedAction = 'B', m.ffna_weighted_average, 0) +IF(m.fta_recommendedAction = 'B', m.fta_weighted_average, 0) +IF(m.fsa_recommendedAction = 'B', m.fsa_weighted_average, 0) +IF(m.flaa_recommendedAction = 'B', m.flaa_weighted_average, 0),
    m.D_ratio = IF(m.fna_recommendedAction = 'D', m.fna_weighted_average, 0) + IF(m.ffna_recommendedAction = 'D', m.ffna_weighted_average, 0) + IF(m.fta_recommendedAction = 'D', m.fta_weighted_average, 0) +IF(m.fsa_recommendedAction = 'D', m.fsa_weighted_average, 0) +IF(m.flaa_recommendedAction = 'D', m.flaa_weighted_average, 0),
    m.N_ratio = IF(m.fna_recommendedAction = 'N', m.fna_weighted_average, 0) + IF(m.ffna_recommendedAction = 'N', m.ffna_weighted_average, 0) + IF(m.fta_recommendedAction = 'N', m.fta_weighted_average, 0) +IF(m.fsa_recommendedAction = 'N', m.fsa_weighted_average, 0) +IF(m.flaa_recommendedAction = 'N', m.flaa_weighted_average, 0),
    m.no_ratio_count = IF(m.fna_recommendedAction IS NULL, 1, 0) + IF(m.ffna_recommendedAction IS NULL, 1, 0) + IF(m.fta_recommendedAction IS NULL, 1, 0) +IF(m.fsa_recommendedAction  IS NULL, 1, 0) +IF(m.flaa_recommendedAction IS NULL, 1, 0)
  ;
  UPDATE file_consolidatedRatios m
  SET
    m.recommendation = CASE
							WHEN m.N_ratio >= D_ratio and m.N_ratio >= B_ratio then 'N'
							WHEN m.D_ratio > B_ratio then 'D'
							WHEN m.B_ratio > D_ratio then 'B'
							WHEN m.D_ratio = B_ratio then 'B/D'
							else null
						END,
	m.recommendationRatio = CASE
							WHEN m.N_ratio >= D_ratio and m.N_ratio >= B_ratio then m.N_ratio
							WHEN m.D_ratio >= B_ratio then m.D_ratio
							WHEN m.B_ratio > D_ratio then m.B_ratio
							else null
						END
  ;
  SET SQL_SAFE_UPDATES=1;
END //
DELIMITER ;

call calculateConsolidatedRatios();

select * from file_consolidatedRatios;

select f.id, f.folder, f.name, f.lastAccessedTSD, f.sizeAsString, f.sizeInBytes, f.filetype
, f.recommendation, f.recommendationRatio from file_consolidatedRatios f;

-- folder analysis
set profiling = 0;
DROP TABLE IF exists folderPreAnalysis;
set profiling = 1;
create table folderPreAnalysis (primary key (folderId, recommendation)) as
-- explain
 select f.folderId, f.folder, f.recommendation, avg(f.recommendationRatio) as recommendationRatio, count(*) as recommendationTypeCount
 from file_consolidatedRatios f
 group by f.folderid, f.recommendation;
set profiling = 0;

DROP TABLE IF exists folderPreAnalysis_duplicatedFolders;
set profiling = 1;
create table folderPreAnalysis_duplicatedFolders (primary key (folderId)) as
  select folderId, count(*) from folderPreAnalysis F
  group by folderId
  having count(*) > 1;

set profiling = 0;
DROP TABLE IF exists FOLDER_ANALYSIS;
set profiling = 1;
create table FOLDER_ANALYSIS (primary key (folderID)) as 
	SELECT f.*, sum(fileCr.sizeInBytes) as sizeInBytes, count(*) as countOfFiles, max(fileCr.lastAccessedTSD) as lastAccessedTSD FROM folderPreAnalysis F
       join folderPreAnalysis_duplicatedFolders df on F.folderId = df.folderId
       join file_consolidatedRatios fileCr on f.folderId = fileCr.folderId
	   where f.recommendationRatio = (
		  select MAX(innerF.recommendationRatio)
		  from folderPreAnalysis innerF
		  where innerF.folderID = F.folderID
		) and f.recommendation = (
		  select MAX(innerF.recommendation)
		  from folderPreAnalysis innerF
		  where innerF.folderID = F.folderID
        )
        group by f.folderId;
set profiling = 1;

INSERT ignore INTO folder_analysis (`folderId`, `folder`, `recommendation`, `recommendationRatio`, `recommendationTypeCount`, `sizeInBytes`, `countOfFiles`, `lastAccessedTSD`)
	SELECT f.*, sum(fileCr.sizeInBytes) as sizeInBytes, count(*) as countOfFiles, max(fileCr.lastAccessedTSD) as lastAccessedTSD FROM folderPreAnalysis F       join file_consolidatedRatios fileCr on f.folderId = fileCr.folderId
		group by f.folderId;

/*
set profiling = 0;
DROP TABLE IF exists folderAnalysis;
set profiling = 1;
create table folderAnalysis as (primary key (folderId, recommendation)) as
-- explain
 select fa.folderId, fa.folder, fa.recommendation, max(fa.recommendationRatio), fa.recommendationTypeCount
 -- sum(f.sizeInBytes) as sizeInBytes, count(*) as countOfFiles, max(f.lastAccessedTSD) as lastAccessedTSD
 from file_consolidatedRatios f
 where f.folderId in (33, /*40,/ 41, 47, 59, 63, 64, 73, 104, 105, 117, 119, 120, 125, 129, 130, 132, 134, 139, 675, 680, /*1058,/ 1059, 1062, 1073)
 -- 40, 1058, 
 group by f.folderid, f.recommendation
--  having max(recommendationRatio) -- and max(count(*))
 ;

set profiling = 0;
DROP TABLE IF exists folderAnalysis;
set profiling = 1;
create table folderAnalysis as -- (primary key (folderId)) as
-- explain
 select f.folderId, f.folder, f.recommendation, avg(f.recommendationRatio) as 'recommendationRatio', count(*) as recommendationTypeCount
 -- sum(f.sizeInBytes) as sizeInBytes, count(*) as countOfFiles, max(f.lastAccessedTSD) as lastAccessedTSD
 from file_consolidatedRatios f
 where f.folderId in (33, /*40,/ 41, 47, 59, 63, 64, 73, 104, 105, 117, 119, 120, 125, 129, 130, 132, 134, 139, 675, 680, /*1058,/ 1059, 1062, 1073)
 -- 40, 1058, 
 group by f.folderid, f.recommendation
--  having max(recommendationRatio) -- and max(count(*))
 ;
 
select * from folderAnalysis f
 group by f.folderId
 having count(*) > 1;
 
 select * from folderAnalysis;
 
set profiling = 0;
DROP TABLE IF exists folderAnalysis_full;
set profiling = 1;
create table folderAnalysis_full (primary key (folderId)) as
-- explain
 select fa.*, sum(f.sizeInBytes) as sizeInBytes, count(*) as countOfFiles, max(f.lastAccessedTSD) as lastAccessedTSD from folderAnalysis fa
    join file_consolidatedRatios f on f.folderId = fa.folderId
	group by folderId;
*/

select * from folder_analysis f
 order by f.recommendationRatio, f.sizeInBytes;

show profiles;
 -- show profile for query 1;
set profiling = 0;
