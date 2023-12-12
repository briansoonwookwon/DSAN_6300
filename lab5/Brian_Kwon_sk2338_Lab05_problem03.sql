# Find the ID and name of each student who has took at least one course after 2017, make sure there are no duplicates in the result.
select distinct s.ID, s.name
from student as s
inner join takes as t on s.ID = t.ID
where t.year > 2017;

