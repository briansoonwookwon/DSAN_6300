# 7. Find the names of those departments whose budget is higher than that of “Geology” department. List them in alphabetic order.
select dept_name
from department
where budget >
	(select budget from department where dept_name = "Geology");
# 14 rows returned