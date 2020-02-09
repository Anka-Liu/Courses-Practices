--1.

select sum(o.total_amt_usd) as total_sales, a.name
from orders as o
join accounts as a
on o.account_id =a.id
group by a.name
order by total_sales desc

--2.
select distinct channel
from web_events

select channel, count(*) as total
from web_events
group by channel
order by total desc

--3.
select a.name, max(o.total_amt_usd) max_amt
from orders as o
join accounts as a
on o.account_id=a.id
group by a.name
order by max_amt desc

--4.

select r.name, count(*)
from region as r
join sales_reps as s
on r.id=s.region_id
group by r.name

--5.

select a.name, avg(o.standard_amt_usd) as avg_standard_amt_usd,
				avg(o.poster_amt_usd) as avg_poster_amt_usd, 
				avg(o.gloss_amt_usd) as avg_gloss_amt_usd
from orders as o
join accounts as a
on a.id=o.account_id
group by a.name


--6.

select s.name, w.channel, count(*)
from web_events as w
join accounts as a
on w.account_id=a.id
join sales_reps as s
on s.id = a.sales_rep_id
group by s.name, w.channel
order by name, channel

--7.

select s.name, count(*) as num_of_accounts
from sales_reps as s
join accounts as a
on a.sales_rep_id = s.id
group by s.name
having count(*) > 5

--

select count(*)
from (
	select s.name, count(*) as num_of_accounts
	from sales_reps as s
	join accounts as a
	on a.sales_rep_id = s.id
	group by s.name -- assuming the colname is unique, otherwise use ID
	having count(*) > 5
	order by 2
) table1

--8.

select count(*)
from (
	select account_id , count(*) as total_orders
	from orders
	group by account_id
	having count(*) > 20
) table1

--9.

select a.name, count(*) total_orders
from orders o
join accounts a
on o.account_id = a.id
group by a.name
order by 2 desc
limit 1

--10.
select count(*)
from (
	select a.name, sum(o.total_amt_usd) total_spent
	from orders o
	join accounts a
	on a.id= o.account_id
	group by a.name
	having sum(o.total_amt_usd) >30000
	) ocean

--11.

select a.name, sum(o.total_amt_usd) total_spent
from orders o
join accounts a
on a.id=o.account_id
group by a.name
order by total_spent desc
limit 1

--12.

select a.name, w.channel, count(*)
from web_events w
join accounts a
on a.id = w.account_id
where w.channel = 'facebook'
group by a.name, w.channel
order by 3 desc

--13.

select a.name, w.channel, count(*)
from web_events w
join accounts a
on a.id = w.account_id
where w.channel = 'facebook'
group by a.name, w.channel
having count(*) > 6
order by 3 desc

--14.

select count(*), channel
from (
	select w.channel, a.id, count(*)
	from web_events as w
	join accounts as a
	on a.id=w.account_id
	group by w.channel, a.id
) table1 
group by channel
order by count(*) desc

--15.

select date_part('year',occurred_at) order_year, sum(total_amt_usd) total_spent
from orders o
group by order_year

--16. Which month did Parch & Posey have the largest sales in 2016?

select date_part('month', occurred_at) order_month, sum(total_amt_usd) total_spent
from orders
where date_part('year', occurred_at) = 2014
group by 1
order by 1

--17.

select date_trunc('month',occurred_at) order_date, sum(o.gloss_amt_usd) total_spent
from orders o
join accounts a
on o.account_id=a.id
where a.name='Walmart'
group by 1
order by 2 desc
limit

--18.

select a.name, sum(o.total_amt_usd),
		CASE WHEN sum(o.total_amt_usd) > 200000 THEN 'Top'
			 when sum(o.total_amt_usd) > 100000 THEN 'Medium'
			 else 'Low'
		end account_level
from orders o
join accounts a
on a.id = o.account_id
group by a.name

--19.

select a.name, sum(o.total_amt_usd),
from orders o
join accounts a
on a.id = o.account_id
group by a.name

--20.

select s.name, count(*) num_orders,
		case when count(*) > 200 then 'Top'
			 else 'Not'
		end ranked_sales
from accounts a
join sales_reps s
on a.sales_rep_id=s.id
join orders o
on a.id=o.account_id
group by s.name
order by 2 desc

--21.

select s.name, count(*) num_orders, sum(total_amt_usd) total_spent,
		case when count(*) > 200 or sum(total_amt_usd)  > 750000 then 'Top'
			 when count(*) > 150 or sum(total_amt_usd)  > 500000 then 'Middle'
			 else 'Low'
		end ranked_sales
from accounts a
join sales_reps s
on a.sales_rep_id=s.id
join orders o
on a.id=o.account_id
group by s.name
order by 2 desc