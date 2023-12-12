#####
select - L04 p.32
from - L04 p.37
where - L04 p.36
    between - L04 p.49
    like - L04 p.46
    and, or, not - L04 p.36
    <, <=, >, >=, =, <> - L04 p.36
    any, in
rename - L04 p.44
    as
order by - L04 p.48
    desc
    asc
distinct - L04 p.33
intersect, union, except - L04 p.51
null - is null | not = null - L04 p.52
Aggregate Functions - L04 p.55
    avg
    min
    max
    sum
    count
    having - L04 p.60
Set membership - L05 p.6
    in
    not in
Set Comparison
    some - L05 p.8
    all - L05 p.10
Test for X
    exists - L05 p.12
    not exists - L05 p.14
    unique - L05 p.15 | L06 p.12
with - L05 p.16
check - L06 P.13
for - L06 p.38
if / elseif
Modification of the Database
    delete - L05 p.20
    insert - L05 p.23
    update - L05 p.25
    drop - L04 p.30
    alter - L04 p.30
    case - L05 p.26
Joins - L05 p.29
    natural
    outer
    left outer
    right outer
    full outer
    inner
create 
    trigger - L06 p.42
    role - L06 p.49
    function - L06 p.35
    procedure - L06 p.33
    view - L05 p.46
    table - L06 p.10



#BONUS points: Rewrite the query from 14.a) to only include instructors who have given at 
#least one (other than A) non-null grade in some course. (2 points)

select distinct instructor.ID, instructor.name
from instructor
where instructor.ID <> all (select distinct instructor.ID 
from instructor
left join teaches on instructor.ID = teaches.ID 
left join takes on teaches.course_id = takes.course_id and teaches.sec_id = takes.sec_id and teaches.semester = takes.semester and teaches.year = takes.year 
where grade = "A") 
and
instructor.ID = any (select distinct instructor.ID 
from instructor
left join teaches on instructor.ID = teaches.ID 
left join takes on teaches.course_id = takes.course_id and teaches.sec_id = takes.sec_id and teaches.semester = takes.semester and teaches.year = takes.year 
where grade = "A+" or grade = "A-" or grade = "B+" or grade = "B" or grade = "B-" or grade = "C+" or grade = "C" or grade = "C-")
#0 rows returned

#Find the ID and name of each instructor who has never given an A grade in any course she 
#or he has taught. (Instructors who have never taught a course trivially satisfy this condition.)

select distinct instructor.ID, instructor.name
from instructor
where instructor.ID <> all (select distinct instructor.ID 
from instructor
left join teaches on instructor.ID = teaches.ID 
left join takes on teaches.course_id = takes.course_id and teaches.sec_id = takes.sec_id and teaches.semester = takes.semester and teaches.year = takes.year 
where grade = "A")

#19 rows returned

#Create a view tot_credits (year, num_credits) that shows the total number of credits taken by 
#all students in each year. Use that view to output total credits by year. (7 points)


create view tot_credits as
select takes.year, sum(credits) as num_credits
from takes
left join course on takes.course_id = course.Course_id
group by takes.year;

select * from tot_credits;

#10 rows returned

#Find out if there are students who have never taken a course at the university. Do this using 
#SQL query with no sub-queries and no set operations (Hint: use an outer join).

select distinct *
from student
left join takes on takes.ID = student.ID
where takes.sec_id is null
#group by student.ID

#0 rows returned

#Rewrite the query
#select *
#from section natural join classroom
#without using a natural join but instead using an inner join with a using condition. 

select *
from section
inner join classroom on section.building = classroom.building and section.room_number = classroom.room_number

#100 rows returned

#Find the number of students in each section. The result columns should appear in the order 
#“course_id, sec_id, year, semester, num”. You do not need to output sections with no students.

select course_id, year, sec_id, semester, count(*) as num
from takes
group by course_id, year, sec_id, semester;

#100 rows returned

#Find the ID and title of each course in “Psychology” department that has had at least one 
#section with afternoon hours (i.e., ends at or after 12:00pm). Eliminate duplicates if any.

select distinct course.course_id, course.title
from section
left join time_slot on time_slot.time_slot_id = section.time_slot_id
left join course on course.course_id = section.course_id
where course.dept_name = "Psychology" and
time_slot.end_hr >= 12;

#4 rows returned

#For each student who has retaken a course at least twice (i.e., the student has taken the course 
#at least three times), find the course ID and the students ID. Display your results in order of 
#course ID, and do not display duplicate rows.

select course_id, ID
from takes
group by course_id, ID
having count(*) > 2
order by course_id asc

#10 rows returned

#Find the names of those departments whose budget is higher than that of “Geology” department. List them in alphabetic order.

select dept_name
from department
where budget > (select budget from department where dept_name = "Geology")
order by dept_name asc

#14 rows returned

#6. Find the name and ID of those students in the “Accounting” department who are advised by an instructor in the “Physics” department.

