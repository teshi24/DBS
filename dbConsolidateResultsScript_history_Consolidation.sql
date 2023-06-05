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

/*
set profiling = 0;
DROP TABLE IF exists file_consolidatedAnalysis;
set profiling = 1;

create table file_consolidatedAnalysis (primary key (id)) as
-- explain
select f.id, f.folder, f.name, f.lastAccessedTSD, f.sizeAsString, f.sizeInBytes, f.filetype,
		fna.ratiobasisID as 'fna_rbId', fna.ratio as 'fna_ratio', fna.weight as 'fna_weight', fna.recommendedAction as 'fna_action',
        ffna.ratiobasisID as 'ffna_rbId', ffna.ratio as 'ffna_ratio', ffna.weight as 'ffna_weight', ffna.recommendedAction as 'ffna_action',
		fta.ratiobasisID as 'fta_rbId', fta.ratio as 'fta_ratio', fta.weight as 'fta_weight', fta.recommendedAction as 'fta_action',
		fsa.ratiobasisID as 'fsa_rbId', fsa.ratio as 'fsa_ratio', fsa.weight as 'fsa_weight', fsa.recommendedAction as 'fsa_action',
		flaa.ratiobasisID as 'flaa_rbId', flaa.ratio as 'flaa_ratio', flaa.weight as 'flaa_weight', flaa.recommendedAction as 'flaa_action'
		from file f
	left join file_filename_analysis fna on fna.id = f.id
	left join FILE_FOLDERNAME_ANALYSIS ffna on ffna.id = f.id
	left join FILE_FILETYPE_ANALYSIS fta on fta.id = f.id
	left join file_size_analysis fsa on fsa.id = f.id
	left join file_lastAccessed_analysis flaa on flaa.id = f.id
;
select * from file_consolidatedAnalysis;
/*
select a.id, a.folder, a.name, a.lastAccessedTSD, a.sizeAsString, a.sizeInBytes, a.filetype,
	a.fna_rbId, a.fna_ratio, a.fna_weight, a.fna_action,
    a.ffna_rbId, a.ffna_ratio, a.ffna_weight, a.ffna_action,
    c.rbId, c.ratio, c.weight, c.action
    from file_consolidatedAnalysis a
    join (select rbId, ratio, weight
			
            ) as c
    ;
*/
/*
set profiling = 0;
DROP TABLE IF exists file_consolidatedAverages;
set profiling = 1;
create table file_consolidatedAverages (primary key (id, recommendedAction)) as
SELECT f.id, f.folder, f.name, f.lastAccessedTSD, f.sizeAsString, f.sizeInBytes, f.filetype,
  analysis.recommendedAction,
  SUM(analysis.weighted_ratio * analysis.typeWeight) / 1000 AS weighted_average -- 1000 = / 100 % / 10 typeWeight
FROM
  file f
LEFT JOIN (
  SELECT analysis.id, analysis.recommendedAction, analysis.ratio, analysis.weight, analysis.ratio * analysis.weight AS weighted_ratio, 1 as typeWeight
  FROM file_filename_analysis AS analysis
  UNION ALL
  SELECT analysis.id, analysis.recommendedAction, analysis.ratio, analysis.weight, analysis.ratio * analysis.weight AS weighted_ratio, 2 as typeWeight
  FROM FILE_FOLDERNAME_ANALYSIS AS analysis
  UNION ALL
  SELECT analysis.id, analysis.recommendedAction, analysis.ratio, analysis.weight, analysis.ratio * analysis.weight AS weighted_ratio, 1 as typeWeight
  FROM FILE_FILETYPE_ANALYSIS AS analysis
  UNION ALL
  SELECT analysis.id, analysis.recommendedAction, analysis.ratio, analysis.weight, analysis.ratio * analysis.weight AS weighted_ratio, 3 as typeWeight
  FROM file_size_analysis AS analysis
  UNION ALL
  SELECT analysis.id, analysis.recommendedAction, analysis.ratio, analysis.weight, analysis.ratio * analysis.weight AS weighted_ratio, 3 as typeWeight
  FROM file_lastAccessed_analysis AS analysis
) AS analysis ON f.id = analysis.id
GROUP BY f.id, analysis.recommendedAction
;
*/

