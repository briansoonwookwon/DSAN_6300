# 1. Create two new tables takes1 and course1. The tables have the same schema and data as takes and course tables, 
# but do not have any indices on them.
create table takes1 as select * from takes;
# 30000 rows affected
create table course1 as select * from course;
# 200 rows affected

# 2. Run a query that outputs titles of all courses that were taught in 2013. Review execution plan.
select distinct title
from course1 as c
left join takes1 as t on c.course_id = t.course_id
where t.year = 2013;
# 12 rows returned

# 3. Create an index on the attribute course_id for table course1. Rerun the query. Review the execution plan
create index idx_course_id on course1(course_id);
-- idx_course_id is used with less query cost

# 4. Create an index on attribute title for table course1. Rerun the query. Review execution plan
create index idx_title on course1(title);
-- idx_title is not used 

# 5. Create an index on attribute year for table takes1. Rerun the query. Review the execution plan
create index idx_year on takes1(year);
-- Now both two indices idx_year and idx_course_id are used having much less query cost