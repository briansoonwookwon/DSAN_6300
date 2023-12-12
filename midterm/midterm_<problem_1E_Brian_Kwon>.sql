# 1.E. What is the number of students whom instructor Bietzk advises to in each of these departments? Show the department name, and the number of students in descending order with a meaningful header name.
select s.dept_name, count(s.id) as num_student
from student as s
left join advisor as a on a.s_ID = s.ID
left join instructor as i on a.i_ID = i.ID
where i.name = "Bietzk"
group by s.dept_name
order by num_student desc;
# 18 rows returned