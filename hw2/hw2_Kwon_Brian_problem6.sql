# 6. Find the name and ID of those students in the “Accounting” department who are advised by an instructor in the “Physics” department.
select s.name, s.id
from student as s
left outer join advisor as a on a.s_ID = s.ID
left outer join instructor as i on a.i_ID = i.ID
where s.dept_name = "Accounting" and i.dept_name = "Physics";
# 3 rows returned