# 13. Create a view tot_credits (year, num_credits) that shows the total number of credits taken by all students in each year. Use that view to output total credits by year.
create view tot_credits(year,num_credits) as (
    select year, sum(credits)
    from takes as t
    natural join course
    group by t.year
);

select * from tot_credits;
# 10 rows