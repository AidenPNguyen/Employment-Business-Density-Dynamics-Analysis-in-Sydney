#  Employment & Business Density Dynamics Analysis in Sydney

![prodema-rustik-wood-ey-centre-fjmt-01](https://github.com/user-attachments/assets/19c15dd3-2df1-4de1-ae4d-729502dbbe99)

## Table of Contents
[Project Overview](#project-overview)

[Project goals and objectives](#project-goals-and-objectives)

[About the data](#about-the-data)

[Dataset Attributes Overview](#dataset-attributes-overview)

[Tools and libraries](#️-tools-and-libraries)

[Methodology](#methodology)

- [Data preprocessing](#data-preproccessing)

- [Data Visualization](#data-visualization)

[The key insights](#the-key-insights)

[Project challenges](#project-challenges)

[Conclusion](#conclusion)

## Project Overview
The Sydney Floor Space and Employment Survey is a comprehensive study conducted every five years to track trends in business activity, employment, and floor space utilization across the City of Sydney. The survey captures a snapshot of the city's built environment and economic structure, offering valuable insights into how businesses and jobs have evolved over time

## Project Goals and Objectives
🎯 Goals:
The primary goal of this project is to analyze and visualize the relationship between business growth, employment trends, and floor space utilization in Sydney from 2007 to 2022. By leveraging SQL for data processing and Power BI for visualization, this study aims to provide valuable insights into economic shifts, workforce density, and commercial development patterns. Additionally, it seeks to assess the impact of urban expansion and industry changes on employment rates and building usage, helping policymakers, researchers, and business owners make informed decisions. ✅

🔍 Key Objectives: 
- Preprocess and clean the dataset using SQL for accurate analysis. 🛠️
- Develop interactive visualizations in Power BI to explore trends across different years. 📈
- Analyze business growth patterns, job market shifts, and commercial space utilization. 🏢
- Identify correlations between floor space availability, employment rates, and business activity. 🔗
- Evaluate the impact of economic changes (e.g., post-pandemic recovery) on Sydney’s commercial landscape. 💼

## About the Data
This dataset provides a comprehensive snapshot of Sydney’s business landscape over four survey years: 2007, 2012, 2017, and 2022. Each dataset consists of 9 columns and captures insights into business establishments, employment figures, and floor space usage across different suburbs (Floor Space and Employment Survey - City of Sydney, 2024). The number of records varies per year, with 1,117 rows in 2022, 1,103 in 2017, 1,058 in 2012, and 1,057 in 2007.📊

This structured dataset allows for an in-depth analysis of business growth, employment density, and commercial development trends. By tracking changes over time, we can assess how industries have expanded or declined, identify shifts in workforce distribution, and explore the relationship between employment density and available commercial space. The dataset serves as a valuable foundation for understanding economic shifts, urban planning strategies, and the evolving structure of Sydney’s business ecosystem.🏙️

## Dataset Attributes Overview
OBJECTID: A unique identifier for each record in the dataset.
BLOCKNUM: The unique block number representing a specific geographical area.
InternalFloorArea: The total internal floor space (measured in square meters) allocated for commercial and employment purposes.
FullTimeEmployees: The total number of full-time employees working in the block.
PartTimeEmployees: The total number of part-time employees working in the block.
TotalEmployees: The combined count of full-time and part-time employees in the block.
Businesses: The total number of businesses operating within the block.
Shape__Area: The geographic area (in square meters) of the block, representing its physical size.
Shape__Length: The perimeter length (in meters) of the block’s geographic boundary.
Perimeter(2022): The perimeter size (in meters) of the block’s geographic boundary.

## Tools and Libraries
- MySQL: Data processing and cleaning.
- Power BI: Data visualization and reporting.

## Methodology

### Data Collecting

The datasets for this analysis were collected from the City of Sydney Council’s Open Data Portal (Sydney Data Hub), which provides publicly available records on land use, planning, employment, and commercial development.

This study utilizes four datasets from the Floor Space and Employment Survey (FES), covering the years 2007, 2012, 2017, and 2022. Each dataset contains employment figures, business counts, and internal floor space utilization for different suburbs across Sydney. The data is structured consistently across all four years, allowing for seamless comparison and trend analysis.

- 2007 Floor Space and Employment Survey – 1,057 records
- 2012 Floor Space and Employment Survey – 1,058 records
- 2017 Floor Space and Employment Survey – 1,103 records
- 2022 Floor Space and Employment Survey – 1,117 records

### Data Preprocessing 
```SQL
Select * 
From  floor_space_22
Limit 20;
```
![Screenshot 2025-02-13 103936](https://github.com/user-attachments/assets/48d24610-9d67-4b7d-97c3-f0f2fec93abc)


```SQL
Select Count(*) as total_rows,
Sum(case when blocktxt is null then 1 else 0 end) as null_blocktxt,
Sum(case when internal_floorarea is null then 1 else 0 end) as null_internal_floor_area,
Sum(case when businesses is null then 1 else 0 end) as null_businesses,
Sum(case when total_jobs is null then 1 else 0 end) as null_employees,
Sum(case when perimeter is null then 1 else 0 end) as null_perimeter,
Sum(case when Shape__Area is null then 1 else 0 end) as null_Shape__Area,
Sum(case when Shape__Length is null then 1 else 0 end) as null_Shape__Length
From floor_space_22;
```
![Screenshot 2025-02-13 104257](https://github.com/user-attachments/assets/457b90df-dd6c-4faa-844f-27d07bb883bf)



```SQL
-- Renaming "OBJECTID" column
Alter table floor_space_22
Rename column ï»¿OBJECTID to Num;

-- Droping "BLOCKTXT" column
Alter table floor_space_22
DROP column BLOCKTXT;
```

```SQL
-- Checking duplicated values
Select *, count(*) as duplicated_count
From floor_space_22
Group by Num, BLOCKNUM, Total_FullTime_Jobs, Total_PartTime_Jobs, Total_Jobs, Businesses, Internal_FloorArea, PERIMETER, Shape__Area, Shape__Length
Having count(*) > 1;
```
![Screenshot 2025-02-13 110654](https://github.com/user-attachments/assets/5c52e00d-c1d3-4455-9d42-6fa64cbac411)



```SQL
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
```
![Screenshot 2025-02-13 110953](https://github.com/user-attachments/assets/7d4c6540-97a9-4271-8f47-0a3dc977de1c)



```SQL
Select * 
From  floor_space_22
Where Businesses > 50
Limit 100;

SELECT blocknum, suburb 
FROM floor_space_22
Where suburb = "Unknown"
ORDER By blocknum;
```

```SQL
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
```

### Exploratory Data Analysis (EDA)
```SQL
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
```
![Screenshot 2025-03-14 150638](https://github.com/user-attachments/assets/640765a2-33b6-4884-984e-80dbd85ff8f5)




```SQL
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
```





```SQL
ALTER TABLE floor_space_22 ADD COLUMN jobs_sqm float;

Update floor_space_22
	SET jobs_sqm = CASE 
    WHEN internal_floorarea = 0 OR internal_floorarea IS NULL OR total_jobs = 0 
    THEN 0  -- No jobs or no business, so set to 0
    ELSE ROUND(total_jobs / NULLIF(internal_floorarea, 0), 2) 
END;
```
![Screenshot 2025-02-15 094626](https://github.com/user-attachments/assets/5a999ade-0c62-4aae-9912-df789c139c99)



```SQL
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
```
![Screenshot 2025-02-15 094648](https://github.com/user-attachments/assets/581b5b4b-21e7-4301-901e-bbac445f2fa4)



```SQL
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
```
![Screenshot 2025-02-15 101309](https://github.com/user-attachments/assets/14c784a9-d647-4f22-a603-6d05c00e7cc1)




```SQL
-- Full vs part time jobs

Select 
	blocknum, suburb, total_jobs, Total_fulltime_jobs, Total_parttime_jobs
From floor_space_22
Where Total_fulltime_jobs > Total_parttime_jobs
order by Total_fulltime_jobs desc
Limit 100;
```
![Screenshot 2025-02-15 161207](https://github.com/user-attachments/assets/255ee0df-9784-4f71-b694-e05bf5e7f697)




```SQL
Select 
	blocknum, suburb, total_jobs, Total_parttime_jobs, Total_fulltime_jobs
From floor_space_22
Where Total_parttime_jobs > Total_fulltime_jobs  
order by Total_parttime_jobs desc
Limit 100;
```
![Screenshot 2025-02-15 161225](https://github.com/user-attachments/assets/a7b587d2-9205-48f3-9be0-394ca717dd13)





```SQL
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
```
![Screenshot 2025-02-20 132627](https://github.com/user-attachments/assets/b721f5af-518d-40aa-b9ac-425a18f2740f)



```SQL
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
```
![Screenshot 2025-02-20 132605](https://github.com/user-attachments/assets/57faec11-8287-4697-a952-51b3ab45e0a6)



```SQL
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
```
![Screenshot 2025-02-20 132254](https://github.com/user-attachments/assets/83931c6a-ac69-48c6-b176-9b637f1f10dd)




```SQL
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
```
![Screenshot 2025-02-20 132543](https://github.com/user-attachments/assets/1ac010d6-9d70-4def-a4bf-6df8b8f9a986)



```SQL
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
```
![Screenshot 2025-02-20 132903](https://github.com/user-attachments/assets/4ca89f64-b7c1-49ef-a4c4-11091b713f62)



```SQL
SELECT 
    fs22.blocknum,
    coalesce(fs07.totalemployees, 0) AS jobs_2007,
    coalesce(fs12.totalemployees, 0) AS jobs_2012, 
    coalesce(fs17.totalemployees, 0) AS jobs_2017, 
    fs22.total_jobs AS jobs_2022,
    fs22.suburb,
    
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
```
![Screenshot 2025-03-14 152254](https://github.com/user-attachments/assets/c9b4d728-79bc-4f15-bd3e-746f1350ae13)


### Data Visualization 


## Key Insights
Which suburbs saw the highest growth?
Did job growth match business expansion?
Was floor space expansion justified by business growth?
Which industries declined or expanded the most?

## Project Challenges
Data integration across multiple years.
Handling missing or inconsistent values.
Adjusting visual scales for fair comparisons.

## Conclusion
Summary of business and job growth trends.
Final insights and recommendations for urban planning.

## References
Floor space and employment survey - City of Sydney. (2024, November 26). City of Sydney. https://www.cityofsydney.nsw.gov.au/research-reports/floor-space-employment-survey-2022

