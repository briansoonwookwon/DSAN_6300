# Display a list of all instructors, showing each instructor's ID and the number of sections taught.
select i.ID, count(t.sec_id)
from instructor as i
left outer join teaches as t on t.ID = i.ID
group by i.ID;