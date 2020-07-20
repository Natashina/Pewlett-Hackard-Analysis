### Pewlett-Hackard-Analysis

1. Number of retiring employees by Title.
In order to get the table with retiring employees at first I've referred to the conceptual diagramm or ERD.

![Chart](EmployeeDB.PNG)

1.1 I've created a new Query in pgAdmin. Since information about employees is stored in different datasets, the original csv files, I had to reffer to "employees", "title", "salary" and "dept_emp" tables and using INNER JOIN on emp_no combined this information in one table (ret_emp_with_title). I've also indicated bithdate by WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31') and included AND statement as (de.to_date = '9999-01-01').

1.2 To eliminate duplicates at first I tried to use GROUP BY first name and last_name. However, the result was not correct, because these are not unique. There are some people in the company with exactly the same firt name and last name but different employee number.
Using group by emp_no is correct way to deal with duplicates. After I used different approach I've got additional 1265 names.
Therefore, the correct number of people who are going to retire is 72,458.


I've also created a Query into new table total_current_employees_with_title.
Using PARTITION BY (emp_no) statement I've removed duplicates, I've created a new table total_cur_empl_with_title_dedup.
I've included GROUP BY title code to get del1_2_count_by_titles.csv file.

2.1.




