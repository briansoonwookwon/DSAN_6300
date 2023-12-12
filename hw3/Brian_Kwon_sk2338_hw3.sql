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