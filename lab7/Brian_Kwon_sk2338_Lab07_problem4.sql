# 4 Compute maximum number of credits over for the window of 2 years before and 2 years after the current year per department
select year, dept_name, max(num_credits)
over (partition by dept_name order by year rows between 2 preceding and 2 following) as max_total_credits
from tot_credits_dept;
# 76 rows returned