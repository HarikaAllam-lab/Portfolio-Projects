--Show order_date, shipped_date, customer_id, Freight of all orders placed on 2018 Feb 26

select order_date,shipped_date,customer_id,freight from orders
where order_date = "2018-02-26"

--Show the employee_id, order_id, customer_id, required_date, shipped_date from all orders shipped later than the required date

select employee_id,order_id,customer_id,required_date,shipped_date from orders
where shipped_date > required_date

--Show all the even numbered Order_id from the orders table

select order_id from orders
where order_id % 2 = 0

--Show the city, company_name, contact_name of all customers from cities which contains the letter 'L' in the city name, sorted by contact_name

select city,company_name,contact_name from customers
where city like '%L%'
order by contact_name

--Show the company_name, contact_name, fax number of all customers that has a fax number. (not null)

select company_name, contact_name,fax from customers
where fax is not null

--Show the first_name, last_name. hire_date of the most recently hired employee.

select first_name,last_name,max(hire_date)as hire_date from employees

--Show the average unit price rounded to 2 decimal places, the total units in stock, total discontinued products from the products table.

select round(avg(unit_price),2),sum(units_in_stock),sum(discontinued) from products

--Show the ProductName, CompanyName, CategoryName from the products, suppliers, and categories table

select p.product_name,s.company_name,c.category_name from products p
join categories c on p.category_id=c.category_id
join suppliers s on p.supplier_id=s.supplier_id

--Show the category_name and the average product unit price for each category rounded to 2 decimal places.

select c.category_name, round(avg(p.unit_price),2) from products p
join categories c on p.category_id = c.category_id
group by c.category_name

--Show the city, company_name, contact_name from the customers and suppliers table merged together. Create a column which contains 'customers' or 'suppliers' depending on the table it came from.

select city,company_name,contact_name,'customers' from customers
union
select city,company_name,contact_name,'suppliers' from suppliers

--Show the employee's first_name and last_name, a "num_orders" column with a count of the orders taken, and a column called "Shipped" that displays "On Time" if the order shipped_date is less or equal to the required_date, "Late" if the order shipped late.
--Order by employee last_name, then by first_name, and then descending by number of orders.

select e.first_name,e.last_name, count(o.order_id) as num_orders,
  (case when o.shipped_date <= o.required_date then 'On Time' else 'Late' end) as shipped 
from orders o
  join employees e on e.employee_id = o.employee_id
group by e.first_name, e.last_name,shipped
order by e.last_name,e.first_name,num_orders desc

--Show how much money the company lost due to giving discounts each year, order the years from most recent to least recent. Round to 2 decimal places

Select year(o.order_date) as 'order_year' , round(sum(p.unit_price * od.quantity * od.discount),2) as 'discount_amount' 
from orders o 
JOIN order_details od on o.order_id = od.order_id
JOIN products p on od.product_id = p.product_id
group by year(o.order_date)
order by order_year desc;