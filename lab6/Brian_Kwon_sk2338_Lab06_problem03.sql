# Find the enrollment (=number of students) of each section of each course that was offered in Fall 2017.
select t.course_id,t.sec_id, count(t.ID)
from takes as t
where t.year = 2017 and t.semester = "Fall"
group by course_id, sec_id;