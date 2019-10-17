--Create tables and import corresponding csv files \

--Create departments table
CREATE TABLE departments (
    dept_no VARCHAR(4) NOT NULL,
    dept_name VARCHAR(45) NOT NULL,
    PRIMARY KEY (dept_no)
);

--Import departments.csv and preview table
SELECT * FROM departments;

--Create employees table
CREATE TABLE employees (
    emp_no INT NOT NULL,
    birth_date DATE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender VARCHAR(15) NOT NULL,
    hire_date DATE NOT NULL,
    PRIMARY KEY (emp_no)
);

--Import employees.csv and preview table
SELECT * FROM employees;

--Create dept_emp table
CREATE TABLE dept_emp (
    emp_no INT NOT NULL,
    dept_no VARCHAR(4) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

--Import dept_emp.csv and preview table
SELECT * FROM dept_emp;

--dept_manager table
CREATE TABLE dept_manager (
   dept_no VARCHAR(4) NOT NULL,
   emp_no INT NOT NULL,
   from_date DATE NOT NULL,
   to_date DATE NOT NULL,
   FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
   PRIMARY KEY (emp_no, dept_no)
);

--Import dept_manager.csv and preview table
SELECT * FROM dept_manager;

--Create salaries table
CREATE TABLE salaries (
    emp_no INT NOT NULL,
    salary INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    PRIMARY KEY (emp_no, from_date)
);

--Import salaries.csv and preview table
SELECT * FROM salaries

--Create titles table
CREATE TABLE titles (
    emp_no INT NOT NULL,
    title VARCHAR(50) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    PRIMARY KEY (emp_no, title, from_date)
);

--Import titles.csv and preview table
SELECT * FROM titles

--List the following details of each employee: employee number, last name, first name, gender, and salary.
SELECT 
e.emp_no,
e.last_name,
e.first_name,
e.gender,
s.salary
FROM employees e
JOIN salaries s
ON e.emp_no = s.emp_no;

--List employees who were hired in 1986
SELECT emp_no, first_name, last_name, hire_date
FROM employees
WHERE EXTRACT(year FROM hire_date) = '1986';

--List the manager of each department with the following information: 
--department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
SELECT
m.dept_no,
dept_name,
m.emp_no,
first_name,
last_name,
m.from_date,
m.to_date
FROM dept_manager m
LEFT JOIN departments on m.dept_no = departments.dept_no
LEFT JOIN employees on m.emp_no = employees.emp_no;

--List the department of each employee with the following information: 
--employee number, last name, first name, and department name.
SELECT
e.emp_no,
last_name,
first_name,
dept_name
FROM employees e
LEFT JOIN dept_emp d
ON e.emp_no = d.emp_no
LEFT JOIN departments
ON d.dept_no = departments.dept_no;

--List all employees whose first name is "Hercules" and last names begin with "B"
SELECT * FROM employees
WHERE first_name LIKE 'Hercules' AND last_name LIKE '%B%';

--List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT
e.emp_no,
first_name,
last_name,
dept_name
FROM employees e
LEFT JOIN dept_emp d
ON e.emp_no = d.emp_no
LEFT JOIN departments
ON d.dept_no = departments.dept_no
WHERE departments.dept_name lIKE 'Sales';

--List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT
e.emp_no, 
first_name, 
last_name,
dept_name
FROM employees e
LEFT JOIN dept_emp d
ON e.emp_no = d.emp_no
LEFT JOIN departments
ON d.dept_no = departments.dept_no 
WHERE departments.dept_name lIKE 'Sales'
OR departments.dept_name LIKE 'Development';

--In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT
last_name,
COUNT(last_name) AS "employee_name_count"
from employees
GROUP BY
last_name
ORDER BY employee_name_count DESC;