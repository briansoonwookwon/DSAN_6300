# Find the ID and name of each student who has taken at least one Comp. Sci. course; make sure there are no duplicates in the result
select distinct s.ID, s.name
FROM student AS s
INNER JOIN takes AS t ON s.ID = t.ID
INNER JOIN course AS c ON t.course_id = c.course_id 
WHERE c.dept_name = 'Comp. Sci.';