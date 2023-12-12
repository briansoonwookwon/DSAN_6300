# Delete all courses that have never been offered (i.e. do not occur in the section relation).
delete from course where course_id not in (select course_id from section)