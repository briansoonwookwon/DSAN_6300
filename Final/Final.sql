# Find the ID and name of each student who has took at least one course after 2017, make sure there are no duplicates in the result.
select distinct s.ID, s.name
from student as s
inner join takes as t on s.ID = t.ID
where t.year > 2017;

# Find the ID and name of each student who has taken at least one Comp. Sci. course; make sure there are no duplicates in the result
select distinct s.ID, s.name
FROM student AS s
INNER JOIN takes AS t ON s.ID = t.ID
INNER JOIN course AS c ON t.course_id = c.course_id 
WHERE c.dept_name = 'Comp. Sci.';

# Find the highest salary of any instructor
select max(salary) as max_salary 
from instructor;

# Find instructors earning the highest salary (there may be more than one with the same salary).
select i.name
from instructor as i
where i.salary = 
	(select max(salary) as max_salary from instructor);
    
# Find the enrollment (=number of students) of each section of each course that was offered in Fall 2017.
select t.course_id,t.sec_id, count(t.ID)
from takes as t
where t.year = 2017 and t.semester = "Fall"
group by course_id, sec_id;

# Display a list of all instructors, showing each instructor's ID and the number of sections taught.
select i.ID, count(t.sec_id)
from instructor as i
left outer join teaches as t on t.ID = i.ID
group by i.ID;

# Add a Finance department student with the last name Green, and student ID=3003
insert into student values ('3003', 'Green', 'Finance', null);

# Change the last name of the student ID=3003 from Green to Brown
update student set name='Brown' where id=3003;

# Delete the student with ID=3003
delete from student where id=3003;

# Increase the salary of each instructor in the Comp. Sci. department by 10%.
update instructor set salary = salary * 1.10 where dept_name = 'Comp. Sci.';

# Delete all courses that have never been offered (i.e. do not occur in the section relation).
delete from course where course_id not in (select course_id from section);

# 2c Get the average total credits over all prior years
create view tot_credits as
select year, sum(credits) as num_credits from takes natural join course
group by year;

select year, avg(num_credits)
over (order by year rows unbounded preceding) as avg_total_credits
from tot_credits;
# 10 rows returned

# 2d Rank order all students by total credit
select ID, rank() over (order by (tot_cred) desc) as s_rank 
from student
order by s_rank;
# 2000 rows returned

# 3a With the total number of credits taken by all students in each year for courses offered by each department
create view tot_credits_dept(year,dept_name,num_credits) as (
    select year, dept_name, sum(credits)
    from takes as t
    natural join course
    group by t.year, course.dept_name
);

select * from tot_credits_dept
order by dept_name, year;
# 76 rows returned 

# 3b Compute average number of credits over three preceding years per department using the view you created in 3a
select year, dept_name, avg(num_credits)
over (partition by dept_name order by year rows 3 preceding) as avg_total_credits
from tot_credits_dept;
# 76 rows returned

select *
from tot_credits_dept
where dept_name = "Biology"
order by year;

# 4 Compute maximum number of credits over for the window of 2 years before and 2 years after the current year per department
select year, dept_name, max(num_credits)
over (partition by dept_name order by year rows between 2 preceding and 2 following) as max_total_credits
from tot_credits_dept;
# 76 rows returned

# 5.A Write a query that calculates number of students that received each possible grade per each course, each year. 
# The query should provide count summaries by year by course_id, and also by year totals.
select course_id, year, grade, count(*) as count
from student as s
left join takes as t on t.ID = s.ID
group by year, course_id, grade with rollup;
# 1001 rows returned

# 5.B Modify the previous query to output meaningful labels instead if NULLs, You can use functions if() and grouping().
select course_id, if(grouping(year), 'all', year) as year, 
if(grouping(grade), 'all', grade) as grade, count(*) as count
from student as s
left join takes as t on t.ID = s.ID
group by year, course_id, grade with rollup;
# 1001 rows returned

