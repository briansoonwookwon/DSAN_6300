# 4.B. These instructors cannot be student’s advisors any longer. Reflect that fact in the database by deleting appropriate records.
delete from advisor where i_ID in
	(select i.ID
	from instructor as i
	left join department as d on i.dept_name = d.dept_name
	where d.building like '%Lamb%');
# 224 rows affected