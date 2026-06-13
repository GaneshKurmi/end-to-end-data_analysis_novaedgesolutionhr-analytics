-- Level 2: Salary Analytics
	-- Top 10 highest-paid employees.
SELECT 
	employee_id,
	CONCAT_WS(' ',first_name,last_name) AS employee_name,
	job_role,
	salary
FROM hr_analytics.employee
ORDER BY salary DESC LIMIT 10;

	-- Bottom 10 lowest-paid employees.
SELECT 
	employee_id,
	CONCAT_WS(' ',first_name,last_name) AS employee_name,
	job_role,
	salary
FROM hr_analytics.employee
ORDER BY salary LIMIT 10;
	-- Average salary by department.
SELECT 
	department,
	ROUND(AVG(salary),2) AS average_salary
FROM hr_analytics.employee
GROUP BY department;
	-- Average salary by city.
SELECT 
	city,
	ROUND(AVG(salary),2) AS average_salary
FROM hr_analytics.employee
GROUP BY city;
	-- Average salary by education level.
SELECT 
	education,
	ROUND(AVG(salary),2) AS average_salary
FROM hr_analytics.employee
GROUP BY education;
	-- Department with the highest average salary.
SELECT * FROM (
SELECT
	department,
	ROUND(AVG(salary),2) AS average_salary,
	DENSE_RANK() OVER(ORDER BY AVG(salary) DESC) AS rnk
FROM hr_analytics.employee 
GROUP BY department ) t
WHERE rnk =1;
	-- Department with the lowest average salary.
SELECT * FROM (
SELECT
	department,
	ROUND(AVG(salary),2) AS average_salary,
	DENSE_RANK() OVER(ORDER BY AVG(salary)) AS rnk
FROM hr_analytics.employee 
GROUP BY department ) t
WHERE rnk =1;
	-- Salary distribution by gender.
SELECT 
	gender,
	ROUND(AVG(salary),2) AS average_salary
FROM hr_analytics.employee 
GROUP BY gender;
	-- Salary band analysis (Low, Medium, High).
SELECT 
	CASE
		WHEN salary <60000 THEN 'low'
		WHEN salary BETWEEN 60000 AND 100000 THEN 'medium'
		WHEN salary > 100000 THEN 'high'
	END AS salary_band,
	COUNT(*) AS employee_count
FROM hr_analytics.employee
GROUP BY salary_band;
-- Employees earning above company average salary.
SELECT 
	employee_id,
	CONCAT_WS(' ',first_name,last_name) AS employee_name,
	salary,
	(SELECT ROUND(AVG(salary),2) AS avg_salary FROM hr_analytics.employee )
FROM hr_analytics.employee
WHERE salary >(SELECT  AVG(salary) FROM hr_analytics.employee);

