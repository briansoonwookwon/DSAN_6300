# Find instructors earning the highest salary (there may be more than one with the same salary).
select i.name
from instructor as i
where i.salary = 
	(select max(salary) as max_salary from instructor);