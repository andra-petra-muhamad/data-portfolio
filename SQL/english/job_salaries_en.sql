/*
A data consulting company is rapidly growing 
and employing various professionals in the field of data science, 
such as Data Scientists, Machine Learning Engineers, and Data Analysts. 
Employees work under different types of contracts, experience levels, 
and are spread across many countries.

To support HR management and compensation analysis, 
a database `job_salaries` is built with the following main structure:
The `salaries` table stores salary information for each employee, 
including work year, job title, 
experience level, employment type (full-time, part-time, contract), 
company size, company location, 
employee residence, annual salary in local currency, 
and salary converted to USD.

With this system, the company can:
- Analyze salary trends year by year.
- Compare average salaries based on job title and experience level.
- Understand differences in salaries between small, medium, and large companies.
- Evaluate salary differences by work location (remote, onsite, hybrid).
- Support HR decisions related to recruitment, promotions, and salary offers.
*/


-- Create database (table will be imported from external data)
CREATE DATABASE job_salaries;
USE job_salaries;

-- Check data and adjust column type
SELECT * FROM salaries;
ALTER TABLE salaries 
MODIFY COLUMN work_year YEAR;

/* Questions and Answers */
-- 1. Show distinct job titles
SELECT DISTINCT job_title
FROM salaries
ORDER BY job_title;

-- 2. Show jobs related to data analyst
SELECT DISTINCT job_title
FROM salaries
WHERE job_title LIKE "%data analyst%"
ORDER BY job_title;

-- 3. Average salary (in USD and converted to monthly IDR with 1 USD = Rp15,000)
SELECT AVG(salary_in_usd)
FROM salaries;

SELECT (AVG(salary_in_usd)*15000)/12
AS avg_sal_rp_monthly
FROM salaries;

-- 4. Average salary by experience level
SELECT experience_level,
	(AVG(salary_in_usd)*15000)/12 AS avg_sal_rp_monthly
FROM salaries
GROUP BY experience_level, employment_type
ORDER BY experience_level, employment_type;

-- 5. Countries with attractive salaries for full-time entry-level/mid-level data analysts
SELECT company_location,
	AVG(salary_in_usd) avg_sal_in_usd
FROM salaries
WHERE job_title LIKE "%data analyst%"
	AND employment_type = "FT"
	AND experience_level IN ("EN", "MI")
GROUP BY company_location
HAVING avg_sal_in_usd >=2000;

-- 6. Year with the highest salary increase from mid to senior level (for full-time data analyst jobs)
WITH s_1 AS (
	SELECT work_year, AVG(salary_in_usd) sal_in_usd_ex
	FROM salaries
	WHERE employment_type = 'FT'
		AND experience_level = 'EX'
		AND job_title LIKE '%data analyst%'
	GROUP BY work_year
),
s_2 AS (
	SELECT work_year, AVG(salary_in_usd) sal_in_usd_mi
	FROM salaries
	WHERE employment_type = 'FT'
		AND experience_level = 'MI'
		AND job_title LIKE '%data analyst%'
	GROUP BY work_year
),
t_year AS (
	SELECT DISTINCT work_year
	FROM salaries
)
SELECT
	t_year.work_year,
	s_1.sal_in_usd_ex,
	s_2.sal_in_usd_mi,
	s_1.sal_in_usd_ex - s_2.sal_in_usd_mi differences
FROM t_year
	LEFT JOIN s_1 ON s_1.work_year = t_year.work_year
	LEFT JOIN s_2 ON s_2.work_year = t_year.work_year;
    
-- 7. Trend of average annual salary by top 5 job titles
WITH top_jobs AS (
    SELECT job_title
    FROM salaries
    GROUP BY job_title
    ORDER BY COUNT(*) DESC
    LIMIT 5
)
SELECT work_year, job_title,
       ROUND(AVG(salary_in_usd),2) AS avg_salary_usd
FROM salaries
WHERE job_title IN (SELECT job_title FROM top_jobs)
GROUP BY work_year, job_title
ORDER BY work_year, avg_salary_usd DESC;

