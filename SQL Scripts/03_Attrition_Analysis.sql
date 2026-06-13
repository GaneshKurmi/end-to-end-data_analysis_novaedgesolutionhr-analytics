-- Level 3: Attrition Analysis
	-- Overall attrition rate.
SELECT 
	ROUND(SUM(
		CASE
			WHEN attrition ='Yes' THEN 1
			ELSE 0
		END)*100/COUNT(*) ,2)
	AS attrition_rate FROM hr_analytics.employee
	

	-- Total employees who left the company.
SELECT 
	COUNT(*) AS company_left_employee
FROM hr_analytics.employee
WHERE attrition ='Yes';
	-- Attrition by department.
SELECT department ,
	COUNT(*) AS company_left_employee
FROM hr_analytics.employee
GROUP BY department ,attrition
HAVING attrition ='Yes';
	-- Attrition by city.
SELECT city ,
	COUNT(*) AS company_left_employee
FROM hr_analytics.employee
GROUP BY city ,attrition
HAVING attrition ='Yes';
	-- Attrition by gender.
	SELECT gender ,
	COUNT(*) AS company_left_employee
FROM hr_analytics.employee
GROUP BY gender ,attrition
HAVING attrition ='Yes';
	-- Attrition by education level.
SELECT education ,
	COUNT(*) AS company_left_employee
FROM hr_analytics.employee
GROUP BY education ,attrition
HAVING attrition ='Yes';
	-- Attrition by marital status.
SELECT marital_status ,
	COUNT(*) AS company_left_employee
FROM hr_analytics.employee
GROUP BY marital_status ,attrition
HAVING attrition ='Yes';
	-- Department with the highest attrition.
SELECT department ,
	COUNT(*) AS company_left_employee
FROM hr_analytics.employee
GROUP BY department ,attrition
HAVING attrition ='Yes'
ORDER BY company_left_employee DESC LIMIT 1;
	-- City with the highest attrition.
SELECT city ,
	COUNT(*) AS company_left_employee
FROM hr_analytics.employee
GROUP BY city ,attrition
HAVING attrition ='Yes'
ORDER BY company_left_employee DESC LIMIT 1;
	-- Average satisfaction score of employees who left.
SELECT attrition,
	ROUND(AVG(satisfaction_score),2) AS avg_satisfaction_of_left_employee,
	(SELECT MAX(satisfaction_score) FROM hr_analytics.employee ) AS maximum_satisfaction_score
FROM hr_analytics.employee
GROUP BY attrition
HAVING attrition ='Yes';

