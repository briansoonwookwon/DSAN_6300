# 3. Enroll every student in the “Comp. Sci.” department in the section from Problem 2.
insert into takes (id, course_id, sec_id, semester, year)
select s.id,'CS-001', '1', 'Fall', 2017
from student as s
where s.dept_name = 'Comp. Sci.';

# 108 rows added