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