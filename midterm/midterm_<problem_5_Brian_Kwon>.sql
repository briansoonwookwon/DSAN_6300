# 5. All instructors with salary lower than 40,000 are in fact new Ph.D. students in the same department, but that information is missing from the student table. Fix that problem by creating appropriate students' records; use 0 credits as the total credit.
insert into student
select ID, name, dept_name, 0
from instructor
where salary < 40000;
# 4 rows affected