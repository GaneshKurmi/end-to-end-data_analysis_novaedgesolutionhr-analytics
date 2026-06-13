--Level 1: Basic Business KPIs
	--Total number of employees in the company.
SELECT 
	COUNT(*) AS total_employee
FROM hr_analytics.employee;
	--Total employees by department.
SELECT
	department,
	COUNT(*) AS total_employee
FROM hr_analytics.employee
GROUP BY department;
	-- Total employees by city.
SELECT 
	city,
	COUNT(*) AS total_employee
FROM hr_analytics.employee
GROUP BY city;
	-- Total employees by gender.
SELECT 
	gender,
	COUNT(*) AS total_employee
FROM hr_analytics.employee
GROUP BY gender;
	-- Average salary of all employees.
SELECT 
	ROUND(AVG(salary),2) AS average_salary
FROM hr_analytics.employee;
	-- Minimum and maximum salary in the company.
SELECT 
	MIN(salary) AS minimum_salary,
	MAX(salary) AS maximum_salary
FROM hr_analytics.employee;
	-- Average age of employees.
SELECT 
	ROUND(AVG(age),2) AS everage_age
FROM hr_analytics.employee;
	-- Total employees hired each year.
SELECT 
	EXTRACT(YEAR FROM hire_date) AS hired_year,
	COUNT(*) AS total_hired_employee
FROM hr_analytics.employee
GROUP BY
	hired_year
ORDER BY hired_year;
	-- Total employees by education level.
SELECT 
	education,
	COUNT(*) AS total_employee
FROM hr_analytics.employee
GROUP BY education;
	-- Total employees by marital status.
SELECT 
	marital_status ,
	COUNT(*) AS total_employee
FROM hr_analytics.employee
GROUP BY marital_status;
----------------------------------------------------------------------------