# 1. Create two new tables takes1 and course1. The tables have the same schema and data as takes and course tables, 
# but do not have any indices on them.
create table takes1 as select * from takes;
# 30000 rows affected
create table course1 as select * from course;
# 200 rows affected

# 2. Run a query that outputs titles of all courses that were taught in 2013. Review execution plan.
select distinct title
from course1 as c
left join takes1 as t on c.course_id = t.course_id
where t.year = 2013;
# 12 rows returned

# 3. Create an index on the attribute course_id for table course1. Rerun the query. Review the execution plan
create index idx_course_id on course1(course_id);

# 1. Write one SQL query to find the name and ID of each student from 'Statistics' department 
# whose last name begins with the letter 'S' and who has not taken at least 9 out of all courses offered by 'Cybernetics' department.
select s.name, s.ID
from student as s
left join takes as t on s.ID = t.ID
left join course as c on t.course_id = c.course_id
where s.dept_name = "Statistics" and s.name like 'S%' and c.dept_name = "Cybernetics"
group by s.name, s.ID
having count(*) < 9;
# 7 rows returned

# 2. Find names and salaries of instructors who never taught a course offered by her or his department.
select name,salary
from instructor as i
where i.ID not in 
	(select i.ID 
    from instructor as i
	left join teaches as t on i.ID = t.ID
	left join course as c on t.course_id = c.course_id
	where i.dept_name = c.dept_name);
# 16 rows returned

# 3. Rank order all students by total credit.
select ID, rank() over (order by (tot_cred) desc) as s_rank 
from student
order by s_rank;
# 2000 rows returned

# 4. Create a table prereq1 that has the same column names and column types as the table prereq and the same records as the table prereq.
create table prereq1 as select * from prereq;
# 100 rows affected

# 5.  Delete records: with course_id=133 and prereq_id=852 and course_id=634 and prereq_id=864 from the table prereq1. You can use 2 sql statements.
delete from prereq1 where course_id = "133" and prereq_id = "852";
# 1 row affected
delete from prereq1 where course_id = "634" and prereq_id = "864";
# 1 row affected

# 6. Write a query to find out which courses in the table prereq1 are prerequisites, whether directly or indirectly, for any course. 
# The query should also show how many intermediate levels are between the prerequisite and the course.
with recursive rec_prereq(course_id, prereq_id, level) as (
select course_id, prereq_id, 0 as level
from prereq1
union
select rec_prereq.course_id, prereq1.prereq_id, rec_prereq.level + 1
from rec_prereq, prereq1
where rec_prereq.prereq_id = prereq1.course_id
)
select *
from rec_prereq;
# 169 rows returned

# 7. Write a recursive query to check if a pre-requisite table has cycles, that is, courses that are prerequisites, possible indirectly, of themselves.
# The query should return the list of IDs of courses that are prerequisites, possible indirectly, of themselves, or an empty result set, if there are no cycles.
# a. Run the query against prereq table
with recursive rec_prereq(course_id, prereq_id) as ( select course_id, prereq_id
from prereq
union
select rec_prereq.course_id, prereq.prereq_id 
from rec_prereq, prereq
where rec_prereq.prereq_id = prereq.course_id
)
select *
from rec_prereq
where course_id = prereq_id;
# 4 rows returned 

# b. Run the query against prereq1 table
with recursive rec_prereq(course_id, prereq_id) as ( select course_id, prereq_id
from prereq1
union
select rec_prereq.course_id, prereq1.prereq_id 
from rec_prereq, prereq1
where rec_prereq.prereq_id = prereq1.course_id
)
select *
from rec_prereq
where course_id = prereq_id;
# 0 rows returned

# 8. Delete the table prereq1.
drop table prereq1;
# 0 rows affected

# 1.A What is the department name and a total credit earned by a student Boyle? Return the department name and a total credit for that student.
select dept_name, tot_cred
from student
where name = "Boyle";
# 1 row returned

