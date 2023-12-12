# 2c Get the average total credits over all prior years
create view tot_credits as
select year, sum(credits) as num_credits from takes natural join course
group by year;

select year, avg(num_credits)
over (order by year rows unbounded preceding) as avg_total_credits
from tot_credits;
# 10 rows returned