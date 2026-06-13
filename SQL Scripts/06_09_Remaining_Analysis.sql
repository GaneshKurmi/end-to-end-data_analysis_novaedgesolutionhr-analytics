-- Overtime & Employee Wellbeing
	-- How does overtime affect attrition, satisfaction, and performance?
WITH employee_attrition AS (SELECT * ,
CASE
WHEN attrition ='Yes' THEN 1
WHEN attrition ='No' THEN 0
WHEN attrition IS NULL THEN 0
END AS total_attrition
FROM hr_analytics.employee)
SELECT 
	overtime ,
	COUNT(*) AS total_employee,
	SUM(total_attrition) AS total_attrition,
	ROUND(100*SUM(total_attrition)/COUNT(*),2) AS percentage_attrition_rate,
	ROUND(AVG(satisfaction_score),2) AS avg_satisfaction ,
	ROUND(AVG(performance_rating),2) AS avg_performance FROM employee_attrition
GROUP BY overtime;
	-- Which departments and cities have the highest overtime burden?
WITH overtime_cat AS (SELECT * ,
	CASE
		WHEN overtime ='Yes' THEN 1
		WHEN overtime ='No' THEN 0
		WHEN overtime IS NULL THEN 0
	END AS overtime_category
FROM hr_analytics.employee)

-- Workforce Demographics
	-- What is the overall demographic profile of the workforce?
SELECT 
	city,
	COUNT(*) AS total_employee
FROM hr_analytics.employee
GROUP BY city
ORDER BY city DESC;
	-- How do demographics differ across departments?
SELECT 
	department,
	COUNT(*) AS total_employee,
	SUM(CASE WHEN gender ='Male' THEN 1 ELSE 0 END) AS total_male_employee,
	SUM(CASE WHEN gender ='Female' THEN 1 ELSE 0 END) AS total_female_employee,
	SUM(CASE WHEN marital_status ='Married' THEN 1 ELSE 0 END) AS total_married_employee,
	SUM(CASE WHEN marital_status ='Single' THEN 1 ELSE 0 END) AS total_single_employee,
	ROUND(AVG(age),2) AS avg_age
FROM hr_analytics.employee
GROUP BY department
ORDER BY department DESC;
	-- How do demographics differ across locations?
SELECT 
	city,
	COUNT(*) AS total_employee,
	SUM(CASE WHEN gender ='Male' THEN 1 ELSE 0 END) AS total_male_employee,
	SUM(CASE WHEN gender ='Female' THEN 1 ELSE 0 END) AS total_female_employee,
	SUM(CASE WHEN marital_status ='Married' THEN 1 ELSE 0 END) AS total_married_employee,
	SUM(CASE WHEN marital_status ='Single' THEN 1 ELSE 0 END) AS total_single_employee,
	ROUND(AVG(age),2) AS avg_age
FROM hr_analytics.employee
GROUP BY city
ORDER BY city DESC;
	-- Which departments have the youngest and oldest workforce?
WITH department_age AS (
    SELECT 
        department,
        ROUND(AVG(age),2) AS avg_age
    FROM hr_analytics.employee
    GROUP BY department
)

SELECT *,
    CASE 
        WHEN avg_age = (SELECT MIN(avg_age) FROM department_age)
        THEN 'Youngest Workforce'
        
        WHEN avg_age = (SELECT MAX(avg_age) FROM department_age)
        THEN 'Oldest Workforce'
    END AS workforce_category

FROM department_age
WHERE avg_age = (SELECT MIN(avg_age) FROM department_age)
   OR avg_age = (SELECT MAX(avg_age) FROM department_age);

-- Level 8: Window Function Questions
	-- Top 3 highest-paid employees in each department.
WITH salary_rank AS (SELECT 
	employee_id,
	first_name,
	department,
	salary,
	DENSE_RANK() OVER( PARTITION BY department ORDER BY salary DESC) AS salary_rank
	FROM hr_analytics.employee )
SELECT * FROM salary_rank 
WHERE salary_rank <=3;

	-- Lowest-paid employee in each department.
WITH salary_rank AS (SELECT 
	employee_id,
	first_name,
	department,
	salary,
	MIN(salary) OVER( PARTITION BY department) AS lowest_paid_employee
	FROM hr_analytics.employee )
