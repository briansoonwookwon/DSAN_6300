# 1. Find all students from Math department who got at least one A+ in 2019.
# Output student ID and student name.
select distinct s.ID, s.name
from student as s
inner join takes as t on s.ID = t.ID
where s.dept_name = "Math" and t.grade = "A+" and year = 2019;
# 10 rows returned

# 2. Find all students from Math department who got more than one A+ in 2019.
# Output student ID, student name, and the number of A+ courses.
select ID, name, count
from (
	select distinct s.ID, s.name, count(*) as count
	from student as s
	inner join takes as t on s.ID = t.ID
	where s.dept_name = "Math" and t.grade = "A+" and year = 2019
	group by s.ID) as subquery
where count > 1;
# 2 rows returned

# 3. Find all instructors (names and IDs) who taught at least one course in the 'Taylor' building in the Fall of 2019.
select i.name, i.ID
from instructor as i
inner join teaches as t on i.ID = t.ID
inner join section as s on t.course_id = s.course_id
where t.year = 2019 and t.semester = "Fall" and s.building = "Taylor";
# 2 rows returned

# 4. Find student(s) with the maximum total credit. 
# Output student name, ID, and department; order by department name.
select s.name, s.ID, s.dept_name
from student as s
where s.tot_cred = (
	select max(tot_cred) from student)
order by s.dept_name;
# 13 rows returned

# 5A. Create the table student2 with the schema:
# student2((ID varchar(5), name varchar(20), dept_name varchar(20)).
# Make ID a primary key. Enforce that name cannot be NULL.
create table student2 (
    ID varchar(5) primary key,
    name varchar(20) not null,
    dept_name varchar(20)
);
# 0 row affected

# 5B. Insert student records from the table student into the table student2.
# Include only records for students with the total credit > 100.
insert into student2 (ID, name, dept_name)
select ID, name, dept_name
from student
where tot_cred > 100;
# 463 rows affected

# 5C. 'Math', 'Statistics' and 'Comp. Sci.' departments merged into a ‘Data Science', department. 
# Update the table student2 to reflect that.
update student2 set dept_name = "Data Science"
where dept_name in ("Math", "Statistics", "Comp. Sci");
# 46 rows affected

# 6. For each course, calculate the number of times the students took that course. 
# Output course id and the number of times; output 0, if nobody took that course. 
# If a student took some course more than once, include all those times. 
# Order the results from the largest number of times to the smallest.
select c.course_id, count(*) as count
from course as c
left join takes as t on c.course_id = t.course_id
group by c.course_id
order by count desc;
# 200 rows returned

# 7. Calculate the number of courses each instructor taught per each year, each semester. 
# Also include in the (same) output the instructor ID and the following count summaries:
# - by instructor ID by semester
# - by instructor ID by year
# - by instructor ID by totals
# - the total number of courses taught by all instructors in all semesters of all years
select i.ID, t.year, t.semester, count(*) as count
from instructor as i
inner join teaches as t on i.ID = t.ID
group by ID, year, semester with rollup;
# 202 rows returned

# 8. For each department, find the student(s) with the maximum total credit of all students from that department. 
# Output student name, ID, department, and total credit. Order by department name.
# Note: make sure that if more than one student in a department has a maximum total credit, all of them are included in the result set.
select s.name, s.ID, s.dept_name, s.tot_cred
from student as s
where (s.dept_name,s.tot_cred) = (
	select dept_name, max(tot_cred) as max
	from student
    where dept_name = s.dept_name
	group by dept_name)
order by s.dept_name;
# 30 rows returned