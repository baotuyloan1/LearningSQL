-- =============== Grouping Data ================== --
/*
Understanding Data GroupingIn the last lesson, you learned that the SQLaggregate functions can be used to
summarize data. These functions enable you to count rows, calculate sums and
averages, and obtain high and low values without having to retrieve all the data.

All the calculations thus far were performed on all the data in a table or on data
that matched a specific WHERE clause. As a reminder, the following example
returns the number of products offered by vendor DLL01:
*/

SELECT COUNT(*) AS num_prods
FROM Products
WHERE vend_id ='DLL01';/*num_prods
-----------*//*But what if you wanted to return the number of products offered by each vendor?
Or products offered by vendors who offer a single product, or only those who
offer more than 10 products?
This is where groups come into play. Grouping lets you divide data into logical
sets so that you can perform aggregate calculations on each group.*/-- ==================== Creating Groups ====================== --/*Groups are created using the GROUP BY clause in your SELECT statement*/SELECT vend_id, COUNT([prod_name]) as num_prodsFROM ProductsGROUP BY vend_id/*vend_id num_prods
------- ---------
BRS01 3
DLL01 4
FNG01 2*//*The above SELECT statement specifies two columns, vend_id, which contains the
ID of a product’s vendor, and num_prods, which is a calculated field (created
using the COUNT(*) function). The GROUP BY clause instructs the DBMS to sort the
data and group it by vend_id. This causes num_prods to be calculated once per
vend_id rather than once for the entire table. As you can see in the output, vendor
BRS01 has 3 products listed, vendor DLL01 has 4 products listed, and vendor FNG01
has 2 products listed.Because you used GROUP BY, you did not have to specify each group to be
evaluated and calculated. That was done automatically. The GROUP BY clause
instructs the DBMS to group the data and then perform the aggregate on each
group rather than on the entire result set.Before you use GROUP BY, here are some important rules about its use that you
need to know:	- GROUP BY clauses can contain as many columns as you want. This enables
you to nest groups, providing you with more granular control over how datais grouped.	- If you have nested groups in your GROUP BY clause, data is summarized at thelast specified group. In other words, all the columns specified are
evaluated together when grouping is established (so you won’t get data
back for each individual column level).	- Every column listed in GROUP BY must be a retrieved column or a valid
expression (but not an aggregate function). If an expression is used in the
SELECT, that same expression must be specified in GROUP BY. Aliases cannot
be used.	- Most SQLimplementations do not allow GROUP BY columns with variablelength datatypes (such as text or memo fields)	- Aside from the aggregate calculation statements, every column in your
SELECT statement must be present in the GROUP BY clause.	- If the grouping column contains a row with a NULL value, NULL will be
returned as a group. If there are multiple rows with NULL values, they’ll all
be grouped together.	- The GROUP BY clause must come after any WHERE clause and before any ORDER BY clause*//*Tip: The ALL ClauseSome SQLimplementations (such as Microsoft SQLServer) support an
optional ALL clause within GROUP BY. This clause can be used to return all
groups, even those that have no matching rows (in which case the aggregate would return NULL). Refer to your DBMS documentation to see if it supports
ALL.*/SELECT vend_id, COUNT([prod_name]) as num_prodsFROM ProductsGROUP BY ALL vend_id;/*Caution: Specifying Columns by Relative PositionSome SQLimplementations allow you to specify GROUP BY columns by the
position in the SELECT list. For example, GROUP BY 2,1 can mean group by the
second column selected and then by the first. Although this shorthand syntax
is convenient, it is not supported by all SQLimplementations. Its use is also
risky in that it is highly susceptible to the introduction of errors when editing
SQLstatements.*/-- ====================== Filtering Groups ===================== --/*In addition to being able to group data using GROUP BY, SQLalso allows you to
filter which groups to include and which to exclude. For example, you might want
a list of all customers who have made at least two orders. To obtain this data, youmust filter based on the complete group, not on individual rows.WHERE does not work here because WHERE filters specific rows, not groups. As a matter of fact, WHERE has no idea what a group
is.SQLprovides yet another clause for this purpose: the HAVING clause. HAVING is very similar to WHERE. In fact, all types of
WHERE clauses you’ve learned about thus far can also be used with HAVING. The
only difference is that WHERE filters rows and HAVING filters groups.*//*Tip: HAVING Supports All WHERE’s OperatorsAll the techniques and options that you’ve learned about
WHERE can be applied to HAVING. The syntax is identical; just the keyword is
different.*/SELECT cust_id, COUNT(*) AS ordersFROM OrdersGROUP BY cust_idHAVING COUNT(*) >= 2/*cust_id orders
---------- -----------
1000000001 2*//*The first three lines of this SELECT statement are similar to the statements seen
above. The final line adds a HAVING clause that filters on those groups with a
COUNT(*) >= 2—two or more orders.As you can see, a WHERE clause couldn’t work here because the filtering is based
on the group aggregate value, not on the values of specific rows.*//*Note: The Difference Between HAVING and WHEREHere’s another way to look it: WHERE filters before data is grouped, and
HAVING filters after data is grouped. This is an important distinction; rows that are eliminated by a WHERE clause will not be inclued in the group. This could change the calculated values, which in turn could affect which groups are
filtered based on the use of those values in the HAVING clause.*//*lists all vendors who have two or more products priced at 4 or more*/SELECT [vend_id], COUNT(*) AS num_prodsFROM [dbo].[Products]WHERE [prod_price] >= 4GROUP BY [vend_id]HAVING COUNT(*) >= 2/*This statement warrants an explaintion. The first line is a basic SELECT using an
aggregate function. The WHERE clause filters all rows with a prod_price of at least 4.Data is then grouped by vend_id, and then a
HAVING clause filters just those groups with a count of 2 or mor. Without the
WHERE clause, an extra row would have been retrieved (vendor DLL01 who sells
four products all priced under 4) as seen here:*/SELECT vend_id, COUNT(*) as num_prodsFROM ProductsGROUP BY vend_idHAVING COUNT(*) >= 2/*vend_id num_prods
------- -----------
BRS01 3
DLL01 4
FNG01 2*//*Note: Using HAVING and WHEREHAVING is so similar to WHERE that most DBMSs treat them as the same thing if
no GROUP BY is specified. Nevertheless, you should make that distinction
yourself. Use HAVING only in conjunction with GROUP BY clauses. Use WHERE
for standard row-level filtering.*/-- ====================== Grouping and Sorting ============================ --/*It is important to understand that GROUP BY and ORDER BY are very different, even
though they often accomplish the same thing. summarizes the
differences between them.*//*Tip: Don’t Forget ORDER BYAs a rule, anytime you use a GROUP BY clause, you should also specify an
ORDER BY clause. That is the only way to ensure that data will be sorted
properly. Never rely on GROUP BY to sort your data.*//*Example : Retrieve the order number and number of items ordered for all orders containing three or more items*/SELECT order_num, COUNT(*) AS itemsFROM OrderItemsGROUP BY order_numHAVING COUNT(*) >= 3ORDER BY order_num;/*order_num items
--------- -----
20006 3
20007 5
20008 5
20009 3*//*To sort the output by number of items ordered, all you need to do is add an ORDER
BY clause, as follows:*/SELECT order_num, COUNT(*) AS itemsFROM OrderItemsGROUP BY order_numHAVING  COUNT(*) >= 3ORDER BY items, order_num;/*order_num items
--------- -----
20006 3
20009 3
20007 5
20008 5*//*In this example, the GROUP BY clause is used to group the data by order number
(the order_num column) so that the COUNT(*) function can return the number of
items in each order. The HAVING clause filters the data so that only orders with
three or more items are returned. Finally, the output is sorted using the ORDER BY
clause.*/-- ===================== SELECT clause ordering ================== --/*SELECT : Columns or expressions to be returned . It is requiredFROM : Table to retrieve data from.  Only if selecting data from a tableWHERE: Row-level filtering. It is not required.GROUP BY: Group specification. Only if calculating aggregates by group.HAVING: Group-level filtering. It is not required.ORDER BY: Output sort order. It is not required.*//*Challenges1. The OrderItems table contains the individual items for each order. Write a
SQLstatement that returns the number of lines (as order_lines) for each
order number (order_num) and sort the results by order_lines.*/SELECT  order_num ,COUNT(*) AS order_linesFROM OrderItemsGROUP BY order_numORDER BY order_lines/*2. Write a SQLstatement that returns a field named cheapest_item, which
contains the lowest-cost item for each vendor (using prod_price in the
Products table), and sort the results from lowest to highest cost.*/SELECT [vend_id],MIN(prod_price) AS cheapest_itemFROM [dbo].[Products]GROUP BY [vend_id]ORDER BY cheapest_item/*3. It’s important to identify the best customers, so write a SQLstatement to
return the order number (order_num in the OrderItems table) for all orders of
at least 100 items.*/SELECT order_numFROM OrderItemsGROUP BY order_numHAVING SUM(quantity) >= 100ORDER BY order_num/*4. Another way to determine the best customers is by how much they have
spent. Write a SQLstatement to return the order number (order_num in the
OrderItems table) for all orders with a total price of at least 1000. Hint: for
this one you’ll need to calculate and sum the total (item_price multiplied by
quantity). Sort the results by order number.*/SELECT order_num, SUM([quantity] * [item_price]) AS  total_priceFROM OrderItemsGROUP BY order_numHAVING SUM([quantity] * [item_price]) >= 1000ORDER BY order_num/*5. What is wrong with the following SQLstatement? (Try to figure it out without running it.)SELECT order_num, COUNT(*) AS items
FROM OrderItems
GROUP BY items //[order_num]
HAVING COUNT(*) >= 3
ORDER BY items, order_num; */

