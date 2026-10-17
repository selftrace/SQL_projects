USE hr_data;

-- ============================================================
-- 1. OVERALL HR METRICS & DASHBOARD KPIs
-- ============================================================

-- high-level snapshot: total headcount, active staff, ex-staff, and overall attrition %
SELECT 
    COUNT(*) AS total_employees,
    SUM(active_employee) AS active_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS total_attrition,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS overall_attrition_rate
FROM hrdata;


-- ============================================================
-- 2. DEPARTMENT & ROLE BREAKDOWNS
-- ============================================================

-- headcount and average age per department
SELECT 
    department, 
    COUNT(*) AS employee_count,
    ROUND(AVG(age), 1) AS average_age
FROM hrdata
GROUP BY department;

-- actual top 1 job role per department using ROW_NUMBER() CTE
WITH RankedRoles AS (
    SELECT 
        department, 
        job_role, 
        COUNT(*) AS role_count,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY COUNT(*) DESC) AS rnk
    FROM hrdata
    GROUP BY department, job_role
)
SELECT department, job_role, role_count
FROM RankedRoles
WHERE rnk = 1;


-- ============================================================
-- 3. JOB SATISFACTION INSIGHTS
-- ============================================================

-- average satisfaction by education level
SELECT 
    education, 
    ROUND(AVG(job_satisfaction), 2) AS average_satisfaction
FROM hrdata
GROUP BY education
ORDER BY average_satisfaction DESC;

-- grabs both highest AND lowest department satisfaction in a single query
WITH DeptSatisfaction AS (
    SELECT 
        department, 
        ROUND(AVG(job_satisfaction), 2) AS avg_satisfaction,
        RANK() OVER (ORDER BY AVG(job_satisfaction) DESC) AS rank_high,
        RANK() OVER (ORDER BY AVG(job_satisfaction) ASC) AS rank_low
    FROM hrdata
    GROUP BY department
)
SELECT department, avg_satisfaction,
       CASE 
           WHEN rank_high = 1 THEN 'Highest Satisfaction'
           WHEN rank_low = 1 THEN 'Lowest Satisfaction'
       END AS category
FROM DeptSatisfaction
WHERE rank_high = 1 OR rank_low = 1;

-- UPDATE: satisfaction distribution per department (low vs high satisfaction)
SELECT 
    department,
    SUM(CASE WHEN job_satisfaction IN (1, 2) THEN 1 ELSE 0 END) AS low_satisfaction_count,
    SUM(CASE WHEN job_satisfaction IN (3, 4) THEN 1 ELSE 0 END) AS high_satisfaction_count,
    ROUND(100.0 * SUM(CASE WHEN job_satisfaction IN (3, 4) THEN 1 ELSE 0 END) / COUNT(*), 2) AS high_satisfaction_pct
FROM hrdata
GROUP BY department;

-- top education levels by satisfaction among frequent travelers
SELECT 
    education, 
    ROUND(AVG(job_satisfaction), 2) AS avg_satisfaction
FROM hrdata
WHERE business_travel = 'Travel_Frequently'
GROUP BY education
ORDER BY avg_satisfaction DESC
LIMIT 3;

-- top age band by satisfaction among married employees
SELECT 
    age_band, 
    ROUND(AVG(job_satisfaction), 2) AS average_satisfaction
FROM hrdata
WHERE marital_status = 'Married'
GROUP BY age_band
ORDER BY average_satisfaction DESC
LIMIT 1;


-- ============================================================
-- 4. ATTRITION DEEP DIVES
-- ============================================================

-- attrition rate by age band with actual counts
SELECT 
    age_band, 
    COUNT(*) AS total_in_band,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hrdata
GROUP BY age_band
ORDER BY attrition_rate_pct DESC;

-- highest attrition combination (education + age_band) with minimum sample size filter
SELECT 
    education, 
    age_band, 
    COUNT(*) AS total_employees,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hrdata
GROUP BY education, age_band
HAVING COUNT(*) >= 10
ORDER BY attrition_rate_pct DESC
LIMIT 5;

-- UPDATED: attrition & satisfaction breakdown by gender and department
SELECT 
    department,
    gender,
    COUNT(*) AS total_employees,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(job_satisfaction), 2) AS avg_satisfaction
FROM hrdata
GROUP BY department, gender
ORDER BY department, gender;

-- UPDATED: education field mapping across departments (shows where grads end up)
SELECT 
    department,
    education_field,
    COUNT(*) AS employee_count
FROM hrdata
GROUP BY department, education_field
ORDER BY department, employee_count DESC;
