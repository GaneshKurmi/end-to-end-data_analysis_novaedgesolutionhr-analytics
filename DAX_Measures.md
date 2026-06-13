##Total Employee

Total Workforce = COUNT('hr_analytics employee'[employee_id])

##Total Payout

Total Payout = SUM('hr_analytics employee'[salary])

##Satisfaction Score

Satisfaction Score = DIVIDE(SUM('hr_analytics employee'[satisfaction_score]),COUNT('hr_analytics employee'[employee_id]) )

##Promotion Rate

Promotion Rate = 
DIVIDE(
    DISTINCTCOUNT('hr_analytics promotion'[employee_id]),
    DISTINCTCOUNT('hr_analytics employee'[employee_id])
)

##Highest Salary

Highest Salary = MAX('hr_analytics employee'[salary])

##Average Exit Tenure

Avg Exit Tenure(Yrs.) = 
    AVERAGEX(
        FILTER(
            'hr_analytics employee',
            'hr_analytics employee'[attrition] = "Yes"
        ),
        DATEDIFF(
            'hr_analytics employee'[hire_date],
            TODAY(),
            YEAR
        )
    )

##Average Salary

Average Salary = DIVIDE(SUM('hr_analytics employee'[salary]),COUNT('hr_analytics employee'[employee_id]))

##Attrition Rate

Attrition Rate = 
DIVIDE(
    CALCULATE(
        COUNTROWS('hr_analytics employee'),
        'hr_analytics employee'[attrition] = "Yes"
    ),
    COUNTROWS('hr_analytics employee')
)

##Attrition Count

Attrition Count = 
CALCULATE(
    COUNTROWS('hr_analytics employee'),
    'hr_analytics employee'[attrition] = "Yes"
)

##Attrition Count

Active Employees = 
CALCULATE(
    COUNTROWS('hr_analytics employee'),
    'hr_analytics employee'[attrition] = "No"
)

##Salary Category

Salary Category = 
SWITCH(
    TRUE(),
    'hr_analytics employee'[salary] < 60000, "0-60K",
    'hr_analytics employee'[salary] < 90000, "60K-90K",
    'hr_analytics employee'[salary] < 120000, "90K-120K",
    "120K+"
)

##Attrition Salary category

Attrition Salary Category = 
SWITCH(
    TRUE(),
    'hr_analytics employee'[salary] < 70000, "Low Salary",
    'hr_analytics employee'[salary] < 100000, "Medium Salary",
    'hr_analytics employee'[salary] < 130000, "High Salary",
    "Very High Salary"
)


