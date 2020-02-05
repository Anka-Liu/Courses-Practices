--1. (1 point) Show the top 5 countries with the highest number of Customers. Your output
--should have two columns: country, number_of_customers.

select country, count(*) as number_of_customers
from customers
group by country
order by count(*) desc
limit 5

--2. (1 point) Find the total number of products in each category of products.Your output
--should have two columns: categoryname and totalproducts.

select categoryname, count(*) as totalproducts
from categories 
join products 
Using(categoryid)
group by categoryname

--3. (1 point) Northwind Traders will re-order a certain product if: (1) UnitsInStock plus
--UnitsOnOrder are less than or equal to ReorderLevel, and (2) the product is not discontinuted (Discontinued = 0). Which products need to be reordered? Your output should
--have two columns: productid and productname.

select productid, productname 
from products
where (unitsinstock+unitsonorder) <= reorderlevel and discontinued=0

--4. (1.5 points) How many orders were shipped by United Package in 1997. (Hint: shipvia
--is the shipper id in the orders table). Your output should have two columns: ship_year
--and total.

select date_part('year',shippeddate) as ship_year, count(*) as total
from orders 
join shippers
on shipvia=shipperid
where companyname='United Package'
group by date_part('year',shippeddate)
having date_part('year',shippeddate)=1997

--5. (1.5 points) Some of the countries have a very high freight charges. For 1996, return
--the three ship countries with the highest average freight overall, in descending order by
--average freight. Your output should have two columns: shipcountry, avg_freight.


select shipcountry, avg(freight) as avg_freight
from orders
where date_part('year',orderdate)=1996
group by shipcountry
order by avg(freight) desc
limit 3

--6. (2 point) Some salespeople have more orders arriving late than other salespeople
--(RequiredDate <= ShippedDate). Which salespeople have at least 5 orders arriving late?
--Your output should have three columns: firstname, lastname, and totalorders.

select e.firstname, e.lastname, count(*) as totalorders
from employees as e
join orders
using(employeeid)
where requireddate<=shippeddate
group by firstname, lastname
having count(*) >= 5

/*
7. (2 points) Suppose that the company wants to send all of the high-value customers a
special VIP gift. A high-value customer is anyone who’ve made at least 1 order with
a total value (quantity x unit price) equal to $10,000 or more. Query all of these
high-value customer in 1996. Your output should have companyname, orderid, and total_order_amount
*/

select companyname, orderid, sum(unitprice*quantity) as total_order_amount
from customers 
join orders
using(customerid)
join orderdetails
using(orderid)
where date_part('year',orderdate)=1996
group by companyname, orderid
having sum(unitprice*quantity)>=10000