-- 8. Salary gap between remote vs onsite/hybrid per job_title
SELECT
  job_title,
  ROUND(AVG(CASE WHEN remote_ratio = 100 THEN salary_in_usd END), 2) AS avg_remote,
  ROUND(AVG(CASE WHEN remote_ratio = 50  THEN salary_in_usd END), 2) AS avg_hybrid,
  ROUND(AVG(CASE WHEN remote_ratio = 0   THEN salary_in_usd END), 2) AS avg_onsite,
  ROUND(
    AVG(CASE WHEN remote_ratio = 100 THEN salary_in_usd END)
    - AVG(CASE WHEN remote_ratio IN (0,50) THEN salary_in_usd END)
  , 2) AS gap_remote_vs_nonremote
FROM salaries
GROUP BY job_title
ORDER BY gap_remote_vs_nonremote DESC;

-- 9. Countries with fastest salary growth for Data Scientists
WITH yearly_salary AS (
    SELECT company_location, work_year,
           AVG(salary_in_usd) AS avg_salary
    FROM salaries
    WHERE job_title LIKE "%data scientist%"
    GROUP BY company_location, work_year
),
growth AS (
    SELECT company_location,
           MAX(avg_salary) - MIN(avg_salary) AS growth_salary
    FROM yearly_salary
    GROUP BY company_location
)
SELECT company_location, growth_salary
FROM growth
ORDER BY growth_salary DESC
LIMIT 10;

-- 10. Ranking job titles with the highest median salary
SELECT 
    job_title,
    COUNT(*) AS n_rows,
    ROUND(
        CASE 
            WHEN COUNT(*) % 2 = 1 THEN 
                SUBSTRING_INDEX(
                    SUBSTRING_INDEX( GROUP_CONCAT(salary_in_usd ORDER BY salary_in_usd), ',', (COUNT(*) DIV 2) + 1 ),
                ',', -1)
            ELSE 
                ( CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(salary_in_usd ORDER BY salary_in_usd), ',', COUNT(*) DIV 2), ',', -1) AS DECIMAL(10,2))
                + CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(salary_in_usd ORDER BY salary_in_usd), ',', (COUNT(*) DIV 2) + 1), ',', -1) AS DECIMAL(10,2))
                ) / 2
        END, 2
    ) AS median_salary
FROM salaries
GROUP BY job_title
HAVING n_rows >= 5
ORDER BY median_salary DESC
LIMIT 10;

-- 11. Salary comparison by company size
SELECT company_size,
       ROUND(AVG(salary_in_usd),2) AS avg_salary_usd,
       ROUND(MIN(salary_in_usd),2) AS min_salary_usd,
       ROUND(MAX(salary_in_usd),2) AS max_salary_usd
FROM salaries
GROUP BY company_size
ORDER BY avg_salary_usd DESC;

-- 12. Countries with the highest salary distribution (gap between max and min salary)
SELECT company_location,
       MAX(salary_in_usd) - MIN(salary_in_usd) AS salary_gap
FROM salaries
GROUP BY company_location
ORDER BY salary_gap DESC
LIMIT 10;

-- 13. Salary comparison per country and per year
SELECT work_year, company_location,
       ROUND(AVG(salary_in_usd), 2) AS avg_salary_usd
FROM salaries
GROUP BY work_year, company_location
ORDER BY work_year ASC, avg_salary_usd DESC;

-- 14. Job with the highest salary each year
SELECT s.work_year, s.job_title, s.avg_salary
FROM (
    SELECT work_year, job_title, 
           AVG(salary_in_usd) AS avg_salary,
           ROW_NUMBER() OVER(PARTITION BY work_year ORDER BY AVG(salary_in_usd) DESC) AS rank_salary
    FROM salaries
    GROUP BY work_year, job_title
) s
WHERE s.rank_salary = 1;

-- 15. Salary ratio by remote ratio
SELECT remote_ratio,
       ROUND(AVG(salary_in_usd),2) AS avg_salary_usd,
       COUNT(*) AS total_jobs
FROM salaries
GROUP BY remote_ratio
ORDER BY avg_salary_usd DESC;

