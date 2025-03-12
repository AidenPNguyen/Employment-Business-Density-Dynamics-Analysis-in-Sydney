-- Data Cleaning

Desc floor_space_22;

Select * 
From  floor_space_22
Limit 20;
-- Checking null values

Select Count(*) as total_rows,
Sum(case when blocktxt is null then 1 else 0 end) as null_blocktxt,
Sum(case when internal_floorarea is null then 1 else 0 end) as null_internal_floor_area,
Sum(case when businesses is null then 1 else 0 end) as null_businesses,
Sum(case when total_jobs is null then 1 else 0 end) as null_employees,
Sum(case when perimeter is null then 1 else 0 end) as null_perimeter,
Sum(case when Shape__Area is null then 1 else 0 end) as null_Shape__Area,
Sum(case when Shape__Length is null then 1 else 0 end) as null_Shape__Length
From floor_space_22;

-- Renaming "OBJECTID" column
Alter table floor_space_22
Rename column ï»¿OBJECTID to Num;

-- Droping "BLOCKTXT" column
Alter table floor_space_22
DROP column BLOCKTXT;

-- Checking duplicated values
Select *, count(*) as duplicated_count
From floor_space_22
Group by Num, BLOCKNUM, Total_FullTime_Jobs, Total_PartTime_Jobs, Total_Jobs, Businesses, Internal_FloorArea, PERIMETER, Shape__Area, Shape__Length
Having count(*) > 1;

-- Adding column
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE floor_space_22 ADD COLUMN suburb VARCHAR(50);

UPDATE floor_space_22
SET suburb = 
    CASE 
        WHEN blocknum BETWEEN 1000 AND 1199 THEN 'Alexandria'
        WHEN blocknum BETWEEN 1200 AND 1299 OR blocknum BETWEEN 1073 AND 1078 THEN 'Zetland'
        WHEN blocknum BETWEEN 300 AND 357 THEN 'Pott Point'
        WHEN blocknum BETWEEN 370 AND 399 THEN 'Moore Park'
        WHEN blocknum BETWEEN 1 AND 241 OR blocknum BETWEEN 1370 AND 1376 THEN 'Sydney CBD'
        WHEN blocknum BETWEEN 900 AND 999 OR blocknum BETWEEN 839 AND 845 THEN 'Glebe'
        WHEN blocknum BETWEEN 800 AND 899 THEN 'Camperdown'
        WHEN blocknum BETWEEN 400 AND 599 THEN 'Darlinghurst and Surry Hill'
        WHEN blocknum BETWEEN 600 AND 799 THEN 'Redfern, Erskineville and Macdonaldtown'
        WHEN blocknum BETWEEN 1300 AND 1410 THEN 'Redfern, Erskineville and Macdonaldtown'
        ELSE 'Unknown'
    END;
    
Select * 
From  floor_space_22
Where Businesses > 50
Limit 100;

SELECT blocknum, suburb 
FROM floor_space_22
Where suburb = "Unknown"
ORDER By blocknum;

UPDATE floor_space_22
SET suburb = 
    CASE  
        WHEN blocknum BETWEEN 1000 AND 1199 THEN 'Alexandria'
        WHEN blocknum BETWEEN 1200 AND 1299 OR blocknum BETWEEN 1073 AND 1078 THEN 'Zetland'
        WHEN blocknum BETWEEN 0300 AND 0357 THEN 'Pott Point'
        WHEN blocknum BETWEEN 0370 AND 0399 OR blocknum BETWEEN 0360 AND 0363 THEN 'Moore Park'
        WHEN blocknum BETWEEN 0001 AND 0241 OR blocknum BETWEEN 1370 AND 1376 THEN 'Sydney CBD'
        WHEN blocknum BETWEEN 0900 AND 0999 OR blocknum BETWEEN 0839 AND 0845 THEN 'Glebe'
        WHEN blocknum BETWEEN 0800 AND 0899 THEN 'Camperdown'
        WHEN blocknum BETWEEN 0400 AND 0599 THEN 'Darlinghurst and Surry Hill'
        WHEN blocknum BETWEEN 0600 AND 0799 THEN 'Redfern, Erskineville and Macdonaldtown'
        WHEN blocknum BETWEEN 1300 AND 1410 THEN 'Redfern, Erskineville and Macdonaldtown'
        ELSE 'Unknown'  
    END;

