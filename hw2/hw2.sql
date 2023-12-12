# 1. Create a new course “CS-001”, titled “Weekly Seminar”, with 3 credits.
insert into course (course_id, title, credits) values ('CS-001','Weekly Seminar', 3);

# 2. Create a section of the course from Problem 1 in Fall 2017, with sec_id of 1, and with the location of this section not yet specified.course
insert into section (course_id, sec_id, semester, year) values ('CS-001', '1', 'Fall', 2017); 

# 3. Enroll every student in the “Comp. Sci.” department in the section from Problem 2.
insert into takes (id, course_id, sec_id, semester, year)
select s.id,'CS-001', '1', 'Fall', 2017
from student as s
where s.dept_name = 'Comp. Sci.';

# 4. Delete enrollment in the section from Problem 3 where the student's ID is 1402.
delete from takes where ID = 1402 and course_id = 'CS-001';

# 5. a) Delete the course “CS-001”. (2 points)
delete from course where course_id='CS-001';
# 5. b) takes, students tables are affectedcourse

# 6. Find the name and ID of those students in the “Accounting” department who are advised by an instructor in the “Physics” department.
select s.name, s.id
from student as s
left outer join advisor as a on a.s_ID = s.ID
left outer join instructor as i on a.i_ID = i.ID
where s.dept_name = "Accounting" and i.dept_name = "Physics";
# 3 rows returned

# 7. Find the names of those departments whose budget is higher than that of “Geology” department. List them in alphabetic order.
select dept_name
from department
where budget >
	(select budget from department where dept_name = "Geology");
# 14 rows returned

# 8. For each student who has retaken a course at least twice (i.e., the student has taken the course at least three times), find the course ID and the student's ID. Display your results in order of course ID, and do not display duplicate rows.
select t.ID, t.course_id
from takes as t
group by t.ID, t.course_id
having count(*) >= 3;
# 10 rows returned

# 9. Find the ID and title of each course in “Psychology” department that has had at least one section with afternoon hours (i.e., ends at or after 12:00pm). Eliminate duplicates if any.
select distinct c.course_id, c.title
from course as c
left outer join section as s on c.course_id = s.course_id
left outer join time_slot as t on s.time_slot_id = t.time_slot_id
where c.dept_name = "Psychology" and t.end_hr >= 12;
# 5 rows returned

# 10. Find the number of students in each section. The result columns should appear in the order “course_id, sec_id, year, semester, num”. You do not need to output sections with no students.
select t.course_id, t.sec_id, t.year, t.semester, count(s.id) as num
from student as s
left outer join takes as t on t.ID = s.ID
group by t.sec_id, t.course_id;
# 100 rows returned

# 11.
select *
from section
inner join classroom using (building, room_number);
# 100 rows returned

# 12. Find out if there are students who have never taken a course at the university. Do this using SQL query with no sub-queries and no set operations (Hint: use an outer join).
select s.id, s.name
from student as s
left outer join takes as t on t.ID = s.ID
where t.ID is null;
# 0 row

# 13. Create a view tot_credits (year, num_credits) that shows the total number of credits taken by all students in each year. Use that view to output total credits by year.
create view tot_credits(year,num_credits) as (
    select year, sum(credits)
    from takes as t
    natural join course
    group by t.year
);

select * from tot_credits;
# 10 rows

# 14. a) Find the ID and name of each instructor who has never given an A grade in any course she or he has taught. (Instructors who have never taught a course trivially satisfy this condition.)
select i.id, i.name
from instructor as i
where i.id not in
	(select i.id from instructor as i
    inner join teaches on teaches.ID = i.ID
	inner join takes on (teaches.course_id,teaches.sec_id,teaches.semester,teaches.year) = (takes.course_id,takes.sec_id,takes.semester,takes.year)
    where takes.grade = 'A');
# 19 rows

# 14. (b) Rewrite the query from 14.a) to only include instructors who have given at least one (other than A) non-null grade in some course.
select i.id, i.name
from instructor as i
where i.id not in
	(select i.id from instructor as i
    inner join teaches on teaches.ID = i.ID
	inner join takes on (teaches.course_id,teaches.sec_id,teaches.semester,teaches.year) = (takes.course_id,takes.sec_id,takes.semester,takes.year)
    where takes.grade is null or takes.grade = "A");
# 50 rows

SELECT id, name 
FROM instructor AS i
WHERE 'A' NOT IN (
    SELECT takes.grade
    FROM takes INNER JOIN teaches 
        ON (takes.course_id,takes.sec_id,takes.semester,takes.year) = 
           (teaches.course_id,teaches.sec_id,teaches.semester,teaches.year)
    WHERE teaches.id = i.id
) 
AND
(
    SELECT COUNT(*)
    FROM takes INNER JOIN teaches 
        ON (takes.course_id,takes.sec_id,takes.semester,takes.year) = 
           (teaches.course_id,teaches.sec_id,teaches.semester,teaches.year)
    WHERE teaches.id = i.id AND takes.grade IS NOT NULL    
) >= 1