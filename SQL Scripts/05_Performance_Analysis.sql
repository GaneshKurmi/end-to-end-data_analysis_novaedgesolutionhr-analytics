-- Level 5: Performance Analysis
	-- Average performance rating.
SELECT * FROM hr_analytics.employee
	-- Performance rating distribution.
SELECT 
	performance_rating,
	COUNT(*) AS employee_count
FROM hr_analytics.employee
GROUP BY performance_rating
ORDER BY performance_rating DESC;
	-- Top performers in each department.
SELECT 
	department,
	employee_id,
	CONCAT_WS(' ',first_name,last_name) AS employee_name,
	performance_rating
FROM hr_analytics.employee e
WHERE performance_rating = (SELECT MAX(performance_rating) FROM hr_analytics.employee
WHERE department = e.department)

ORDER BY department;
	-- Average performance by department.
SELECT 
	department ,
	ROUND(AVG(performance_rating),2) AS avg_performance_rating
FROM hr_analytics.employee
GROUP BY department;

	-- Average performance by city.
SELECT 
	city ,
	ROUND(AVG(performance_rating),2) AS avg_performance_rating
FROM hr_analytics.employee
GROUP BY city;
	-- Performance vs salary analysis.
SELECT 
	CASE 
	WHEN performance_rating >3  THEN 'High performance'
	WHEN performance_rating =3 THEN 'Medium Performance'
	WHEN performance_rating <3 THEN 'Low performance'
	END AS performance_category , 
	COUNT(*) AS employee_count,
	ROUND(AVG(salary),2) AS avg_salary
FROM hr_analytics.employee
GROUP BY performance_category
ORDER BY avg_salary DESC;
	-- Performance vs satisfaction analysis.
SELECT 
	CASE 
	WHEN performance_rating >3  THEN 'High performance'
	WHEN performance_rating =3 THEN 'Medium Performance'
	WHEN performance_rating <3 THEN 'Low performance'
	END AS performance_category , 
	COUNT(*) AS employee_count,
	ROUND(AVG(satisfaction_score),2) AS avg_satisfaction_score
FROM hr_analytics.employee
GROUP BY performance_category
ORDER BY avg_satisfaction_score DESC;
	-- Employees with highest performance but low salary.
WITH employee_category AS (
	SELECT
	*,
	CASE 
	WHEN performance_rating >3  THEN 'High performance'
	WHEN performance_rating =3 THEN 'Medium Performance'
	WHEN performance_rating <3 THEN 'Low performance'
	END AS performance_category ,
	CASE 
	WHEN salary <50000  THEN 'Low salary'
	WHEN salary BETWEEN 50000 AND 99999 THEN 'Medium salary'
	WHEN salary >=100000 THEN 'High salary'
	END AS salary_category 
FROM hr_analytics.employee)
SELECT 
	employee_id ,
	CONCAT_WS(' ',first_name,last_name) AS employee_name,
	performance_category,
	performance_rating,
	salary_category,
	salary
FROM employee_category
WHERE performance_category = 'High performance' AND salary_category  = 'Low salary'
ORDER BY salary ASC ;

	-- Employees with poor performance but high salary.
WITH employee_category AS (
	SELECT
	*,
	CASE 
	WHEN performance_rating >3  THEN 'High performance'
	WHEN performance_rating =3 THEN 'Medium Performance'
	WHEN performance_rating <3 THEN 'Low performance'
	END AS performance_category ,
	CASE 
	WHEN salary <50000  THEN 'Low salary'
	WHEN salary BETWEEN 50000 AND 99999 THEN 'Medium salary'
	WHEN salary >=100000 THEN 'High salary'
	END AS salary_category 
FROM hr_analytics.employee)
SELECT 
	employee_id ,
	CONCAT_WS(' ',first_name,last_name) AS employee_name,
	performance_category,
	performance_rating,
	salary_category,
	salary
FROM employee_category
WHERE performance_category = 'Low performance' AND salary_category  = 'High salary'
ORDER BY salary ASC ;
	-- Departments with highest-performing workforce.
WITH employee_category AS (
	SELECT
	*,
	CASE 
	WHEN performance_rating >3  THEN 'High performance'
	WHEN performance_rating =3 THEN 'Medium Performance'
	WHEN performance_rating <3 THEN 'Low performance'
	END AS performance_category 
FROM hr_analytics.employee)
SELECT 
	department,
	performance_category,
	COUNT(*) AS high_performer_count
FROM employee_category
WHERE performance_category = 'High performance'
GROUP BY department ,performance_category
ORDER BY high_performer_count DESC;