/*
set profiling = 0;
DROP TABLE IF exists file_consolidatedRatios;
set profiling = 1;
create table file_consolidatedRatios (primary key (id)) as
-- explain
SELECT f.*, f.fna_action as fna_recommendedAction, fna_ratio * fna_weight / 100 as fna_weighted_average --  / 100 % / 1 = summe typeWeight
		, f.ffna_action as ffna_recommendedAction, ffna_ratio * ffna_weight / 100 as ffna_weighted_average --  / 100 % / 1 = summe typeWeight
		, f.fta_action as fta_recommendedAction, fta_ratio * fta_weight / 100 as fta_weighted_average --  / 100 % / 1 = summe typeWeight
		, f.fsa_action as fsa_recommendedAction, fsa_ratio * fsa_weight / 100 as fsa_weighted_average --  / 100 % / 1 = summe typeWeight
		, f.flaa_action as flaa_recommendedAction, flaa_ratio * flaa_weight / 100 as flaa_weighted_average --  / 100 % / 1 = summe typeWeight
-- SELECT f.*, f.fna_action as fna_recommendedAction, fna_ratio * fna_weight * 1 / 100 / 9 as fna_weighted_average --  / 100 % / 1 = summe typeWeight
	-- , f.ffna_action as ffna_recommendedAction, ffna_ratio * ffna_weight * 3 / 100 / 9 as ffna_weighted_average --  / 100 % / 1 = summe typeWeight
	-- , f.fta_action as fta_recommendedAction, fta_ratio * fta_weight * 1 / 100 / 9 as fta_weighted_average --  / 100 % / 1 = summe typeWeight
	-- , f.fsa_action as fsa_recommendedAction, fsa_ratio * fsa_weight * 2 / 100 / 9 as fsa_weighted_average --  / 100 % / 1 = summe typeWeight
	-- , f.flaa_action as flaa_recommendedAction, flaa_ratio * flaa_weight * 2 / 100 / 9 as flaa_weighted_average --  / 100 % / 1 = summe typeWeight
		-- ,'10' as finalRecommendedAction, fna_weighted_average + ffna_weighted_average + fta_weighted_average + fsa_weighted_average + flaa_weighted_average as finalAverage --  / 100 % / 1 = summe typeWeight
FROM
  file_consolidatedAnalysis f
-- GROUP BY f.id, finalRecommendedAction
;
*/