select student.ID, student.name
from student
left join advisor on student.ID = advisor.s_ID
left join instructor on advisor.i_ID = instructor.ID
where student.dept_name = "Accounting" and instructor.dept_name = "Physics"

#3 rows returned

#Delete the course “CS-001”.

delete from course
where course_id = "CS-001"
#1 row affected



#Note that deleting from the table in the problem 5a caused automatic cascading deletes in
#some other tables in order to preserve referential integrity (foreign key constraints).
#What tables are affected and how exactly?

#Answer 5b: The entry in the course table is deleted because it is imcplitily stated in the statement. 
#The takes and section tables are also affected becasue of the cascade effect.

#Delete enrollment in the section from Problem 3 where the students ID is 1402.

delete from takes
where id = 1402 and course_id = "CS-001"

#1 row affected

#Enroll every student in the “Comp. Sci.” department in the section from Problem 2.

insert into takes (course_id, sec_id, semester, year, ID)
select "CS-001", "1", "Fall", 2017, ID from student where dept_name = "Comp. Sci."

#108 rows affected

#Create a section of the course from Problem 1 in Fall 2017, with sec_id of 1, and with the location of this section not yet specified.

insert into section (course_id, sec_id, semester, year)
values ("CS-001", "1", "Fall", 2017)

#1 row affected

#Create a new course “CS-001”, titled “Weekly Seminar”, with 3 credits. (4 points)

insert into course (course_id,title,credits)
values ("CS-001", "Weekly Seminar", 3)

#1 row affected

#Add a Finance department student with the last name ‘Green’, and student ID = 3003

insert into student (ID, name, dept_name)
values (3003, "Green", "Finance")

#1 row inserted

#Change the last name of the student ID=3003 from Green to Brown

update student
set name = "Brown"
where name = "Green" and
ID = 3003

#1 rows changed

# Delete the student with ID=3003

delete from student
where ID = 3003

#1 row deleted

#Display a list of all instructors, showing each instructors ID and the number of sections taught. Make sure to show the number of sections as 0 for instructors who have not taught any section.

select instructor.ID, name, count(sec_id)
from instructor
left join teaches on teaches.ID = instructor.ID
group by name

#returns 50 rows

#Find the enrollment (=number of students) of each section of each course that was offered in Fall 2017.

select course_id, sec_id, count(*)
from takes
inner join student on takes.ID = student.ID
where semester = 'Fall' and
year = 2017
group by course_id, sec_id

#returned 6 rows


#Find instructors earning the highest salary (there may be more than one with the same salary).

select ID, name
from instructor
where salary = (select max(salary)
from instructor)

#returned 1 row

#Find the highest salary of any instructor.

select salary
from instructor
having max(salary)

#returned 1 row

#Delete all courses that have never been offered (i.e. do not occur in the section relation).

delete course
from course
left join section on course.course_id = section.course_id
where sec_id is NULL

#115 rows affected

#Increase the salary of each instructor in the Comp. Sci. department by 10%.

update instructor
set salary = salary + (salary * 10 / 100)
where dept_name = "Comp. Sci."

#2 rows affected

#Find the ID and name of each student who has took at least one course after 2017, make sure there are noduplicates in the result.

select distinct student.ID, name
from student, takes
where student.ID = takes.ID and
takes.year > 2017

#1921 rows returned

#Find the ID and name of each student who has taken at least one Comp. Sci. course; make sure there are no duplicates in the result

select distinct student.ID, name
from student, takes, course
where student.ID = takes.ID and
takes.course_ID = course.course_ID and
course.dept_name = "Comp. Sci."

#993 rows returned

#######################################################################################################################

-- 1. Create a new course “CS-001”, titled “Weekly Seminar”, with 3 credits.
insert into course
values ('CS-001', 'Weekly Seminar', 'Comp. Sci.', 3)

-- 2. Create a section of the course from Problem 13 in Fall 2017, with sec_id of 1, and with the
-- location of this section not yet specified.
insert into section
values ('CS-001', 1, 'Fall', 2017, null, null, null)

-- 3. Enroll every student in the Comp. Sci. department in the section from Problem 14
insert into takes
select ID, 'CS-001', 1, 'Fall', 2017, null
from student
where dept name = 'Comp. Sci.'

-- 4. Delete enrollment in the section from Problem 15 where the student's ID is 1402.
delete from takes
where course_id= 'CS-001' and sec_id = 1 and
year = 2017 and semester = 'Fall' and ID=1402

-- 5. Delete the course CS-001. What will happen if you run this delete statement without first
-- deleting offerings (sections) of this course?
delete from takes
where course id = 'CS-001';
delete from section
where course id = 'CS-001';
delete from course
where course id = 'CS-001';

-- 6. Using the university schema, write an SQL query to find the name and ID of those Accounting
-- students advised by an instructor in the Physics department.
select student.ID, student.name
from student, advisor, instructor
where student.ID = advisor.s_ID
and instructor.ID= advisor.i_iD
and student.dept_name= 'Accounting'
and instructor.dept_name= 'Physics';

-- 3 rows

