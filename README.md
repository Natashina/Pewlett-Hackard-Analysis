### Pewlett-Hackard-Analysis

# 1. Number of retiring employees by Title.

In order to get the table with retiring employees at first I've referred to the conceptual diagramm or ERD.

![Chart](EmployeeDB.PNG)

1.1 I've created a new Query in pgAdmin. Since information about employees is stored in different datasets, the original csv files, I had to reffer to "employees", "title", "salary" and "dept_emp" tables and using INNER JOIN on emp_no combined this information in one table (ret_emp_with_title). I've also indicated bithdate by WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31') and included AND statement as (de.to_date = '9999-01-01').

1.2 I've found the following example in order to deal with duplicates.
https://stackoverflow.com/questions/19432913/select-info-from-table-where-row-has-max-date
To eliminate duplicates at first I tried to use GROUP BY first name and last_name. However, the result was not correct, because these are not unique. There are some people in the company with exactly the same firt name and last name but different employee number.
Here is example of Query (approach 1):

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

Using group by emp_no was correct way to deal with duplicates. After I used different approach I've got additional 1265 names.
Therefore, the correct number of people who are going to retire is 72,458.
The results are shown in these two files: del_1_titles_retiring.csv file and del_1_3_ret_emp_with_title_dedup.csv.

I've also created a Query into new table total_current_employees_with_title.
Using PARTITION BY (emp_no) statement I've removed duplicates, I've created a new table total_cur_empl_with_title_dedup.
I've included GROUP BY title code to get del_1_2_count.csv file.
del1_2_count_by_titles

# 2. Mentorship Eligibility.

To create a table with no duplicates I've used another code (Approach 2). 
Example of the Query:
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

The result is presented in del_2_mentor_elig_dedup.csv file.
