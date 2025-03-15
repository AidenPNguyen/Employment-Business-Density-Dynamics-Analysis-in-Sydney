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
-- Input data checking 
Select * 
From  floor_space_22
Limit 20;
```
![Screenshot 2025-02-13 103936](https://github.com/user-attachments/assets/48d24610-9d67-4b7d-97c3-f0f2fec93abc)

Firstly, the dataset is checked to ensure that MySQL has installed the dataset properly.

```SQL
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
```
![Screenshot 2025-02-13 104257](https://github.com/user-attachments/assets/457b90df-dd6c-4faa-844f-27d07bb883bf)



```SQL
-- Renaming "OBJECTID" column
Alter table floor_space_22
Rename column ï»¿OBJECTID to Num;

-- Droping "BLOCKTXT" column
Alter table floor_space_22
Drop column BLOCKTXT;
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
Set sql_safe_updates = 0;
Alter table floor_space_22 add column suburb varchar(50);

Update floor_space_22
Set suburb = 
    Case 
        When blocknum between 1000 and 1199 then 'Alexandria'
        When blocknum between 1200 and 1299 or blocknum between 1073 and 1078 then 'Zetland'
        When blocknum between 300 and 357 then 'Pott Point'
        When blocknum between 370 and 399 then 'Moore Park'
        When blocknum between 1 and 241 or blocknum between 1370 and 1376 then 'Sydney Cbd'
        When blocknum between 900 and 999 or blocknum between 839 and 845 then 'Glebe'
        When blocknum between 800 and 899 then 'Camperdown'
        When blocknum between 400 and 599 then 'Darlinghurst And Surry Hill'
        When blocknum between 600 and 799 then 'Redfern, Erskineville And Macdonaldtown'
        When blocknum between 1300 and 1410 then 'Redfern, Erskineville And Macdonaldtown'
        Else 'Unknown'
    End;
```
![Screenshot 2025-02-13 110953](https://github.com/user-attachments/assets/7d4c6540-97a9-4271-8f47-0a3dc977de1c)



```SQL
-- Checking for "Unknown" values in suburb column
Select * 
From  floor_space_22
Where Businesses > 50
Limit 100;

Select blocknum, suburb 
From floor_space_22
Where suburb = "Unknown"
Order By blocknum;
```

```SQL
Update floor_space_22
Set suburb = 
    Case  
        When blocknum between 1000 and 1199 then 'Alexandria'
        When blocknum between 1200 and 1299 or blocknum between 1073 and 1078 then 'Zetland'
        When blocknum between 0300 and 0357 then 'Pott Point'
        When blocknum between 0370 and 0399 or blocknum between 0360 and 0363 then 'Moore Park'
        When blocknum between 0001 and 0241 or blocknum between 1370 and 1376 then 'Sydney Cbd'
        When blocknum between 0900 and 0999 or blocknum between 0839 and 0845 then 'Glebe'
        When blocknum between 0800 and 0899 then 'Camperdown'
        When blocknum between 0400 and 0599 then 'Darlinghurst And Surry Hill'
        When blocknum between 0600 and 0799 then 'Redfern, Erskineville And Macdonaldtown'
        When blocknum between 1300 and 1410 then 'Redfern, Erskineville And Macdonaldtown'
        Else 'Unknown'  
    End;
