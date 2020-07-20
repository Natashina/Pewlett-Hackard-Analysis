-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);
CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);
CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);
CREATE TABLE dept_emp (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (dept_no, emp_no)
);
CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(40) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);
COMMIT;
SELECT * FROM salaries;
-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
COMMIT;
SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Check the table
SELECT * FROM retirement_info;
COMMIT;
-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;
COMMIT;
--Using Aliases
SELECT ri.emp_no,
	ri.first_name,
ri.last_name,
	de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;
COMMIT;
-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;
COMMIT;

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');
COMMIT;
SELECT * FROM current_emp;
-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO e_count_by_dept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
COMMIT;
SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');
COMMIT;

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
COMMIT;
SELECT 	ce.emp_no,
		ce.first_name,
		ce.last_name,
		d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);
COMMIT;

SELECT 	ri.emp_no,
		ri.first_name,
		ri.last_name,
		de.dept_no
INTO Sales_emp
FROM retirement_info as ri
INNER JOIN dept_emp as de
ON (ri.emp_no = de.emp_no)
WHERE de.dept_no = ('d007');
COMMIT;

SELECT 	ri.emp_no,
		ri.first_name,
		ri.last_name,
		d.dept_name
INTO Sales_and_Dev_emp
FROM retirement_info as ri
INNER JOIN dept_emp as de
ON (ri.emp_no = de.emp_no)
INNER JOIN departments AS d
        ON (de.dept_no = d.dept_no)
WHERE de.dept_no IN ('d007', 'd005');
COMMIT;

-- Number of Retiring employees by Title
SELECT  e.emp_no,
		e.first_name, e.last_name,
		ti.title,
		ti.from_date,
		s.salary,
		de.to_date
INTO ret_emp_with_title
FROM employees as e
INNER JOIN titles as ti
        ON (e.emp_no = ti.emp_no)
INNER JOIN salaries as s
        ON (ti.emp_no = s.emp_no)
INNER JOIN dept_emp as de
        ON (s.emp_no = de.emp_no)		
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (de.to_date = '9999-01-01');

--This didn't work because some different employees with same first and last name
SELECT  rt.emp_no,
		rt.first_name,
		rt.last_name,
		rt.title,
		rt.salary,
		rt.from_date,
		rt.to_date 
INTO ret_emp_with_title_dedup
FROM ret_emp_with_title rt
inner join
(select first_name, last_name, MAX(from_date) as max_date from ret_emp_with_title group by first_name, last_name)dedup
on dedup.first_name= rt.first_name and dedup.last_name=rt.last_name and dedup.max_date = rt.from_date;
COMMIT;

--This did work, because we used emp_no instead of first, last name (1265 additional names here)
SELECT  rt.emp_no,
		rt.first_name,
		rt.last_name,
		rt.title,
		rt.salary,
		rt.from_date,
		rt.to_date 
--INTO ret_emp_with_title_dedup2
FROM ret_emp_with_title rt
inner join
(select emp_no, MAX(from_date) as max_date from ret_emp_with_title group by emp_no)dedup
on dedup.emp_no= rt.emp_no and dedup.max_date = rt.from_date

COMMIT;

SELECT COUNT(rtd.emp_no), rtd.title
INTO del1_titles_retiring
FROM ret_emp_with_title_dedup2 as rtd
GROUP BY rtd.title;
COMMIT;

ORDER BY de.dept_no;

DROP TABLE ret_emp_with_title CASCADE;

--DElivarable_1_2
SELECT 	e.emp_no,
		e.first_name,
		e.last_name,
		ti.title,
		ti.from_date,
		de.to_date
--INTO total_cur_empl_with_title
FROM employees as e
INNER JOIN titles as ti
        ON (e.emp_no = ti.emp_no)
INNER JOIN dept_emp as de
        ON (ti.emp_no = de.emp_no)		
WHERE (de.to_date = '9999-01-01');
COMMIT;

--DEl_1_2_part2_no_dublicates
SELECT 	emp_no,
		first_name,
		last_name,
		title,
		from_date,
		to_date
INTO total_cur_empl_with_title_dedup
FROM
(SELECT emp_no,
		first_name,
		last_name,
		title,
		from_date,
		to_date, ROW_NUMBER() OVER
(PARTITION BY (emp_no)
ORDER BY from_date DESC) rn
FROM total_cur_empl_with_title) tmp WHERE rn = 1
ORDER BY emp_no;
COMMIT;

SELECT COUNT(tcewtd.emp_no), tcewtd.title
INTO del1_2_count_by_titles
FROM total_cur_empl_with_title_dedup as tcewtd
GROUP BY tcewtd.title;
COMMIT;


--Deliverable 2
SELECT 	e.emp_no,
		e.first_name,
		e.last_name,
		ti.title,
		ti.from_date,
		de.to_date
INTO mentor_elig
FROM employees as e
INNER JOIN titles as ti
        ON (e.emp_no = ti.emp_no)
INNER JOIN dept_emp as de
        ON (ti.emp_no = de.emp_no)		
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01');
COMMIT;

SELECT 	emp_no,
		first_name,
		last_name,
		title,
		from_date,
		to_date
INTO mentors_elig_dedup
FROM
(SELECT emp_no,
		first_name,
		last_name,
		title,
		from_date,
		to_date, ROW_NUMBER() OVER
(PARTITION BY (emp_no)
ORDER BY from_date DESC) rn
FROM mentor_elig) tmp WHERE rn = 1
ORDER BY emp_no;
COMMIT;

