
-- Level 4: Employee Satisfaction Analysis
	-- Average satisfaction score company-wide.
SELECT 
	ROUND(AVG(satisfaction_score),2) AS company_avg_satisfaction_score
FROM hr_analytics.employee;
	-- Average satisfaction score by department.
SELECT
	department,
	ROUND(AVG(satisfaction_score),2) AS avg_satisfaction_score
FROM hr_analytics.employee
GROUP BY department;
-- Average satisfaction score by city.
SELECT
	city,
	ROUND(AVG(satisfaction_score),2) AS avg_satisfaction_score
FROM hr_analytics.employee
GROUP BY city;
	-- Top 10 most satisfied employees.
SELECT 
	employee_id,
	CONCAT_WS(' ',first_name,last_name) AS employee_name,
	satisfaction_score
FROM hr_analytics.employee
WHERE satisfaction_score IS NOT NULL
ORDER BY satisfaction_score DESC , employee_id ASC
LIMIT 10;

	-- Bottom 10 least satisfied employees.
SELECT 
	employee_id,
	CONCAT_WS(' ',first_name,last_name) AS employee_name,
	satisfaction_score
FROM hr_analytics.employee
WHERE satisfaction_score IS NOT NULL
ORDER BY satisfaction_score ASC , employee_id ASC
LIMIT 10;

	-- Departments with satisfaction score below company average.
SELECT 
	department ,
	ROUND(AVG(satisfaction_score),2) AS avg_satisfaction_score
FROM hr_analytics.employee
GROUP BY department
HAVING 
	ROUND(AVG(satisfaction_score),2)< 
		(SELECT ROUND(AVG(satisfaction_score),2) FROM hr_analytics.employee );
	-- Relationship between satisfaction and attrition
SELECT 
	attrition ,
	ROUND(AVG(satisfaction_score),2) AS avg_satisfaction_score
FROM hr_analytics.employee
GROUP BY attrition
	-- Satisfaction score by gender.
SELECT 
	gender ,
	ROUND(AVG(satisfaction_score),2) AS avg_satisfaction_score
FROM hr_analytics.employee
GROUP BY gender;
	-- Satisfaction score by marital status.
SELECT 
	marital_status ,
	ROUND(AVG(satisfaction_score),2) AS avg_satisfaction_score
FROM hr_analytics.employee
GROUP BY marital_status;
	-- Employees with satisfaction score less than 3.
SELECT
	employee_id,
	CONCAT_WS(' ',first_name,last_name) AS employee_name,
	satisfaction_score
FROM hr_analytics.employee
WHERE satisfaction_score < 3;
--------------------------------------------------------------------------------
