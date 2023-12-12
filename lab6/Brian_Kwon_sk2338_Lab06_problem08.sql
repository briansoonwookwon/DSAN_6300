# Increase the salary of each instructor in the Comp. Sci. department by 10%.
update instructor set salary = salary * 1.10 where dept_name = 'Comp. Sci.';