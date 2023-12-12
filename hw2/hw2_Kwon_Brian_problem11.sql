# 11. Rewrite the query select * from section natural join classroom without using a natural join but instead using an inner join with a using condition.
select *
from section
inner join classroom using (building, room_number);
# 100 rows returned