```

### Exploratory Data Analysis (EDA)
```SQL
-- Statistical analysis (min, max, mean value and standard deviation)
Select 'Min Internal Floor Area' as attribute, Min(internal_floorarea) as value from floor_space_22
Union all
Select 'Max Internal Floor Area', Max(internal_floorarea) from floor_space_22
Union all
Select 'Avg Internal Floor Area', Avg(internal_floorarea) from floor_space_22
Union all
Select 'Min Internal Floor Area' as attribute, Stddev_samp(internal_floorarea) as value from floor_space_22
Union all
Select 'Min Block', Min(blocknum) from floor_space_22
Union all
Select 'Max Block', Max(blocknum) from floor_space_22
Union all
Select 'Avg Block', Avg(blocknum) from floor_space_22
Union all
Select 'Min Internal Floor Area' as attribute, Stddev_samp(blocknum) as value from floor_space_22
Union all
Select 'Min Part-Time Jobs', Min(total_parttime_jobs) from floor_space_22
Union all
Select 'Max Part-Time Jobs', Max(total_parttime_jobs) from floor_space_22
Union all
Select 'Avg Part-Time Jobs', Avg(total_parttime_jobs) from floor_space_22
Union all
Select 'Min Internal Floor Area' as attribute, Stddev_samp(total_parttime_jobs) as value from floor_space_22
Union all
Select 'Min Full-Time Jobs', Min(total_fulltime_jobs) from floor_space_22
Union all
Select 'Max Full-Time Jobs', Max(total_fulltime_jobs) from floor_space_22
Union all
Select 'Avg Full-Time Jobs', Avg(total_fulltime_jobs) from floor_space_22
Union all
Select 'Min Internal Floor Area' as attribute, Stddev_samp(total_fulltime_jobs) as value from floor_space_22
Union all
Select 'Min Total Jobs', Min(total_jobs) from floor_space_22
Union all
Select 'Max Total Jobs', Max(total_jobs) from floor_space_22
Union all
Select 'Avg Total Jobs', Avg(total_jobs) from floor_space_22
Union all
Select 'Min Internal Floor Area' as attribute, Stddev_samp(total_jobs) as value from floor_space_22
Union all
Select 'Min Businesses', Min(businesses) from floor_space_22
Union all
Select 'Max Businesses', Max(businesses) from floor_space_22
Union all
Select 'Avg Businesses', Avg(businesses) from floor_space_22
Union all
Select 'Min Internal Floor Area' as attribute, Stddev_samp(businesses) as value from floor_space_22
Union all
Select 'Min Perimeter', Min(perimeter) from floor_space_22
Union all
Select 'Max Perimeter', Max(perimeter) from floor_space_22
Union all
Select 'Avg Perimeter', Avg(perimeter) from floor_space_22
Union all
Select 'Min Internal Floor Area' as attribute, Stddev_samp(perimeter) as value from floor_space_22;
```
![Screenshot 2025-03-14 153856](https://github.com/user-attachments/assets/5edf9052-8dbb-4ede-a155-316aab201ac9)




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
Alter table floor_space_22 ADD COLUMN jobs_sqm float;

Update floor_space_22
	Set jobs_sqm = CASE 
    When internal_floorarea = 0 OR internal_floorarea Is null or total_jobs = 0 
    Then 0  -- No jobs or no business, so set to 0
    Else Round(total_jobs / NULLIF(internal_floorarea, 0), 2) 
End;
```
![Screenshot 2025-02-15 094626](https://github.com/user-attachments/assets/5a999ade-0c62-4aae-9912-df789c139c99)



```SQL
-- Internal floor area vs jobs correlation
Select 
    Round(
        (Sum(internal_floorarea * total_jobs) - (Sum(internal_floorarea) * Sum(total_jobs)) / Count(*)) /
        (Sqrt(
            (Sum(internal_floorarea * internal_floorarea) - (Sum(internal_floorarea) * Sum(internal_floorarea)) / Count(*)) * 
            (Sum(total_jobs * total_jobs) - (Sum(total_jobs) * Sum(total_jobs)) / Count(*))
        ))
    , 2) as floor_jobs_corr,

    Round(
        (Sum(internal_floorarea * businesses) - (Sum(internal_floorarea) * Sum(businesses)) / Count(*)) /
        (Sqrt(
            (Sum(internal_floorarea * internal_floorarea) - (Sum(internal_floorarea) * Sum(internal_floorarea)) / Count(*)) * 
            (Sum(businesses * businesses) - (Sum(businesses) * Sum(businesses)) / Count(*))
        ))
    , 2) as floor_businesses_corr;
```
![Screenshot 2025-02-15 094648](https://github.com/user-attachments/assets/581b5b4b-21e7-4301-901e-bbac445f2fa4)



```SQL
-- Suburb vs Jobs & businesses

From floor_space_22;

Select
	suburb,
	Sum(total_jobs),
    Sum(businesses),
	Round(avg(internal_floorarea), 2) as avg_floorarea
From floor_space_22
Group by suburb
Order by sum(total_jobs) desc;
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
Select
    floor_space_22.blocknum, 
    floor_space_07.PartTimeEmployees AS parttime_2007,
    floor_space_12.PartTimeEmployees AS parttime_2012,
    floor_space_17.PartTimeEmployees AS parttime_2017,
    floor_space_22.Total_PartTime_Jobs AS parttime_2022, 
    Concat(Round(Coalesce((floor_space_22.Total_PartTime_Jobs - floor_space_07.PartTimeEmployees) / NULLIF(floor_space_07.PartTimeEmployees, 1) * 100, 0), 1), '%') AS parttimejob_growth_2007_2022_pct,
    floor_space_22.suburb
From floor_space_22
Inner join floor_space_17 ON floor_space_22.blocknum = floor_space_17.blocknum
Inner join floor_space_12 ON floor_space_22.blocknum = floor_space_12.blocknum
Inner join floor_space_07 ON floor_space_22.blocknum = floor_space_07.blocknum
Order by blocknum, suburb;
```
![Screenshot 2025-02-20 132627](https://github.com/user-attachments/assets/b721f5af-518d-40aa-b9ac-425a18f2740f)



```SQL
Select 
    floor_space_22.blocknum, 
    floor_space_07.FullTimeEmployees AS fulltime_2007,
    floor_space_12.FullTimeEmployees AS fulltime_2012,
    floor_space_17.FullTimeEmployees AS fulltime_2017,
    floor_space_22.Total_FullTime_Jobs AS fulltime_2022,
    Concat(Round(Coalesce((floor_space_22.Total_FullTime_Jobs - floor_space_07.FullTimeEmployees) / NULLIF(floor_space_07.FullTimeEmployees, 1) * 100, 0), 1), '%') AS fulltimejob_growth_2007_2022_pct,
    floor_space_22.suburb
From floor_space_22
Inner join floor_space_17 ON floor_space_22.blocknum = floor_space_17.blocknum
Inner join floor_space_12 ON floor_space_22.blocknum = floor_space_12.blocknum
Inner join floor_space_07 ON floor_space_22.blocknum = floor_space_07.blocknum
Order by blocknum, suburb;
```
![Screenshot 2025-02-20 132605](https://github.com/user-attachments/assets/57faec11-8287-4697-a952-51b3ab45e0a6)



```SQL
Select 
    floor_space_22.blocknum, 
    floor_space_07.TotalEmployees AS total_jobs_2007,
    floor_space_12.TotalEmployees AS total_jobs_2012,
    floor_space_17.TotalEmployees AS total_jobs_2017,
    floor_space_22.total_jobs as total_jobs_2022,
    Concat(Round(Coalesce((floor_space_22.Total_Jobs - floor_space_07.TotalEmployees) / NULLIF(floor_space_07.TotalEmployees, 1) * 100, 0), 1), '%') AS Totaljob_growth_2007_2022_pct,
    floor_space_22.suburb
From floor_space_22
Inner join floor_space_17 ON floor_space_22.blocknum = floor_space_17.blocknum
Inner join floor_space_12 ON floor_space_22.blocknum = floor_space_12.blocknum
Inner join floor_space_07 ON floor_space_22.blocknum = floor_space_07.blocknum
Order by blocknum, suburb;
```
![Screenshot 2025-02-20 132254](https://github.com/user-attachments/assets/83931c6a-ac69-48c6-b176-9b637f1f10dd)




```SQL
Select
    floor_space_22.blocknum, 
    floor_space_07.InternalFloorArea AS total_space_2007,
    floor_space_12.InternalFloorArea AS total_space_2012,
    floor_space_17.InternalFloorArea AS total_space_2017,
    floor_space_22.Internal_FloorArea AS total_space_2022,
    Concat(Round(Coalesce((floor_space_22.Internal_FloorArea - floor_space_07.InternalFloorArea) / NULLIF(floor_space_07.InternalFloorArea, 1) * 100, 0), 1), '%') AS floorspace_growth_2007_2022_pct,
    floor_space_22.suburb
From floor_space_22
Inner join floor_space_17 ON floor_space_22.blocknum = floor_space_17.blocknum
Inner join floor_space_12 ON floor_space_22.blocknum = floor_space_12.blocknum
Inner join floor_space_07 ON floor_space_22.blocknum = floor_space_07.blocknum
Order by blocknum, suburb;
```
![Screenshot 2025-02-20 132543](https://github.com/user-attachments/assets/1ac010d6-9d70-4def-a4bf-6df8b8f9a986)



```SQL
Select
    floor_space_22.blocknum, 
    floor_space_07.Businesses AS total_businesses_2007,
    floor_space_12.Businesses AS total_businesses_2012,
    floor_space_17.Businesses AS total_businesses_2017,
    floor_space_22.Businesses AS total_businesses_2022,
    Concat(Round(Coalesce((floor_space_22.Businesses - floor_space_07.Businesses) / NULLIF(floor_space_07.Businesses, 1) * 100, 0), 1), '%') AS floorspace_growth_2007_2022_pct,
    floor_space_22.suburb
From floor_space_22
Inner join floor_space_17 ON floor_space_22.blocknum = floor_space_17.blocknum
Inner join floor_space_12 ON floor_space_22.blocknum = floor_space_12.blocknum
Inner join floor_space_07 ON floor_space_22.blocknum = floor_space_07.blocknum
Order by blocknum, suburb;
```
![Screenshot 2025-02-20 132903](https://github.com/user-attachments/assets/4ca89f64-b7c1-49ef-a4c4-11091b713f62)



```SQL
Select 
    fs22.blocknum,
    Coalesce(fs07.totalemployees, 0) as jobs_2007,
    Coalesce(fs12.totalemployees, 0) as jobs_2012, 
    Coalesce(fs17.totalemployees, 0) as jobs_2017, 
    fs22.total_jobs as jobs_2022,
    fs22.suburb,
    
    Case 
        When Coalesce(fs07.totalemployees, 0) = 0 
             Then Concat((fs22.total_jobs - 0), '%') -- Growth relative to new jobs
        Else Concat(Round(((fs22.total_jobs - fs07.totalemployees) / fs07.totalemployees) * 100, 1), '%')
    End as totaljob_growth_2007_2022,
    Case
        When (fs22.total_jobs > fs17.totalemployees and fs17.totalemployees > fs12.totalemployees and fs12.totalemployees > fs07.totalemployees)
        Then 'Consistent Growth'
        Else 'Fluctuating'
    End as growth_pattern
From floor_space_22 fs22
Left join floor_space_17 fs17 on fs22.blocknum = fs17.blocknum
Left join floor_space_12 fs12 on fs22.blocknum = fs12.blocknum
Left join floor_space_07 fs07 on fs22.blocknum = fs07.blocknum
Order by jobs_2022 desc;
```
![Screenshot 2025-03-14 152254](https://github.com/user-attachments/assets/c9b4d728-79bc-4f15-bd3e-746f1350ae13)


### Data Visualization 

![Screenshot 2025-03-12 125149](https://github.com/user-attachments/assets/566b1076-8eed-426b-9a17-85f6a873c52b)



![Screenshot 2025-03-12 125258](https://github.com/user-attachments/assets/3f481ead-c219-4e17-90dc-68de9a60b07e)



![Screenshot 2025-03-12 125325](https://github.com/user-attachments/assets/97c7a8b8-7a09-4110-82f0-e3f3e1aefe19)



![Screenshot 2025-03-15 113710](https://github.com/user-attachments/assets/fc662122-0e60-4bca-bb55-4cdc166c0d38)



![Screenshot 2025-03-12 125619](https://github.com/user-attachments/assets/2d6b9bde-df1b-46dd-816b-439c42564cb6)



![Screenshot 2025-03-12 125726](https://github.com/user-attachments/assets/156e2e69-2815-41ae-82cf-0e744f7269f0)



![Screenshot 2025-03-15 131734](https://github.com/user-attachments/assets/1c8550b7-d152-41f7-879c-3f1709bac6f6)



![Screenshot 2025-03-12 125756](https://github.com/user-attachments/assets/af5bd3f6-78aa-45e0-b91b-f9b19146a9c6)


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