/*
create table file_consolidatedAnalysis (primary key (id)) as
-- explain
select f.id, f.folder, f.name, f.lastAccessedTSD, f.sizeAsString, f.sizeInBytes, f.filetype,
		fna.ratiobasisID as 'fna_rbId', fna.ratio as 'fna_ratio', fna.weight as 'fna_weight', fna.recommendedAction as 'fna_action',
        ffna.ratiobasisID as 'ffna_rbId', ffna.ratio as 'ffna_ratio', ffna.weight as 'ffna_weight', ffna.recommendedAction as 'ffna_action',
		fta.ratiobasisID as 'fta_rbId', fta.ratio as 'fta_ratio', fta.weight as 'fta_weight', fta.recommendedAction as 'fta_action',
		fsa.ratiobasisID as 'fsa_rbId', fsa.ratio as 'fsa_ratio', fsa.weight as 'fsa_weight', fsa.recommendedAction as 'fsa_action',
		flaa.ratiobasisID as 'flaa_rbId', flaa.ratio as 'flaa_ratio', flaa.weight as 'flaa_weight', flaa.recommendedAction as 'flaa_action'
		from file f
	left join file_filename_analysis fna on fna.id = f.id
	left join FILE_FOLDERNAME_ANALYSIS ffna on ffna.id = f.id
	left join FILE_FILETYPE_ANALYSIS fta on fta.id = f.id
	left join file_size_analysis fsa on fsa.id = f.id
	left join file_lastAccessed_analysis flaa on flaa.id = f.id
;
select * from file_consolidatedAnalysis;
*/
/*
select a.id, a.folder, a.name, a.lastAccessedTSD, a.sizeAsString, a.sizeInBytes, a.filetype,
	a.fna_rbId, a.fna_ratio, a.fna_weight, a.fna_action,
    a.ffna_rbId, a.ffna_ratio, a.ffna_weight, a.ffna_action,
    c.rbId, c.ratio, c.weight, c.action
    from file_consolidatedAnalysis a
    join (select rbId, ratio, weight
			
            ) as c
    ;
*/
/*
set profiling = 0;
DROP TABLE IF exists file_consolidatedAverages;
set profiling = 1;
create table file_consolidatedAverages (primary key (id, recommendedAction)) as
SELECT f.id, f.folder, f.name, f.lastAccessedTSD, f.sizeAsString, f.sizeInBytes, f.filetype,
  analysis.recommendedAction,
  SUM(analysis.weighted_ratio * analysis.typeWeight) / 1000 AS weighted_average -- 1000 = / 100 % / 10 typeWeight
FROM
  file f
LEFT JOIN (
  SELECT analysis.id, analysis.recommendedAction, analysis.ratio, analysis.weight, analysis.ratio * analysis.weight AS weighted_ratio, 1 as typeWeight
  FROM file_filename_analysis AS analysis
  UNION ALL
  SELECT analysis.id, analysis.recommendedAction, analysis.ratio, analysis.weight, analysis.ratio * analysis.weight AS weighted_ratio, 2 as typeWeight
  FROM FILE_FOLDERNAME_ANALYSIS AS analysis
  UNION ALL
  SELECT analysis.id, analysis.recommendedAction, analysis.ratio, analysis.weight, analysis.ratio * analysis.weight AS weighted_ratio, 1 as typeWeight
  FROM FILE_FILETYPE_ANALYSIS AS analysis
  UNION ALL
  SELECT analysis.id, analysis.recommendedAction, analysis.ratio, analysis.weight, analysis.ratio * analysis.weight AS weighted_ratio, 3 as typeWeight
  FROM file_size_analysis AS analysis
  UNION ALL
  SELECT analysis.id, analysis.recommendedAction, analysis.ratio, analysis.weight, analysis.ratio * analysis.weight AS weighted_ratio, 3 as typeWeight
  FROM file_lastAccessed_analysis AS analysis
) AS analysis ON f.id = analysis.id
GROUP BY f.id, analysis.recommendedAction
;
*/
/*
set profiling = 0;
DROP TABLE IF exists file_consolidatedRatios;
set profiling = 1;
create table file_consolidatedRatios (primary key (id)) as
-- explain
SELECT f.*, f.fna_action as fna_recommendedAction, fna_ratio * fna_weight / 100 as fna_weighted_average --  / 100 % / 1 = summe typeWeight
		, f.ffna_action as ffna_recommendedAction, ffna_ratio * ffna_weight / 100 as ffna_weighted_average --  / 100 % / 1 = summe typeWeight
		, f.fta_action as fta_recommendedAction, fta_ratio * fta_weight / 100 as fta_weighted_average --  / 100 % / 1 = summe typeWeight
		, f.fsa_action as fsa_recommendedAction, fsa_ratio * fsa_weight / 100 as fsa_weighted_average --  / 100 % / 1 = summe typeWeight
		, f.flaa_action as flaa_recommendedAction, flaa_ratio * flaa_weight / 100 as flaa_weighted_average --  / 100 % / 1 = summe typeWeight
-- SELECT f.*, f.fna_action as fna_recommendedAction, fna_ratio * fna_weight * 1 / 100 / 9 as fna_weighted_average --  / 100 % / 1 = summe typeWeight
	-- , f.ffna_action as ffna_recommendedAction, ffna_ratio * ffna_weight * 3 / 100 / 9 as ffna_weighted_average --  / 100 % / 1 = summe typeWeight
	-- , f.fta_action as fta_recommendedAction, fta_ratio * fta_weight * 1 / 100 / 9 as fta_weighted_average --  / 100 % / 1 = summe typeWeight
	-- , f.fsa_action as fsa_recommendedAction, fsa_ratio * fsa_weight * 2 / 100 / 9 as fsa_weighted_average --  / 100 % / 1 = summe typeWeight
	-- , f.flaa_action as flaa_recommendedAction, flaa_ratio * flaa_weight * 2 / 100 / 9 as flaa_weighted_average --  / 100 % / 1 = summe typeWeight
		-- ,'10' as finalRecommendedAction, fna_weighted_average + ffna_weighted_average + fta_weighted_average + fsa_weighted_average + flaa_weighted_average as finalAverage --  / 100 % / 1 = summe typeWeight
FROM
  file_consolidatedAnalysis f
-- GROUP BY f.id, finalRecommendedAction
;
*/