/*
Write a query to retrieve the customer names, addresses (combine cust_address, 
cust_city, and cust_state into one column as full_address), and email addresses 
for customers who live in states starting with the letter 'C'. Ensure the cust_name is in uppercase.
*/

SELECT UPPER([cust_name]),CONCAT([cust_address],', ' ,[cust_city], ', ', [cust_state] )  AS full_address, [cust_email]
FROM [dbo].[Customers]
WHERE RIGHT([cust_state],1) = 'C'

/*
Write a query that shows the number of customers (customer_count) in each state (cust_state). 
Only display states with more than 5 customers and sort the results by customer_count in descending order.
*/

SELECT COUNT([cust_name]) AS Custs, [cust_state] AS Cust_State
FROM [dbo].[Customers]
GROUP BY [cust_state]
HAVING COUNT([cust_name]) >= 5 
ORDER BY Custs DESC


/*
Find the total number of customers (total_customers) in each country, but only for countries 
where at least one customer has a non-empty (IS NOT NULL) email address.
Show the total number of customers for each country and filter out those with fewer than 10 customers.
*/

SELECT COUNT(cust_name) AS Total
FROM [dbo].[Customers]
GROUP BY [cust_country]
HAVING COUNT([cust_email]) > 0 AND COUNT(cust_name) >= 10