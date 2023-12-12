# 2d Rank order all students by total credit
select ID, rank() over (order by (tot_cred) desc) as s_rank 
from student
order by s_rank;
# 2000 rows returned