# 9. Find the ID and title of each course in “Psychology” department that has had at least one section with afternoon hours (i.e., ends at or after 12:00pm). Eliminate duplicates if any.
select distinct c.course_id, c.title
from course as c
left outer join section as s on c.course_id = s.course_id
left outer join time_slot as t on s.time_slot_id = t.time_slot_id
where c.dept_name = "Psychology" and t.end_hr >= 12;
# 5 rows returned