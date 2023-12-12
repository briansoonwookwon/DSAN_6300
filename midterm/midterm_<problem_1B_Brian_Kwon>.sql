# 1.B. What other students are in the department that student Boyle is in? Return students’ names as well as their IDs, in ascending order of the names; use a subquery.
select name, ID
from student
where dept_name = (select dept_name from student where name = "Boyle")
order by name asc;
# 119 rows returned
