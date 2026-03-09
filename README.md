World Layoffs Data Cleaning & Analysis Project
This project focuses on the comprehensive cleaning and exploratory data analysis (EDA) of a global layoffs dataset using MySQL. The goal was to transform a raw, unorganized dataset into a structured format suitable for identifying trends in corporate workforce reductions between 2020 and 2023.

Project Overview
The workflow is divided into two main SQL scripts:

Data Cleaning (Data_Cleaning_World_layoff_data.sql): Handling duplicates, standardizing inconsistent text, fixing data types, and managing null values.

Exploratory Data Analysis (layoff_eda.sql): Identifying high-impact layoffs by company, industry, and country, as well as performing time-series analysis.

Key Technical Achievements
1. Data Cleaning & Standardization
To ensure data integrity, the raw data was never modified directly; instead, staged copies (layoffs_copy and layoffs_copy2) were used.

Duplicate Removal: Implemented ROW_NUMBER() within a Common Table Expression (CTE) to identify and delete rows with identical attributes.

Text Normalization:

Used TRIM() to remove leading/trailing whitespace.

Standardized synonymic values (e.g., merging various "Crypto" variations).

Cleaned trailing punctuation in regional columns (e.g., "United States." to "United States").

Schema Optimization: Converted the date column from a string format to a proper DATE type using STR_TO_DATE() to allow for time-based calculations.

Missing Data Management: Populated missing industry values by performing a Self-Join, matching records where the same company had the industry populated in other rows.

2. Exploratory Data Analysis (EDA)
The analysis provides insights into the scale and timing of global layoffs:

Aggregated Metrics: Calculated total layoffs and ranking by company, industry, and nation.

Time-Series Analysis:

Examined layoffs by year and month to identify peak reduction periods.

Created a Rolling Total of layoffs over time using window functions to visualize the cumulative impact.

Top Performer Ranking: Utilized DENSE_RANK() to identify the top 5 companies with the highest layoffs for each specific year.

Tools Used
Database: MySQL

SQL Techniques: CTEs, Window Functions (ROW_NUMBER, DENSE_RANK), Self-Joins, String Manipulation, and Data Type Casting.

How to Use
Import the raw layoffs CSV into your MySQL environment as a table named layoffs.

Run the Data_Cleaning_World_layoff_data.sql script to generate the cleaned layoffs_copy2 table.

Execute layoff_eda.sql to view the analysis and trends.
