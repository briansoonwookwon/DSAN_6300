# 1.D. In what departments are the students whom instructor Bietzk advises to? Show each department only once.
select distinct s.dept_name
from student as s
left join advisor as a on a.s_ID = s.ID
left join instructor as i on a.i_ID = i.ID
where i.name = "Bietzk";
# 18 rows returned