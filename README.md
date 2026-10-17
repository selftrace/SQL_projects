# SQL Practice 

just a collection of sql queries i wrote while practicing data analysis on hr/employee datasets. trying to dig out insights around attrition, job satisfaction, department stats and employee demographics.

---

## Project Overview

the goal here was simple: practice basic to intermediate sql concepts using realistic hr data. I wrote queries to clean, group and slice data to answer real business-style questions—like why people leave, who's the most satisfied and how education/travel impacts job satisfaction.

---

## Key SQL Concepts Used

*   **Aggregations & grouping:** `COUNT()`, `AVG()`, `SUM()`, `GROUP BY`
*   **Conditional logic:** `CASE WHEN` statements to calculate custom metrics (like attrition rate %)
*   **Filtering & sorting:** `WHERE`, `ORDER BY`, `LIMIT`
*   **Data exploration:** Filtering by specific attributes like marital status and business travel frequency

## Breakdown of what each query in `Analyzing Employee Trends.sql` is doing:

### 1. Department headcounts & demographics
*   **Count employees per department:** basic grouping to see department sizes.
*   **Average age per department:** checking age distributions across teams.
*   **Most common job roles:** ranks job roles in every department by total count.

### 2. Job satisfaction insights
*   **Satisfaction by education level:** looks at whether higher education correlates with better job satisfaction.
*   **Satisfaction vs. age:** finds average age per satisfaction score level.
*   **Top/Bottom satisfaction departments:** grabs the single highest (or lowest) department by satisfaction rating.
*   **Frequent travelers:** highlights top 3 education levels with the highest average satisfaction among employees who travel frequently for work.
*   **Married employees:** identifies which age group has the highest job satisfaction among married staff.

### 3. Attrition rate analysis
*   **Attrition by age band:** uses `CASE WHEN` to calculate the exact percentage of people who left within each age group.
*   **Highest attrition breakdown:** pinpoints the exact combination of education level and age band with the worst attrition rate.
