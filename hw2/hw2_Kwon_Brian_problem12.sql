# 12. Find out if there are students who have never taken a course at the university. Do this using SQL query with no sub-queries and no set operations (Hint: use an outer join).
select s.id, s.name
from student as s
left outer join takes as t on t.ID = s.ID
where t.ID is null;
# 0 row returned