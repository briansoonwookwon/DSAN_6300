# 5. a) Delete the course “CS-001”.
delete from course where course_id='CS-001';

# 5. b) Takes, teaches, and section tables are affected because they have course_id as a foreign key to preserve referential integrity. 