# 1.B. What other students are in the department that student Boyle is in? Return students’ names as well as their IDs, in ascending order of the names; use a subquery.
select name, ID
from student
where dept_name = (select dept_name from student where name = "Boyle")
order by name asc;
# 119 rows returned

# 1.C. What grades the student Boyle got in the years 2017 and 2018? List his course IDs and grades.
select course_id, grade
from takes
left join student on student.ID = takes.ID
where student.name = "Boyle" and (takes.year = 2017 or takes.year = 2018);
# 3 rows returned 

# 1.D. In what departments are the students whom instructor Bietzk advises to? Show each department only once.
select distinct s.dept_name
from student as s
left join advisor as a on a.s_ID = s.ID
left join instructor as i on a.i_ID = i.ID
where i.name = "Bietzk";
# 18 rows returned

# 1.E. What is the number of students whom instructor Bietzk advises to in each of these departments? Show the department name, and the number of students in descending order with a meaningful header name.
select s.dept_name, count(s.id) as num_student
from student as s
left join advisor as a on a.s_ID = s.ID
left join instructor as i on a.i_ID = i.ID
where i.name = "Bietzk"
group by s.dept_name
order by num_student desc;
# 18 rows returned

# 2.A. Add two new students Potter and Dumbledore that just got accepted to the Marketing department. Assign IDs as 1111 and 1112, assign NULL to the number of credits. You can use two queries.
insert into student (ID, name, dept_name, tot_cred) values ('1111','Potter', 'Marketing', null);
insert into student (ID, name, dept_name, tot_cred) values ('1112','Dumbledore', 'Marketing', null);
# 2 rows affected

# 2.B. Student Dumbledore started studying with 100 total credits (transferred from another university). Reflect that in the database.
update student set tot_cred=100 where id=1112;
# 1 row affected

# 2.C. Student Potter was expelled for not attending enough office hours. :) Reflect that in the database. University policy for the expelled students is that their record is deleted.
delete from student where ID = 1111;
# 1 row affected

# 3.A. Find out how many courses are offered by each department where department name starts with the letter "C". Return the department name as well as the number of courses offered.
select dept_name, count(course_id) as num_course
from course
where dept_name like "C%"
group by dept_name;
# 3 rows returned

# 3.B. What is the greatest number of courses offered by a department among all the departments in the University? Return only the number of courses.
with num_course(value) as (select count(course_id) as num_class from course group by dept_name)
select max(value)
from num_course;
# 1 row returned

# 4.A. Find the name, id and building of instructors whose department office is located in the building which name contains Lamb.
select i.name, i.ID, d.building
from instructor as i
left join department as d on i.dept_name = d.dept_name
where d.building like '%Lamb%';
# 6 row returned

# 4.B. These instructors cannot be student’s advisors any longer. Reflect that fact in the database by deleting appropriate records.
delete from advisor where i_ID in
	(select i.ID
	from instructor as i
	left join department as d on i.dept_name = d.dept_name
	where d.building like '%Lamb%');
# 224 rows affected

# 5. All instructors with salary lower than 40,000 are in fact new Ph.D. students in the same department, but that information is missing from the student table. Fix that problem by creating appropriate students' records; use 0 credits as the total credit.
insert into student
select ID, name, dept_name, 0
from instructor
where salary < 40000;
# 4 rows affected

# 6. Find the names of all students who have taken at least one course more than 2 times.  Return student's name and ID.
select s.name, s.ID
from student as s
left join takes as t on t.ID = s.ID
group by s.name
having count(*) > 2;
# 1568 rows returned

# 7. Among all sections taught by instructors of the Physics department, what was the minimum and the maximum number of sections taught by an instructor?
with num_sec(value) as (select count(s.course_id) 
	from section as s
	left join course as c on s.course_id = c.course_id
	where c.dept_name = "Physics"
	group by c.course_id)
select max(value), min(value)
from num_sec;
# 1 row returned