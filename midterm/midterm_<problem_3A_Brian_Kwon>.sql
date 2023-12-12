# 3.A. Find out how many courses are offered by each department where department name starts with the letter "C". Return the department name as well as the number of courses offered.
select dept_name, count(course_id) as num_course
from course
where dept_name like "C%"
group by dept_name;
# 3 rows returned