-- 16. Countries with the highest number of remote jobs
SELECT company_location,
       COUNT(*) AS total_remote_jobs
FROM salaries
WHERE remote_ratio = 100
GROUP BY company_location
ORDER BY total_remote_jobs DESC
LIMIT 10;

-- 17. Salary gap between contract (CT) and full-time (FT) jobs
SELECT
  job_title,
  COUNT(CASE WHEN employment_type = 'CT' THEN 1 END) AS n_ct,
  COUNT(CASE WHEN employment_type = 'FT' THEN 1 END) AS n_ft,
  ROUND(AVG(CASE WHEN employment_type = 'CT' THEN salary_in_usd END),2) AS avg_ct,
  ROUND(AVG(CASE WHEN employment_type = 'FT' THEN salary_in_usd END),2) AS avg_ft,
  CASE 
    WHEN COUNT(CASE WHEN employment_type = 'CT' THEN 1 END) > 0
     AND COUNT(CASE WHEN employment_type = 'FT' THEN 1 END) > 0
    THEN ROUND(
      AVG(CASE WHEN employment_type = 'CT' THEN salary_in_usd END)
      - AVG(CASE WHEN employment_type = 'FT' THEN salary_in_usd END)
    ,2)
    ELSE NULL
  END AS gap_ct_minus_ft
FROM salaries
GROUP BY job_title
ORDER BY gap_ct_minus_ft DESC;

-- 18. Countries with fastest salary growth overall
WITH yearly_avg AS (
    SELECT work_year, company_location,
           AVG(salary_in_usd) AS avg_salary
    FROM salaries
    GROUP BY work_year, company_location
),
growth AS (
    SELECT company_location,
           MAX(avg_salary) - MIN(avg_salary) AS salary_growth
    FROM yearly_avg
    GROUP BY company_location
)
SELECT company_location, salary_growth
FROM growth
ORDER BY salary_growth DESC
LIMIT 10;

-- 19. Top job titles with most employees
SELECT job_title,
       COUNT(*) AS total_employees
FROM salaries
GROUP BY job_title
ORDER BY total_employees DESC
LIMIT 10;

-- 20. Top 5 countries with the highest average salary for Data Scientists
SELECT company_location,
       ROUND(AVG(salary_in_usd),2) AS avg_salary
FROM salaries
WHERE job_title = 'Data Scientist'
GROUP BY company_location
ORDER BY avg_salary DESC
LIMIT 5;

-- 21. Salary min, max, and avg by experience level
SELECT experience_level,
       MIN(salary_in_usd) AS min_salary,
       MAX(salary_in_usd) AS max_salary,
       ROUND(AVG(salary_in_usd),2) AS avg_salary
FROM salaries
GROUP BY experience_level;

-- 22. Salary trend for Data Engineers
SELECT work_year,
       ROUND(AVG(salary_in_usd),2) AS avg_salary
FROM salaries
WHERE job_title = 'Data Engineer'
GROUP BY work_year
ORDER BY work_year;

-- 23. Countries with the most contract jobs
SELECT company_location,
       COUNT(*) AS contract_jobs
FROM salaries
WHERE employment_type = 'CT'
GROUP BY company_location
ORDER BY contract_jobs DESC
LIMIT 5;

-- 24. Salary comparison between US vs Non-US companies
SELECT 
    CASE WHEN company_location = 'US' THEN 'United States' ELSE 'Non-US' END AS region,
    ROUND(AVG(salary_in_usd),2) AS avg_salary,
    COUNT(*) AS total_jobs
FROM salaries
GROUP BY region;

-- 25. Employee residence with the highest representation globally
SELECT employee_residence,
       COUNT(*) AS total_workers
FROM salaries
GROUP BY employee_residence
ORDER BY total_workers DESC
LIMIT 10;

-- 26. Remote companies with the highest average salary
SELECT company_location,
       job_title,
       ROUND(AVG(salary_in_usd),2) AS avg_salary
FROM salaries
WHERE remote_ratio = 100
GROUP BY company_location, job_title
ORDER BY avg_salary DESC
LIMIT 10;
