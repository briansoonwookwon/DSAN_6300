# 2c Get the average total credits over all prior years
create view tot_credits as
select year, sum(credits) as num_credits from takes natural join course
group by year;

select year, avg(num_credits)
over (order by year rows unbounded preceding) as avg_total_credits
from tot_credits;
# 10 rows returned

# 2d Rank order all students by total credit
select ID, rank() over (order by (tot_cred) desc) as s_rank 
from student
order by s_rank;
# 2000 rows returned

# 3a With the total number of credits taken by all students in each year for courses offered by each department
create view tot_credits_dept(year,dept_name,num_credits) as (
    select year, dept_name, sum(credits)
    from takes as t
    natural join course
    group by t.year, course.dept_name
);

select * from tot_credits_dept
order by dept_name, year;
# 76 rows returned 

# 3b Compute average number of credits over three preceding years per department using the view you created in 3a
select year, dept_name, avg(num_credits)
over (partition by dept_name order by year rows 3 preceding) as avg_total_credits
from tot_credits_dept;
# 76 rows returned

select *
from tot_credits_dept
where dept_name = "Biology"
order by year;

# 4 Compute maximum number of credits over for the window of 2 years before and 2 years after the current year per department
select year, dept_name, max(num_credits)
over (partition by dept_name order by year rows between 2 preceding and 2 following) as max_total_credits
from tot_credits_dept;
# 76 rows returned