-- Statistical analysis
-- Min, max, avg floor area
SELECT 'Min Internal Floor Area' AS attribute, MIN(internal_floorarea) AS value FROM floor_space_22
UNION ALL
SELECT 'Max Internal Floor Area', MAX(internal_floorarea) FROM floor_space_22
UNION ALL
SELECT 'Avg Internal Floor Area', AVG(internal_floorarea) FROM floor_space_22
UNION ALL
SELECT 'Min Block', MIN(blocknum) FROM floor_space_22
UNION ALL
SELECT 'Max Block', MAX(blocknum) FROM floor_space_22
UNION ALL
SELECT 'Avg Block', AVG(blocknum) FROM floor_space_22
UNION ALL
SELECT 'Min Part-Time Jobs', MIN(total_parttime_jobs) FROM floor_space_22
UNION ALL
SELECT 'Max Part-Time Jobs', MAX(total_parttime_jobs) FROM floor_space_22
UNION ALL
SELECT 'Avg Part-Time Jobs', AVG(total_parttime_jobs) FROM floor_space_22
UNION ALL
SELECT 'Min Full-Time Jobs', MIN(total_fulltime_jobs) FROM floor_space_22
UNION ALL
SELECT 'Max Full-Time Jobs', MAX(total_fulltime_jobs) FROM floor_space_22
UNION ALL
SELECT 'Avg Full-Time Jobs', AVG(total_fulltime_jobs) FROM floor_space_22
UNION ALL
SELECT 'Min Total Jobs', MIN(total_jobs) FROM floor_space_22
UNION ALL
SELECT 'Max Total Jobs', MAX(total_jobs) FROM floor_space_22
UNION ALL
SELECT 'Avg Total Jobs', AVG(total_jobs) FROM floor_space_22
UNION ALL
SELECT 'Min Businesses', MIN(businesses) FROM floor_space_22
UNION ALL
SELECT 'Max Businesses', MAX(businesses) FROM floor_space_22
UNION ALL
SELECT 'Avg Businesses', AVG(businesses) FROM floor_space_22
UNION ALL
SELECT 'Min Perimeter', MIN(perimeter) FROM floor_space_22
UNION ALL
SELECT 'Max Perimeter', MAX(perimeter) FROM floor_space_22
UNION ALL
SELECT 'Avg Perimeter', AVG(perimeter) FROM floor_space_22;

-- internal floor area vs jobs.
Select
	internal_floorarea,
    PERIMETER,
	total_jobs,
    businesses,
    round(total_jobs/internal_floorarea, 2) as jobs_per_sqm
From floor_space_22
Where internal_floorarea > 0
Order by jobs_per_sqm desc
Limit 20;

ALTER TABLE floor_space_22 ADD COLUMN jobs_sqm float;

Update floor_space_22
	SET jobs_sqm = CASE 
    WHEN internal_floorarea = 0 OR internal_floorarea IS NULL OR total_jobs = 0 
    THEN 0  -- No jobs or no business, so set to 0
    ELSE ROUND(total_jobs / NULLIF(internal_floorarea, 0), 2) 
END;

