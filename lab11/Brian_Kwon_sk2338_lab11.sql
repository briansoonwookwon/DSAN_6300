# 5.A Write a query that calculates number of students that received each possible grade per each course, each year. 
# The query should provide count summaries by year by course_id, and also by year totals.
select course_id, year, grade, count(*) as count
from student as s
left join takes as t on t.ID = s.ID
group by year, course_id, grade with rollup;
# 1001 rows returned

# 5.B Modify the previous query to output meaningful labels instead if NULLs, You can use functions if() and grouping().
select course_id, if(grouping(year), 'all', year) as year, 
if(grouping(grade), 'all', grade) as grade, count(*) as count
from student as s
left join takes as t on t.ID = s.ID
group by year, course_id, grade with rollup;
# 1001 rows returned