SELECT * FROM salary_rank 
WHERE salary = lowest_paid_employee;
	-- Salary rank of employees within department.
WITH salary_rank AS (SELECT 
department,
	employee_id,
	first_name,
	salary,
	DENSE_RANK() OVER( PARTITION BY department ORDER BY salary DESC) AS salary_rank
	FROM hr_analytics.employee )
SELECT * FROM salary_rank 
	-- Dense rank employees by salary.
WITH salary_rank AS (SELECT 
	employee_id,
	first_name,
	salary,
	DENSE_RANK() OVER(ORDER BY salary DESC) AS salary_rank
	FROM hr_analytics.employee )
SELECT * FROM salary_rank 
	-- Employees earning the same salary as others.
WITH salary_rank AS (SELECT 
	employee_id,
	first_name,
	salary,
	COUNT(*) OVER(PARTITION BY salary) AS salary_count
	FROM hr_analytics.employee )
SELECT 
employee_id,
	first_name,
	salary
	FROM salary_rank 
WHERE salary_count>1
ORDER BY salary DESC;
	-- Second highest-paid employee in each department.
	WITH salary_rank AS (SELECT 
	employee_id,
	first_name,
	department,
	salary,
	DENSE_RANK() OVER( PARTITION BY department ORDER BY salary DESC) AS salary_rank
	FROM hr_analytics.employee )
SELECT * FROM salary_rank 
WHERE salary_rank =2;
	-- Third highest-paid employee in each city.
WITH salary_rank_CTE AS (
	SELECT 
		employee_id,
		first_name,
		city,
		salary,
		DENSE_RANK() OVER(PARTITION BY city ORDER BY salary DESC) AS salary_rank
	FROM hr_analytics.employee
)
SELECT 
	city,
	employee_id,
	first_name,
	salary,
	salary_rank
FROM salary_rank_CTE
WHERE salary_rank =3;
SELECT * FROM hr_analytics.employee;
	-- Highest satisfaction score in each department.
WITH satisfaction_score_rank AS (
SELECT 
    department ,
	satisfaction_score,
	ROW_NUMBER() OVER(PARTITION BY department ORDER BY satisfaction_score DESC) AS satisfaction_rank
	FROM hr_analytics.employee
)
SELECT department,satisfaction_score ,satisfaction_rank
FROM satisfaction_score_rank WHERE satisfaction_rank =1;
	-- Top performer in each city.
SELECT * FROM hr_analytics.employee;
WITH performance_rank AS (
	SELECT  
	city,
	employee_id,
	first_name,
	performance_rating,
	DENSE_RANK() OVER(PARTITION BY city ORDER BY performance_rating DESC) AS performance_rnk
FROM hr_analytics.employee
)
SELECT city, employee_id, first_name ,performance_rating
FROM performance_rank WHERE performance_rnk =1
-- Rank employees by hire date within department.
	SELECT 
		employee_id,
		first_name,
		department ,
		hire_date,
		DENSE_RANK() OVER(PARTITION BY department ORDER BY hire_date ASC) AS rnk	
FROM hr_analytics.employee;
-- Level 9: Management-Level Insights
	-- Which department should receive salary corrections?
WITH dept_salary AS 
(
    SELECT
        department,
        ROUND(AVG(salary),2) AS avg_department_salary
    FROM hr_analytics.employee
    GROUP BY department
),
company_salary AS (
    SELECT
        ROUND(AVG(salary),2) AS avg_company_salary
    FROM hr_analytics.employee
)
SELECT
    ds.department,
    ds.avg_department_salary,
    cs.avg_company_salary,
    ROUND(
        cs.avg_company_salary - ds.avg_department_salary,
        2
    ) AS salary_gap
FROM dept_salary ds
CROSS JOIN company_salary cs
WHERE ds.avg_department_salary < cs.avg_company_salary
ORDER BY salary_gap DESC;
	-- Which department has high attrition and low satisfaction?
WITH CTE AS (SELECT 
	department , 
	SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS total_attrition,
	ROUND(AVG(satisfaction_score),2) AS avg_satisfaction
FROM hr_analytics.employee
GROUP BY department)
		SELECT department , 
			total_attrition , 
			avg_satisfaction 
			FROM CTE 
		ORDER BY total_attrition DESC , avg_satisfaction ASC 
		LIMIT 1;

	-- Which city has the most stable workforce?
