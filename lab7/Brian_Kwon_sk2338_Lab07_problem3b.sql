# 3b Compute average number of credits over three preceding years per department using the view you created in 3a
select year, dept_name, avg(num_credits) over (partition by dept_name order by year rows 3 preceding) as avg_total_credits
from tot_credits_dept;
# 76 rows returned