-- 7. Using the university schema, write an SQL query to find the names of those departments
-- whose budget is higher than that of Geology. List them in alphabetic order.
select X.dept_name
from department as X, department as H
where H.dept_name = 'Geology' and X.budget > H.budget
order by X.dept_name;
-- 14 rows

-- 8. Using the university schema, use SQL to do the following: For each student who has retaken
-- a course at least twice (i.e., the student has taken the course at least three times), show the
-- course ID and the student's ID.
-- Please display your results in order of course ID and do not display duplicate rows.
select distinct ID, course_id
from takes
group by ID, course_id
having count(*) > 2
order by course_id;
-- 10 rows

-- 9. Using the university schema, write an SQL query to find the ID and title of each course in
-- Psychology that has had at least one section with afternoon hours (i.e., ends at or after
-- 12:00pm). (You should eliminate duplicates if any.)
select distinct course.course_id, course.title
from course, section, time_slot
where course.course_id = section.course_id
and section.time_slot_id = time_slot.time_slot_id
and time_slot.end_hr >= 12
and course.dept_name = 'Psychology';
-- 5 rows

-- 10. Using the university schema, write an SQL query to find the number of students in each
-- section. The result columns should appear in the order “course_id, sec_id, year, semester,
-- num”. You do not need to output sections with 0 students.
select course_id, sec_id, `year`, semester, count(*) as num
from takes
group by course_id, sec_id, `year`, semester
-- 100 rows

-- 11. Rewrite the query
select *
from section natural join classroom
without using a natural join but instead using an inner join with a using condition
select *
from section join classroom using (building, room number)
-- 100 rows

-- 12. Write an SQL query using the university schema to find if there are students
-- who have never taken a course at the university. Do this using no subqueries and
-- no set operations (use an outer join).
select ID
from student left outer join takes using (ID)
where course_id is null
-- 0 rows

-- 13. Create a view tot_credits (year, num_credits), that shows the total number of credits taken by
-- all student in each year.
create view tot_credits(`year`, num_credits) as
select `year`, sum(credits)
from takes natural join course
group by `year`;
select * from tot_credits;
-- 10 rows

-- 14. Using the university schema, write an SQL query to find the ID and name of each instructor
-- who has never given an A grade in any course she or he has taught. (Instructors who have never
-- taught a course trivially satisfy this condition.)
select A.ID, A.`name`
from instructor A
where NOT EXISTS
(select B.ID
from instructor B, teaches, takes
where A.ID = teaches.ID
and teaches.course_id = takes.course_id
and teaches.`year` = takes.`year`
and teaches.semester= takes.semester
and teaches.sec_id= takes.sec_id
and takes.grade = 'A ');
-- 19 rows. Note: Please make a note of A in last line is followed by a space, since grade has a
-- datatype of varchar(2).

-- 15. (bonus) Rewrite the preceding query, but also ensure that you include only instructors who
-- have given at least one other non-null grade in some course
select distinct instructor.ID, instructor.name
from instructor, teaches, takes
where instructor.ID = teaches.ID
and teaches.course_id = takes.course_id
and teaches.year = takes.year
and teaches.semester = takes.semester
and teaches.sec_id = takes.sec_id
and takes.grade is not null
and instructor.ID in (
select A.ID
from instructor A
where NOT EXISTS
(select B.ID
from instructor B, teaches, takes
where A.ID = teaches.ID
and teaches.course_id = takes.course_id
and teaches.`year` = takes.`year`
and teaches.semester= takes.semester
and teaches.sec_id= takes.sec_id
and takes.grade = 'A ')
);
-- 0 rows. Note: since the instructors who taught some courses and gave non-null grades, but never
-- gave ‘A’, do not exist.

-- #last name begins with the letter 'S' and who has not taken at least 9 out of all courses offered by
-- #'Cybernetics' department.

select student.name, student.ID
from student
left join takes on student.ID = takes.ID
left join course on takes.course_id = course.course_id
where name like 'S%' and
student.dept_name = 'Statistics' 
and course.dept_name = 'Cybernetics'
group by student.name, student.ID
having count(*) <9;
-- 7 rows returned

#Find names and salaries of instructors who never taught a course offered by her or his
#department. (one query)

select distinct instructor.name, instructor.salary
from instructor
where instructor.ID not in (select distinct instructor.ID
from instructor
left join teaches on instructor.id = teaches.id
left join course on teaches.course_id = course.course_id 
where instructor.dept_name = course.dept_name);

#28 rows returned

#Rank order all students by total credit.

select *
from student
order by tot_cred

#2000 rows returned

#Create a table prereq1 that has the same column names and column types as the table prereq and
#the same records as the table prereq.

create table prereq1 as (select * from prereq);

#100 rows affected

#Delete records: with
#course_id=133 and prereq_id=852
#and
#course_id=634 and prereq_id=864
#from the table prereq1.
#You can use 2 sql statements

delete from prereq1
where (course_id=133 and prereq_id=852) or (course_id=634 and prereq_id=864);

#2 rows affected