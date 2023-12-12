# 3.B. What is the greatest number of courses offered by a department among all the departments in the University? Return only the number of courses.
with num_course(value) as (select count(course_id) as num_class from course group by dept_name)
select max(value)
from num_course;
# 1 row returned