WITH CTE AS (SELECT 
	city , 
	COUNT(*) AS total_employee,
	SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS total_attrition,
	ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)*100.00/COUNT(*),2) AS attrition_rate,
	ROUND(AVG(satisfaction_score),2) AS avg_satisfaction
FROM hr_analytics.employee
GROUP BY city)
		SELECT city , 
			total_employee,
			total_attrition ,
			attrition_rate,
			avg_satisfaction 
			FROM CTE 
		ORDER BY attrition_rate ASC , avg_satisfaction DESC 
		LIMIT 1;
	-- Which employees are at risk of leaving?
WITH promotion_summary AS 
	(  SELECT 
			 employee_id , 
			 COUNT(*) AS total_promotions 
	   FROM hr_analytics.promotion GROUP BY employee_id),
     emp_detail AS (
	   SELECT e.employee_id,
			e.first_name,
			e.department,
			e.salary,
			ROUND(AVG(e.salary) OVER(PARTITION BY e.department),2) AS department_avg_salary,
			e.satisfaction_score,
			ROUND(AVG(e.satisfaction_score) OVER(PARTITION BY e.department),2) AS department_avg_satisfaction_score,
			COALESCE(p.total_promotions,0) AS promotion_count
	  FROM hr_analytics.employee e LEFT JOIN promotion_summary p ON e.employee_id = p.employee_id)
SELECT employee_id , 
		first_name ,
		department,
		salary,
		satisfaction_score,
		department_avg_satisfaction_score
FROM emp_detail 
WHERE salary < department_avg_salary AND satisfaction_score < department_avg_satisfaction_score AND promotion_count =0;
	-- Which department has the best performance-to-salary ratio?
WITH salary_to_performance AS (SELECT 
	department,
	ROUND(AVG(salary),2) AS department_avg_salary,
	ROUND(AVG(performance_rating),2) AS department_avg_performance
FROM hr_analytics.employee
GROUP BY department)
SELECT department , 
	department_avg_salary,
	department_avg_performance,
	ROUND(department_avg_performance/department_avg_salary * 1000.0,6) AS performance_index
FROM salary_to_performance
ORDER BY performance_index DESC LIMIT 1;
	-- Which department needs hiring urgently?
WITH dept_summary AS (SELECT department,
	COUNT(*) AS total_employee,
	SUM(CASE WHEN attrition ='Yes' THEN 1 ELSE 0 END) AS total_attrition,
	ROUND(SUM(CASE WHEN attrition ='Yes' THEN 1 ELSE 0 END)*100.00/COUNT(*),2) AS attrition_percentage,
	ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction
FROM hr_analytics.employee
GROUP BY department)
SELECT department,
	total_employee,
	total_attrition,
	attrition_percentage,
	avg_satisfaction
FROM dept_summary
ORDER BY 

	attrition_percentage DESC,
	total_attrition DESC,
	avg_satisfaction ASC
LIMIT 1

	-- Which managers handle the largest teams?
SELECT manager_id,
	COUNT(*) AS total_employee
FROM hr_analytics.employee
GROUP BY manager_id
ORDER BY total_employee DESC LIMIT 1;
-- Level 10: Portfolio Showcase Questions
	-- Build a complete Attrition Dashboard.
	-- Build a Workforce Diversity Dashboard.
	-- Build a Compensation Analysis Dashboard.
	-- Build a Hiring Trends Dashboard.
	-- Build an Employee Satisfaction Dashboard.
	-- Build a Performance Analytics Dashboard.
	-- Build a Department Health Score Dashboard.
	-- Identify top business risks from HR data.
	-- Generate actionable HR recommendations.
	-- Create executive-level HR KPI report.

