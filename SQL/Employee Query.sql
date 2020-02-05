select m.first_name as manager, e.first_name as emloyee
from employee as m
join employee as e
on m.employee_id=e.manager_id;

-- update the previous query to show 

select m.first_name as manager, e.first_name as emloyee
from employee as m
left join employee as e
on m.employee_id=e.manager_id;

-- Who is the boss？

select m.first_name as manager, e.first_name as emloyee
from employee as m
full join employee as e
on m.employee_id=e.manager_id
where m.first_name is null;

-- show full name

select concat(m.first_name,' ',m.last_name) as manager, concat(e.first_name,' ',e.last_name) as emloyee
from employee as m
full join employee as e
on m.employee_id=e.manager_id
where m.first_name is null;