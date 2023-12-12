# 1.C. What grades the student Boyle got in the years 2017 and 2018? List his course IDs and grades.
select course_id, grade
from takes
left join student on student.ID = takes.ID
where student.name = "Boyle" and (takes.year = 2017 or takes.year = 2018);
# 3 rows returned 