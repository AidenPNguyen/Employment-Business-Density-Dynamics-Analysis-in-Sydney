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
### Exploratory Data Analysis (EDA)

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

