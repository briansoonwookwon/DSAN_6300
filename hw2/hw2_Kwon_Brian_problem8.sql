# 8. For each student who has retaken a course at least twice (i.e., the student has taken the course at least three times), find the course ID and the student's ID. Display your results in order of course ID, and do not display duplicate rows.
select t.course_id, t.ID
from takes as t
group by t.ID, t.course_id
having count(*) >= 3;
# 10 rows returned