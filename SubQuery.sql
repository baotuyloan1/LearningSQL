-- ===========  Working with Subqueries ============== -- 
/*
SQL enables you to create subqueries-queries that are embedded into other
queries.

Orders are stored in two tables. The Orders table stores a
single row for each order containing order number, customer ID, and order date. The individual order items are stored in the related OrderItems table. The Orders
table does not store customer information. It only stores a customer ID. The actual
customer information is stored in the Customers table.
Now suppose you wanted a list of all the customers who ordered item RGAN01. 
What would you have to do to retrieve this information? Here are the steps:

1. Retrieve the order numbers of all orders containing item RGAN01.2. Retrieve the customer ID of all the customers who have orders listed in the
order numbers returned in the previous step.

3. Retrieve the customer information for all the customer IDs returned in the
previous step.
*/

SELECT DISTINCT order_num
FROM OrderItems
WHERE prod_id = 'RGAN01';/*It retrieves the
order_num column for all order items with a prod_id of RGAN01. The output lists
the two orders containing this item:*//*order_num
-----------
20007
20008*//*Now that we know which orders contain the desired item, the next step is to
retrieve the customer IDs associated with those order number, 20007 and 20008.*/SELECT cust_idFROM OrdersWHERE order_num IN (20007, 20008)/*cust_id
----------
1000000004
1000000005*//*Now, combine the two queries by turning the first (the one that returned the order
numbers) into a subquery. Look at the following SELECT statement:*/SELECT cust_idFROM OrdersWHERE order_num IN (SELECT DISTINCT order_num
					FROM OrderItems
					WHERE prod_id = 'RGAN01');

/*
cust_id
----------
1000000004
1000000005
*/

/*
Subqueries are always processed starting with the innermost SELECT statement and working outward.
When the preceding SELECT statement is processed, the DBMS actually performs two operations.

It first runs the following subquery: */
SELECT order_num FROM orderitems WHERE prod_id='RGAN01'

/*
That query returns the two order numbers 20007 and 20008. Those two values are
then passed to the WHERE clause of the outer query in the comma-delimited format
required by the IN operator. The outer query now becomes
*/

SELECT cust_id
FROM Orders
WHERE order_num IN (20007,20008)

/*
Tip: Formatting Your SQL
SELECT statements containing subqueries can be difficult to read and debug,
especially as they grow in complexity. Breaking up the queries over multiple
lines and indenting the lines appropriately as shown here can greatly simplify working with subqueries

Incidentally, this is where color coding also becomes invaluable, and the
better DBMS clients do indeed color code SQLfor just this reason. And this
is also why the SQLstatements in this book have been printed in color for
you;; it makes reading them, isolating their sections, and troubleshooting them
so much easier.
*/

/*
You now have the IDs of all the customers who ordered item RGAN01. The next
step is to retrieve the customer information for each of those customer IDs.
Here is the SQLstatement to retrieve the two columns:
*/
SELECT cust_name, cust_contact
FROM Customers
WHERE cust_id IN (1000000004,1000000005);

/*
Instead of hard-coding those customer IDs, you can turn this WHERE clause into yet
another subquery
*/

SELECT cust_name, cust_contact
FROM Customers
WHERE cust_id IN (SELECT cust_id
					FROM Orders
					WHERE order_num IN (SELECT order_num
										FROM OrderItems
										WHERE prod_id = 'RGAN01'));

/*
cust_name cust_contact
----------------------------- --------------------
Fun4All Denise L. Stephens
The Toy Store Kim Howard*/

/*
To execute the above SELECT statement, the DBMS had to actually perform three
SELECT statements. The innermost subquery returned a list of order numbers that were then used as the WHERE clause for the subquery above it. That subquery
returned a list of customer IDs that were used as the WHERE clause for the top-level
query. The top-level query actually returned the desired data.
As you can see, using subqueries in a WHERE clause enables you to write extremely
powerful and flexible SQLstatements. There is no limit imposed on the number of
subqueries that can be nested, although in practice you will find that performance will tell you when you are nesting too deeply.

*/

/*
Caution: Single Column Only
Subquery SELECT statements can only retrieve a single column. Attempting to
retrieve multiple columns will return an error.
*/

/*
Caution: Subqueries and Performance
The code shown here works, and it achieves the desired result. However,
using subqueries is not always the most efficient way to perform this type of
data retrieval.
*/

/*
Using Subqueries as Calculated Fields
Another way to use subqueries is in creating calculated fields. Suppose you wanted to display the total number of orders placed by every customer in your
Customers table. Orders are stored in the Orders table along with the appropriate
customer ID.
To perform this operation, follow these steps:
1.  Retrieve the list of customers from the Customers table.
2. For each customer retrieved, count the number of associated orders in the
Orders table.
You can use SELECT COUNT(*) to count rows in a table, and by providing a WHERE clause to filter a specific
customer ID, you can count just that customer’s orders. For example, the
following code counts the number of orders placed by customer 1000000001:
*/

SELECT COUNT(*) AS orders
FROM Orders
WHERE cust_id = 1000000001;

/*
To perform that COUNT(*) calculation for each customer, use COUNT(*) as a subquery
*/

SELECT cust_name, cust_state, (SELECT COUNT(*) FROM Orders WHERE Orders.cust_id = Customers.cust_id) AS orders
FROM Customers
ORDER BY cust_name;