set profiling = 0;
DROP TABLE IF exists file_consolidatedRatios;
set profiling = 1;
create table file_consolidatedRatios (primary key (id)) as
-- explain
SELECT f.id, f.folder, f.name, f.lastAccessedTSD, f.sizeAsString, f.sizeInBytes, f.filetype,
		fna.ratiobasisID as 'fna_rbId', fna.ratio as 'fna_ratio', fna.weight as 'fna_weight',
        ffna.ratiobasisID as 'ffna_rbId', ffna.ratio as 'ffna_ratio', ffna.weight as 'ffna_weight',
		fta.ratiobasisID as 'fta_rbId', fta.ratio as 'fta_ratio', fta.weight as 'fta_weight',
		fsa.ratiobasisID as 'fsa_rbId', fsa.ratio as 'fsa_ratio', fsa.weight as 'fsa_weight',
		flaa.ratiobasisID as 'flaa_rbId', flaa.ratio as 'flaa_ratio', flaa.weight as 'flaa_weight'
        , fna.recommendedAction as fna_recommendedAction, fna.ratio * fna.weight / 100 as fna_weighted_average --  / 100 % / 1 = summe typeWeight
		, ffna.recommendedAction as ffna_recommendedAction, ffna.ratio * ffna.weight / 100 as ffna_weighted_average --  / 100 % / 1 = summe typeWeight
		, fsa.recommendedAction as fta_recommendedAction, fta.ratio * fta.weight / 100 as fta_weighted_average --  / 100 % / 1 = summe typeWeight
		, fsa.recommendedAction as fsa_recommendedAction, fsa.ratio * fsa.weight / 100 as fsa_weighted_average --  / 100 % / 1 = summe typeWeight
		, flaa.recommendedAction as flaa_recommendedAction, flaa.ratio * flaa.weight / 100 as flaa_weighted_average --  / 100 % / 1 = summe typeWeight
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
add recommendation varchar(10);

DELIMITER //
DROP PROCEDURE IF EXISTS calculateConsolidatedRatios //
CREATE PROCEDURE calculateConsolidatedRatios()
BEGIN
  -- Calculate the sums and counts based on actions
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
						END
  ;
  SET SQL_SAFE_UPDATES=1;
END //
DELIMITER ;

/*
DELIMITER //
DROP PROCEDURE IF EXISTS calculateConsolidatedRatios //
CREATE PROCEDURE calculateConsolidatedRatios()
BEGIN
  -- Declare variables
  DECLARE done INT DEFAULT FALSE;
  -- Declare a variable to hold the primary key value
  DECLARE pk INT;
  DECLARE val1, val2, val3, val4, val5 INT;
  DECLARE act1, act2, act3, act4, act5 VARCHAR(10);
  DECLARE recommended VARCHAR(10);
  DECLARE Bsum INT DEFAULT 0;
  DECLARE Dsum INT DEFAULT 0;
  DECLARE Nsum INT DEFAULT 0;
  DECLARE nullCount INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT pk
								fna_recommendedAction, fna_weighted_average, 
								ffna_recommendedAction, ffna_weighted_average,
								fta_recommendedAction, fta_weighted_average,
								fsa_recommendedAction, fsa_weighted_average,
								flaa_recommendedAction, flaa_weighted_average FROM file_consolidatedRatios;
  -- Declare a cursor handler
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  -- Open the cursor
  OPEN cur;
  
  -- Loop through the rows of myTable
  read_loop: LOOP
    -- Fetch the values from the cursor
    FETCH cur INTO val1, act1, val2, act2, val3, act3, val4, act4, val5, act5;
    
    -- Check for end of cursor
    IF done THEN
      LEAVE read_loop;
    END IF;
    -- Reset the variables for each row
    SET Bsum = 0;
    SET Dsum = 0;
    SET Nsum = 0;
    SET nullCount = 0;
    
    -- Calculate the weighted average per action
    IF act1 = 'B' THEN
      SET Bsum = Bsum + val1;
    ELSEIF act1 = 'D' THEN
      SET Dsum = Dsum + val1;
    ELSEIF act1 = 'N' THEN
      SET Nsum = Nsum + val1;
    ELSE
      SET nullCount = nullCount + 1;
    END IF;
    
	IF act2 = 'B' THEN
      SET Bsum = Bsum + val2;
    ELSEIF act2 = 'D' THEN
      SET Dsum = Dsum + val2;
    ELSEIF act2 = 'N' THEN
      SET Nsum = Nsum + val2;
    ELSE
      SET nullCount = nullCount + 1;
    END IF;
    
	IF act3 = 'B' THEN
      SET Bsum = Bsum + val3;
    ELSEIF act3 = 'D' THEN
      SET Dsum = Dsum + val3;
    ELSEIF act3 = 'N' THEN
      SET Nsum = Nsum + val3;
    ELSE
      SET nullCount = nullCount + 1;
    END IF;
    
    IF act4 = 'B' THEN
      SET Bsum = Bsum + val4;
    ELSEIF act4 = 'D' THEN
      SET Dsum = Dsum + val4;
    ELSEIF act4 = 'N' THEN
      SET Nsum = Nsum + val4;
    ELSE
      SET nullCount = nullCount + 1;
    END IF;
    
    IF act5 = 'B' THEN
      SET Bsum = Bsum + val5;
    ELSEIF act5 = 'D' THEN
      SET Dsum = Dsum + val5;
    ELSEIF act5 = 'N' THEN
      SET Nsum = Nsum + val5;
    ELSE
      SET nullCount = nullCount + 1;
    END IF;
    
    -- Update myTable with the calculated values for the current row
    UPDATE file_consolidatedRatios
    -- SET recommendedAction = (SELECT action FROM outputSet WHERE weightedAverage = (SELECT MAX(weightedAverage) FROM outputSet)),
       --  assuranceValue = (SELECT weightedAverage FROM outputSet WHERE weightedAverage = (SELECT MAX(weightedAverage) FROM outputSet))
    -- WHERE id = pk;
   --  UPDATE myTable
    SET B_ratio = Bsum,
        D_ratio = Dsum,
        N_ratio = Nsum,
        no_ratio_count = nullCount
    WHERE id = pk;
  END LOOP;
  
  -- Close the cursor
  CLOSE cur;
END //
DELIMITER ;
*/

