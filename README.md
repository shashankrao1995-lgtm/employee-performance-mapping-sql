# Employee Performance Mapping (SQL)

Course-end project for the SQL course. ScienceQtech is a data science startup and the HR analysis team needs reports on employee details, performance and projects for the annual appraisal cycle. All the analysis is done in MySQL on the employee database.

## Files

- `employee_performance_mapping.sql` - all the queries (Q1 to Q11, plus Q12 for bonus and training)
- `screenshots/` - output of each query, named by question number
- `Employee_Performance_Mapping_Writeup.pdf` - write-up with each query, its output and a short observation

## Dataset

Three tables provided with the course: `emp_record_table` (19 employees), `proj_table` (6 projects) and `data_science_team` (13 employees).

## What the queries cover

1. Creating the database and importing the data
2. Employee list with department
3. Employees by rating band (below 2, 2 to 4, above 4)
4. Employees in leadership roles
5. Ratings by department with the department max (window function)
6. Min and max salary by role
7. Ranking employees by experience (RANK and DENSE_RANK)
8. View of employees earning more than 6000
9. Country wise view of employees earning more than 6000
10. Index on FIRST_NAME, with the execution plan before and after
11. Average salary by continent and country
12. Bonus estimate (5% of salary x rating) and employees needing training

## A few findings

- Highest salary is 16500 (President). The other roles follow the hierarchy, with a small overlap between Lead Data Scientists and Managers.
- Most employees are rated between 2 and 4. Three employees are rated 1 and are flagged for training.
- After adding the index, the lookup for Eric goes from a full table scan (19 rows) to an index lookup (1 row).
- Estimated total bonus cost is 23985.

Tool used: MySQL 8.0
