# 7. Among all sections taught by instructors of the Physics department, what was the minimum and the maximum number of sections taught by an instructor?
with num_sec(value) as (select count(s.course_id) 
	from section as s
	left join course as c on s.course_id = c.course_id
	where c.dept_name = "Physics"
	group by c.course_id)
select max(value), min(value)
from num_sec;
# 1 row returned