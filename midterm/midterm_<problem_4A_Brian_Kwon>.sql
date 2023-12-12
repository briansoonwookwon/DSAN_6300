# 4.A. Find the name, id and building of instructors whose department office is located in the building which name contains Lamb.
select i.name, i.ID, d.building
from instructor as i
left join department as d on i.dept_name = d.dept_name
where d.building like '%Lamb%';
# 6 row returned