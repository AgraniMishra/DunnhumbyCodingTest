--1.Find the nth largest salary.
--Method 1 using Window Function Assuming Salary can be same for multiple employees
SELECT * FROM
(
SELECT *,
DENSE_RANK() OVER(ORDER BY sal DESC) AS salary_rnk
FROM employee
)a
WHERE salary_rnk = 2;

----Method 2 using Offset Function if Salary is not repeating
SELECT *
FROM employee
ORDER BY sal DESC
OFFSET (n - 1) ROWS FETCH NEXT 1 ROW ONLY;

--2.List the highest salary paid for each job.
SELECT * FROM
(
SELECT *,
DENSE_RANK() OVER (PARTITION BY job ORDER BY sal DESC)  job_rnk
FROM employee
)a
WHERE job_rnk = 1;

--3.In which year did most people join the company?  Display the year and the number of Employees. 
SELECT join_year, num_of_employees
FROM (
  SELECT YEAR(hiredate) AS join_year, COUNT(*) AS num_of_employees
  FROM employee
  GROUP BY YEAR(hiredate)
) AS employee_counts
WHERE num_of_employees = (
  SELECT MAX(num_of_employees) 
  FROM (
    SELECT YEAR(hiredate) AS join_year, COUNT(*) AS num_of_employees
    FROM employee
    GROUP BY YEAR(hiredate)
  ) AS max_employee_counts
);


--4.Create a new column with the length of service of the Employees (in the form n years and m months).
SELECT *,
    CONCAT(
        FLOOR(DATEDIFF(DAY, hiredate, GETDATE()) / 365), ' years and ',
        (DATEDIFF(DAY, hiredate, GETDATE()) % 365) / 30, ' months'
    ) AS length_of_service
FROM employee;

--5.List all the Employees who have at least one person reporting to them.
SELECT DISTINCT e.*
FROM employee e
INNER JOIN employee r ON e.empno = r.mgr;
