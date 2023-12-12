# 14. a) Find the ID and name of each instructor who has never given an A grade in any course she or he has taught. (Instructors who have never taught a course trivially satisfy this condition.)
select i.id, i.name
from instructor as i
where i.id not in
	(select i.id from instructor as i
    inner join teaches on teaches.ID = i.ID
	inner join takes on (teaches.course_id,teaches.sec_id,teaches.semester,teaches.year) = (takes.course_id,takes.sec_id,takes.semester,takes.year)
    where takes.grade = 'A');
# 19 rows