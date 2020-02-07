-- 7.

select o.id, a.name, o.total as total_qty
from orders as o
join accounts as a
on o.account_id = a.id
where a.name = 'Walmart';

-- 8.

select distinct web_events.channel, accounts.name
from web_events
join accounts
on web_events.account_id=accounts.id
where accounts.id = 1001

--OR
select distinct web_events.channel, accounts.name
from web_events
join accounts
on web_events.account_id=accounts.id and accounts.id = 1001

-- 9.

select o.occurred_at,a.name,o.total,o.total_amt_usd
from orders as o
left join accounts as a
on o.account_id=a.id
where extract(year from o.occurred_at) = 2015
order by o.occurred_at

-- 10.

select a.name as account_name, s.name as representative_name, r.name as region_name
from accounts as a
left join sales_reps as s on a.sales_rep_id=s.id
left join region as r on s.region_id=r.id

--11.

select a.name as account_name, s.name as representative_name, r.name as region_name
from accounts as a
left join sales_reps as s on a.sales_rep_id=s.id
left join region as r on s.region_id=r.id
where r.name='Midwest';

--12.

select w.occurred_at, a.primary_poc
from web_events as w
join accounts as a
on w.account_id = a.id
order by occurred_at 
limit 1

--13.

select a.name as account_name, r.name as region_name, o.total_amt_usd, o.total,(o.total_amt_usd/(o.total+0.0001)) as unit_price
from accounts as a
join orders as o on a.id=o.account_id
join sales_reps as s on s.id=a.sales_rep_id
join region as r on r.id = s.region_id
where o.total_amt_usd = 0

--14.

select count(*)
from accounts

--15.
select sum(poster_qty)
from orders

--16. 
select min(poster_qty), max(poster_qty)
from orders

--17.
select min(occurred_at)
from orders

--18.
select avg(standard_amt_usd), avg(poster_amt_usd),avg(gloss_amt_usd)
from orders

--19.
select quantile(total_amt_usd,0.5)
from orders

select * from(
select total_amt_usd
from orders
order by total_amt_usd desc
limit ntile()
) A
order by total_amt_usd
limit 1

select percentile_cont(0.5) within group (order by total_amt_usd)
from orders