-- 1. Which employees have excellent attendance, received no promotions, and minimal salary growth?
WITH monthly_avg_attn AS (
    SELECT
        employee_id,
        ROUND(AVG(attn_percentage),2) AS monthly_avg_attendance_percentage
    FROM (
        SELECT
            employee_id,
            EXTRACT(MONTH FROM attendance_date) AS attn_month,
            ROUND(
                SUM(
                    CASE
                        WHEN status IN ('Present','WFH')
                        THEN 1
                        ELSE 0
                    END
                ) * 100.0 /
                SUM(
                    CASE
                        WHEN status <> 'Weekend'
                        THEN 1
                        ELSE 0
                    END
                ),
                2
            ) AS attn_percentage
        FROM hr_analytics.attendance
        GROUP BY
            employee_id,
            EXTRACT(MONTH FROM attendance_date)
    ) x
    GROUP BY employee_id
),

promotion_summary AS (
    SELECT
        employee_id,
        COUNT(*) AS promotion_count
    FROM hr_analytics.promotion
    GROUP BY employee_id
),

salary_growth AS (
    SELECT
        employee_id,
        MAX(salary) - MIN(salary) AS salary_growth
    FROM hr_analytics.salary_history
    GROUP BY employee_id
),

company_avg_growth AS (
    SELECT
        AVG(salary_growth) AS avg_salary_growth
    FROM salary_growth
)

SELECT
    e.employee_id,
    e.first_name,
    e.department,
    a.monthly_avg_attendance_percentage,
    COALESCE(p.promotion_count,0) AS promotion_count,
    s.salary_growth
FROM hr_analytics.employee e
LEFT JOIN monthly_avg_attn a
    ON e.employee_id = a.employee_id
LEFT JOIN promotion_summary p
    ON e.employee_id = p.employee_id
LEFT JOIN salary_growth s
    ON e.employee_id = s.employee_id
CROSS JOIN company_avg_growth c
WHERE a.monthly_avg_attendance_percentage >= 90
  AND COALESCE(p.promotion_count,0) = 0
  AND s.salary_growth < c.avg_salary_growth
ORDER BY
    a.monthly_avg_attendance_percentage DESC,
    s.salary_growth ASC;
-- 3. Do promoted employees have better attendance than non-promoted employees?
WITH attendance_summary AS (
	 SELECT employee_id, 
 		ROUND(AVG(attendance_percentage),2) AS avg_attendance_percentage
 	 FROM (SELECT 
	         employee_id,
			 EXTRACT('MONTH' FROM attendance_date) AS attn_month,
	         ROUND(SUM(CASE WHEN status IN ('Present' ,'WFH') THEN 1 ELSE 0 END)*100./
			 SUM(
				CASE
					 WHEN status <> 'Weekend'
		             THEN 1
			         ELSE 0
				     END ),2)AS attendance_percentage
	 FROM hr_analytics.attendance t
	 GROUP BY employee_id , attn_month) i 
	 GROUP BY employee_id ),
promotion_summary AS (
	SELECT * ,CASE WHEN promotion_id IS NULL THEN 'Not promoted' ELSE 'Promoted' END AS promotion_status 
	FROM (SELECT e.employee_id , p.promotion_id  
	 FROM hr_analytics.employee e
	 LEFT JOIN hr_analytics.promotion p ON e.employee_id = p.employee_id) o)  ,
	 employee_summary AS (SELECT 
	 	a.employee_id , 
		a.avg_attendance_percentage , 
		p.promotion_id , 
		p.promotion_status 
		FROM  attendance_summary a 
	LEFT JOIN promotion_summary p ON a.employee_id =p.employee_id )
	SELECT promotion_status ,
	COUNT(*) AS total_employee,
	ROUND(AVG(avg_attendance_percentage),2) AS avg_atn_percentage
	FROM employee_summary GROUP BY promotion_status
-- 4.Among promoted employees, who experienced below-average salary growth?
WITH salary_summary AS (SELECT employee_id , 
	   MAX(salary) - MIN(salary) AS increased_salary
FROM hr_analytics.salary_history
GROUP BY employee_id) ,
employee_summary AS (
SELECT e.employee_id , 
	   s.increased_salary , 
	   p.promotion_id , 
	   ROUND(AVG(s.increased_salary) OVER(),2) AS avg_salary FROM hr_analytics.employee e 
		LEFT JOIN salary_summary s ON e.employee_id = s.employee_id
		LEFT JOIN hr_analytics.promotion p ON e.employee_id = p.employee_id
		WHERE p.promotion_id IS NOT NULL)
SELECT employee_id , increased_salary , avg_salary FROM employee_summary
WHERE increased_salary <avg_salary