call calculateConsolidatedRatios();

select * from file_consolidatedRatios;
show profiles;

/*
DELIMITER //
CREATE FUNCTION calculateAnalysisResult(fna_weighted_average INT, ffna_weighted_average INT, fta_weighted_average INT, fsa_weighted_average INT, flaa_weighted_average INT)
RETURNS INT
BEGIN
  DECLARE result INT;
  
  SET result = coalesce(fna_weighted_average, 0) 
				+ coalesce(ffna_weighted_average, 0) 
				+ coalesce(fta_weighted_average, 0) 
				+ coalesce(fsa_weighted_average, 0) 
				+ coalesce(flaa_weighted_average, 0);
  
  RETURN result;
END //
DELIMITER ;

DELIMITER //

CREATE FUNCTION calculateOutput(
  fna_weighted_average INT,
  fnaAction VARCHAR(255),
  ffna_weighted_average INT,
  ffnaAction VARCHAR(255),
  fta_weighted_average INT,
  ftnaAction VARCHAR(255),
  fsa_weighted_average INT,
  fsaAction VARCHAR(255),
  flaa_weighted_average INT,
  flaaAction VARCHAR(255)
)
RETURNS INT
BEGIN
  DECLARE result INT;
  
  SET result = coalesce(fna_weighted_average, 0) 
				+ coalesce(ffna_weighted_average, 0) 
				+ coalesce(fta_weighted_average, 0) 
				+ coalesce(fsa_weighted_average, 0) 
				+ coalesce(flaa_weighted_average, 0);
  
  RETURN result;
END //
DELIMITER ;
set profiling = 0;
DROP TABLE IF exists file_consolidatedAverages;
set profiling = 1;
create table file_consolidatedAverages (primary key (id, finalRecommendedAction)) as
SELECT f.*,'10' as finalRecommendedAction,
	calculateAnalysisResult(fna_weighted_average, ffna_weighted_average, fta_weighted_average, fsa_weighted_average, flaa_weighted_average) as finalAverage --  / 100 % / 1 = summe typeWeight
FROM
  file_consolidatedRatios f
-- GROUP BY f.id, finalRecommendedAction
;
select * from file_consolidatedAverages;

-- select * from file_consolidatedAverages;
select count(*) from file_consolidatedanalysis;
select count(*) from file_consolidatedAverages where recommendedAction = 'B';
select count(*) from file_consolidatedAverages where recommendedAction = 'D';
select count(*) from file_consolidatedAverages where recommendedAction = 'N';
select count(*) from file_consolidatedAverages where recommendedAction not in ('B', 'D', 'N');

/*
select * from file_consolidatedAverages
	where recommendedAction != 'N'
	order by weighted_average desc
    limit 100;
/

select averages.recommendedAction, averages.weighted_average, f.*  from file_consolidatedanalysis f
 join file_consolidatedaverages averages on f.id = averages.id
 order by weighted_average desc
 limit 100
 ;
 
 select averages.recommendedAction, averages.weighted_average, f.*  from file_consolidatedanalysis f
 join file_consolidatedaverages averages on f.id = averages.id
 where averages.id = 423111
 ;
 */

show profiles;
 -- show profile for query 1;
set profiling = 0;
