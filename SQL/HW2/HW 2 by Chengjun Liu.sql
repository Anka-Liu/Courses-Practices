--1. (1 point) List the vendors (name) that are based in Bellevue, Ballard, and Redmond? Your table
--should only include 1 variable: name.


select distinct VendName as name
from Vendors 
where VendCity in ('Bellevue','Ballard','Redmond')

--2. (1 point) Show all product names that cost the shop less than $100. Your table should include the
--product name, product wholesalesprice, and the vendor name.

select p.ProductName, pv.WholesalePrice, v.VendName
from Products as p
join Product_Vendors as pv
on p.ProductNumber=pv.ProductNumber
join Vendors as v
on pv.VendorID=v.VendorID
where pv.WholesalePrice < 100

--3. (2 points) Find all the customers who have ordered a bicyle helmet in the past. Your table should
--include three columns: first name, last name, and product name.

select c.CustFirstName, c.CustLastName, p.ProductName
from Customers as c
join Orders as o
on c.CustomerID= o.CustomerID
join Order_Details as od
on o.OrderNumber = od.OrderNumber
join Products as p
on od.ProductNumber= p.ProductNumber
where p.ProductName like '%Helmet%' --Indeed Helmet Mounted Mirror is not Helmet, so I initially used 
--'%Helmet', but here is '%Helmet' following Abbass's instruction.

--4. (2 points) Suppose that the shop is out of the product “Shinoman 105 SC Brakes” and they are
--looking to get it very fast from one of the vendors. Among the all vendors in the database, which
--vendor is the fastest to supply the shop with the product “Shinoman 105 SC Brakes”? Your table
--should include four columns: vendor name, vendor state, and vendor phone number.

select v.VendName, v.VendState, v.VendPhoneNumber
from Product_Vendors as pv
join Vendors as v
on pv.VendorID=v.VendorID
join Products as p
on p.ProductNumber = pv.ProductNumber
where p.ProductName='Shinoman 105 SC Brakes'
order by pv.DaysToDeliver 
limit 1

--5. (1 point) Which products have never been ordered? Your table should only include the names of the
--products.

select distinct p.ProductName
from Products as p
left join Order_Details as od
on od.ProductNumber=p.ProductNumber
where od.OrderNumber is null

--6. (1 point) Create a new variable called revenue to show how much revenue the shop generated from
--each order in January 2018 (use shipdate for date comparisons)? Your table should have three columns:
--ordernumber, shipdate, and the revenue.

select od.OrderNumber, o.ShipDate, sum(od.QuotedPrice * od.QuantityOrdered) as Revenue
from Products as p
join Order_Details as od
on p.ProductNumber=od.ProductNumber
join Orders as o
on o.OrderNumber = od. OrderNumber
where date_trunc('month',o.Shipdate) = '2018-01-01'
group by od.OrderNumber, o.ShipDate

--7. (2 points) The shop has large numbers of “Shinoman Deluxe TX-30 Pedal” product in their inventory.
--The shop has decided to do target marketing and reach out to those who have already bought this
--product before in order to increase sales. Return a list of all customers (firstname, last name, and phone
--numbers) who have bought this product before. Your table should include three columns: firstname,
--last name, and phone numbers.

select distinct c.CustFirstName, c.CustLastName, c.CustPhoneNumber
from Products as p
join Order_Details as od
on p.ProductNumber=od.ProductNumber
join Orders as o
on o.OrderNumber = od.OrderNumber
join Customers as c
on o.CustomerID=c.CustomerID
where p.ProductName = 'Shinoman Deluxe TX-30 Pedal'
