# 10. Find the number of students in each section. The result columns should appear in the order “course_id, sec_id, year, semester, num”. You do not need to output sections with no students.
select t.course_id, t.sec_id, t.year, t.semester, count(s.id) as num
from student as s
left outer join takes as t on t.ID = s.ID
group by t.sec_id, t.course_id;
# 100 rows returned