-- internal floor area vs jobs correlation
SELECT 
    ROUND(
        (SUM(internal_floorarea * total_jobs) - (SUM(internal_floorarea) * SUM(total_jobs)) / COUNT(*)) /
        (SQRT(
            (SUM(internal_floorarea * internal_floorarea) - (SUM(internal_floorarea) * SUM(internal_floorarea)) / COUNT(*)) * 
            (SUM(total_jobs * total_jobs) - (SUM(total_jobs) * SUM(total_jobs)) / COUNT(*))
        ))
    , 2) AS floor_jobs_corr,

    ROUND(
        (SUM(internal_floorarea * businesses) - (SUM(internal_floorarea) * SUM(businesses)) / COUNT(*)) /
        (SQRT(
            (SUM(internal_floorarea * internal_floorarea) - (SUM(internal_floorarea) * SUM(internal_floorarea)) / COUNT(*)) * 
            (SUM(businesses * businesses) - (SUM(businesses) * SUM(businesses)) / COUNT(*))
        ))
    , 2) AS floor_businesses_corr
    
-- Suburb vs Jobs & businesses

FROM floor_space_22;

Select
	suburb,
	Sum(total_jobs),
    sum(businesses),
	round(avg(internal_floorarea), 2) as avg_floorarea
From floor_space_22
Group by suburb
order by sum(total_jobs) desc;

-- Full vs part time jobs

Select 
	blocknum, suburb, total_jobs, Total_fulltime_jobs, Total_parttime_jobs
From floor_space_22
Where Total_fulltime_jobs > Total_parttime_jobs
order by Total_fulltime_jobs desc
Limit 20;

Select 
	blocknum, suburb, total_jobs, Total_parttime_jobs, Total_fulltime_jobs
From floor_space_22
Where Total_parttime_jobs > Total_fulltime_jobs  
order by Total_parttime_jobs desc
Limit 20;

SELECT 
    floor_space_22.blocknum, 
    floor_space_07.PartTimeEmployees AS parttime_2007,
    floor_space_12.PartTimeEmployees AS parttime_2012,
    floor_space_17.PartTimeEmployees AS parttime_2017,
    floor_space_22.Total_PartTime_Jobs AS parttime_2022, 
    CONCAT(ROUND(COALESCE((floor_space_22.Total_PartTime_Jobs - floor_space_07.PartTimeEmployees) / NULLIF(floor_space_07.PartTimeEmployees, 1) * 100, 0), 1), '%') AS parttimejob_growth_2007_2022_pct,
    floor_space_22.suburb
FROM floor_space_22
INNER JOIN floor_space_17 ON floor_space_22.blocknum = floor_space_17.blocknum
INNER JOIN floor_space_12 ON floor_space_22.blocknum = floor_space_12.blocknum
INNER JOIN floor_space_07 ON floor_space_22.blocknum = floor_space_07.blocknum
ORDER BY blocknum, suburb;

SELECT 
    floor_space_22.blocknum, 
    floor_space_07.FullTimeEmployees AS fulltime_2007,
    floor_space_12.FullTimeEmployees AS fulltime_2012,
    floor_space_17.FullTimeEmployees AS fulltime_2017,
    floor_space_22.Total_FullTime_Jobs AS fulltime_2022,
    CONCAT(ROUND(COALESCE((floor_space_22.Total_FullTime_Jobs - floor_space_07.FullTimeEmployees) / NULLIF(floor_space_07.FullTimeEmployees, 1) * 100, 0), 1), '%') AS fulltimejob_growth_2007_2022_pct,
    floor_space_22.suburb
FROM floor_space_22
INNER JOIN floor_space_17 ON floor_space_22.blocknum = floor_space_17.blocknum
INNER JOIN floor_space_12 ON floor_space_22.blocknum = floor_space_12.blocknum
INNER JOIN floor_space_07 ON floor_space_22.blocknum = floor_space_07.blocknum
ORDER BY blocknum, suburb;

SELECT 
    floor_space_22.blocknum, 
    floor_space_07.TotalEmployees AS total_jobs_2007,
    floor_space_12.TotalEmployees AS total_jobs_2012,
    floor_space_17.TotalEmployees AS total_jobs_2017,
    floor_space_22.total_jobs as total_jobs_2022,
    CONCAT(ROUND(COALESCE((floor_space_22.Total_Jobs - floor_space_07.TotalEmployees) / NULLIF(floor_space_07.TotalEmployees, 1) * 100, 0), 1), '%') AS Totaljob_growth_2007_2022_pct,
    floor_space_22.suburb