/*
Ouput:
cust_name				  cust_state orders
------------------------- ---------- ------
Fun4All						IN			1
Fun4All						AZ			1
Kids Place					OH			0
The Toy Store				IL			1
Village Toys				MI			2
*/

/*
This SELECT statement returns three columns for every customer in the Customers
table: cust_name, cust_state, and orders. Orders is a calculated field that is set
by a subquery that is provided in parentheses. That subquery is executed once for
every customer retrieved. In the example above, the subquery is executed five
times because five customers were retrieved.
The WHERE clause in the subquery is a little different from the WHERE clauses used
previously because it uses fully qualified column names; instead of just a column
name (cust_id), it specifies the table and the column name (as Orders.cust_id
and Customers.cust_id). The following WHERE clause tells SQLto compare the
cust_id in the Orders table to the one currently being retrieved from the
Customers table:
WHERE Orders.cust_id = Customers.cust_id	

This syntax—the table name and the column name separated by a period—must
be used whenever there is possible ambiguity about column names. In this
example, there are two cust_id columns, one in Customers and one in Orders.
Without fully qualifying the column names, the DBMS assumes you are comparing
the cust_id in the Orders table to itself. Because

SELECT COUNT(*) FROM Orders WHERE cust_id = cust_id
will always return the total number of orders in the Orders table, the results will
not be what you expected:
*/

SELECT cust_name,
		cust_state,
		(SELECT COUNT(*)
		FROM Orders
		WHERE cust_id = cust_id) AS orders
FROM Customers
ORDER BY cust_name;

/*
Although subqueries are extremely useful in constructing this type of SELECT
statement, care must be taken to properly qualify ambiguous column names.
*/

/*
Caution: Fully Qualified Column Names
You just saw a very important reason to use fully qualified column names.
Without the extra specificity, the wrong results were returned because 
the DBMS misunderstood what you intended. Sometimes the ambiguity caused by
the presence of conflicting column names will actually cause the DBMS to
throw an error. For example, this might occur if your WHERE or ORDER BY
clause specified a column name that was present in multiple tables. A good
rule is that if you are ever working with more than one table in a SELECT
statement, then use fully qualified column names to avoid any and all
ambiguity.
*/

/*
Tip: Subqueries May Not Always Be the Best Option
As explained earlier in this lesson, although the sample code shown here works, it is often not the most efficient way to perform this type of data
retrieval.
*/

/*
Challenges
1. Using a subquery, return a list of customers who bought items priced 10 or more. You’ll want to use the OrderItems table to find the matching order
numbers (order_num) and then the Orders table to retrieve the customer ID
(cust_id) for those matched orders.
*/

SELECT *
FROM Customers
WHERE cust_id IN (
					SELECT DISTINCT cust_id
					FROM Orders
					WHERE order_num IN (
										SELECT DISTINCT order_num
										FROM OrderItems
										WHERE item_price >= 10))


/*
2. You need to know the dates when product BR01 was ordered. Write a SQL
statement that uses a subquery to determine which orders (in OrderItems)
purchased items with a prod_id of BR01 and then returns customer ID
(cust_id) and order date (order_date) for each from the Orders table. Sort
the results by order date.
*/

SELECT cust_id, order_date
FROM Orders
WHERE order_num IN (
					SELECT order_num
					FROM OrderItems
					WHERE prod_id = 'BR01')
ORDER BY order_date

/*
3. Now let’s make it a bit more challenging. Update the previous challenge to
return the customer email (cust_email in the Customers table) for any
customers who purchased items with a prod_id of BR01. Hint: this involves
the SELECT statement, the innermost one returning order_num from
OrderItems, and the middle one returning cust_id from Customers.
*/
SELECT cust_email
FROM Customers
WHERE cust_id IN (
					SELECT cust_id
					FROM Orders
					WHERE order_num IN (
										SELECT order_num
										FROM OrderItems
										WHERE prod_id = 'BR01'))

/*
4. We need a list of customer IDs with the total amount they have ordered. Write a SQLstatement to return customer ID (cust_id in the Orders table)
and total_ordered using a subquery to return the total of orders for each
customer. Sort the results by amount spent from greatest to the least. Hint:
you’ve used the SUM() to calculate order totals previously.
*/
SELECT cust_id, (
					SELECT SUM(OrderItems.quantity* OrderItems.item_price)
					FROM OrderItems
					WHERE Orders.order_num = OrderItems.order_num)  AS total_ordered
FROM Orders
ORDER BY total_ordered DESC


SELECT cust_id, (
					SELECT SUM(OrderItems.item_price * OrderItems.order_num)
					FROM OrderItems
					WHERE OrderItems.order_num IN (
													SELECT Orders.order_num
													FROM Orders
													WHERE Orders.cust_id = Customers.cust_id)
					) AS total_ordered
FROM Customers
/*
Write a SQLstatement that retrieves all product names
(prod_name) from the Products table, along with a calculated column named
quant_sold containing the total number of this item sold (retrieved using a
subquery and a SUM(quantity) on the OrderItems table).
*/


SELECT prod_name, (
					SELECT SUM(OrderItems.quantity )
					FROM OrderItems
					WHERE OrderItems.prod_id = Products.prod_id) AS quant_sold
FROM Products

