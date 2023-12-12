# 6. Find the names of all students who have taken at least one course more than 2 times.  Return student's name and ID.
select s.name, s.ID
from student as s
left join takes as t on t.ID = s.ID
group by s.name
having count(*) > 2;
# 1568 rows returned