FROM floor_space_22
INNER JOIN floor_space_17 ON floor_space_22.blocknum = floor_space_17.blocknum
INNER JOIN floor_space_12 ON floor_space_22.blocknum = floor_space_12.blocknum
INNER JOIN floor_space_07 ON floor_space_22.blocknum = floor_space_07.blocknum
ORDER BY blocknum, suburb;

SELECT 
    floor_space_22.blocknum, 
    floor_space_07.InternalFloorArea AS total_space_2007,
    floor_space_12.InternalFloorArea AS total_space_2012,
    floor_space_17.InternalFloorArea AS total_space_2017,
    floor_space_22.Internal_FloorArea AS total_space_2022,
    CONCAT(ROUND(COALESCE((floor_space_22.Internal_FloorArea - floor_space_07.InternalFloorArea) / NULLIF(floor_space_07.InternalFloorArea, 1) * 100, 0), 1), '%') AS floorspace_growth_2007_2022_pct,
    floor_space_22.suburb
FROM floor_space_22
INNER JOIN floor_space_17 ON floor_space_22.blocknum = floor_space_17.blocknum
INNER JOIN floor_space_12 ON floor_space_22.blocknum = floor_space_12.blocknum
INNER JOIN floor_space_07 ON floor_space_22.blocknum = floor_space_07.blocknum
ORDER BY blocknum, suburb;

SELECT 
    floor_space_22.blocknum, 
    floor_space_07.Businesses AS total_businesses_2007,
    floor_space_12.Businesses AS total_businesses_2012,
    floor_space_17.Businesses AS total_businesses_2017,
    floor_space_22.Businesses AS total_businesses_2022,
    CONCAT(ROUND(COALESCE((floor_space_22.Businesses - floor_space_07.Businesses) / NULLIF(floor_space_07.Businesses, 1) * 100, 0), 1), '%') AS floorspace_growth_2007_2022_pct,
    floor_space_22.suburb
FROM floor_space_22
INNER JOIN floor_space_17 ON floor_space_22.blocknum = floor_space_17.blocknum
INNER JOIN floor_space_12 ON floor_space_22.blocknum = floor_space_12.blocknum
INNER JOIN floor_space_07 ON floor_space_22.blocknum = floor_space_07.blocknum
ORDER BY blocknum, suburb;


SELECT 
    fs22.blocknum,
    coalesce(fs07.totalemployees, 0) AS jobs_2007,
    coalesce(fs12.totalemployees, 0) AS jobs_2012, 
    coalesce(fs17.totalemployees, 0) AS jobs_2017, 
    fs22.total_jobs AS jobs_2022,
    
   CASE 
        WHEN COALESCE(fs07.totalemployees, 0) = 0 
             THEN CONCAT((fs22.total_jobs - 0), '%') -- Growth relative to new jobs
        ELSE CONCAT(ROUND(((fs22.total_jobs - fs07.totalemployees) / fs07.totalemployees) * 100, 1), '%')
    END AS totaljob_growth_2007_2022,
    case
        WHEN (fs22.total_jobs > fs17.totalemployees AND fs17.totalemployees > fs12.totalemployees AND fs12.totalemployees > fs07.totalemployees)
        THEN 'Consistent Growth'
        ELSE 'Fluctuating'
    END AS growth_pattern
FROM floor_space_22 fs22
LEFT JOIN floor_space_17 fs17 ON fs22.blocknum = fs17.blocknum
LEFT JOIN floor_space_12 fs12 ON fs22.blocknum = fs12.blocknum
LEFT JOIN floor_space_07 fs07 ON fs22.blocknum = fs07.blocknum
ORDER BY jobs_2022 DESC;


Select * 
from floor_space_22;



























        

    

    







