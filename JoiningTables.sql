-- ============== JOINING TABLES ============== --

/*
Understanding Joins
One of SQL’s most powerful features is the capability to join tables on-the-fly within data retrieval queries. Joins are one of the most important operations that
you can perform using SQLSELECT, and a good understanding of joins and join
syntax is an extremely important part of learning SQL.
*/

/*
Understanding Relational Tables

Suppose you had a database table containing a product list, with each product in
its own row. The kind of information you would store with each product would
include a description and price, along with vendor information about the companythat creates the product


Now suppose that you had multiple products created by the same vendor. Where would you store the vendor information (things like vendor name, address, and
contact information)? You wouldn’t want to store that data along with the
products for several reasons:
	- Because the vendor information is the same for each product that vendor
	produces, repeating the information for each product is a waste of time and
	storage space.
	- If vendor information changes (for example, if the vendor moves or the
	contact info changes), you would need to update every occurrence of the
	vendor information.
	- When data is repeated (that is, the vendor information is used with each
	product), there is a high likelihood that the data will not be entered
	identically each time. Inconsistent data is extremely difficult to use in
	reporting.
*/

/*
The key here is that having multiple occurrences of the same data is never a good thing, and that priciple is the basis for 
relational database design. Relational tables are designed so that information is split into multiple tables, one for each data type.
The tables are related to each other through common values (and thus the relational in relational design) 

In our example, you can create two tables—one for vendor information and one
for product information. The Vendors table contains all the vendor information,
one table row per vendor, along with a unique identifier for each vendor. This
value, called a primary key, can be a vendor ID or any other unique value.

The Products table stores only product information and no vendor-specific
information other than the vendor ID (the Vendors table’s primary key). This key
relates the Vendors table to the Products table, and using this vendor ID enables
you to use the Vendors table to find the details about the appropriate vendor.

What does this do for you?
	- Vendor information is never repeated, and so time and space are not wasted.
	- If vendor information changes, you can update a single record, the one in theVendors table. 
	Data in related tables does not change.
	- Because no data is repeated, the data used is obviously consistent, making
	data reporting and manipulation much simpler
*/

/*
The bottom line is that relational data can be stored efficiently and manipulated
easily. Because of this, relational databases scale far better than nonrelational
databases.
*/

/*
New Term: Scale
Able to handle an increasing load without failing. A well-designed database
or application is said to scale well.

*/

/*
Why Use Joins?
Breaking data into multiple tables enables more efficient
storage, easier manipulation, and greater scalability. But these benefits come witha price.

If data is stored in multiple tables, how can you retrieve that data with a single
SELECT statement?

The answer is to use a join. Simply put, a join is a machanism used to associate or join, tables within 
a SELECT statement (and thus the name join). By using a special syntax, you can join multiple tables 
so that a single set of output is returned, and the join associates the correct rows in each table 
on the fly.
*/

/*
Note: Using Interactive DBMS Tools
Understand that a join is not a physical entity; in other words; it doesn't exist in the actual database tables.
A join is created by the DMBS as needed, and it persists for the duration of the query execution.

Many DBMSs provide graphical interfaces that can be used to define table relationships interactively.
These tools can be invalueable in helping to maintain referential. When you are using relational tables,
it is important that only valid data is inserted into relational columns. Going back to the example, if
an invalid vendor ID is stored in the Products table, those products would be inaccessible because thay would no be related
to any vendor. To prevent this from occurring, you can instruct the database only allow valid values (ones present in the Vendors table)
in the vendor ID column in the Products table. Referential integrity means that the DBMS enforces data integrity rules.
And these rules are often managed through DBMS provided interfaces.
*/

-- ==================== Creating a Join =======================--
/*
Creating a join is very simple. You must specify all the tables to be included and
how they are related to each other. Look at the following example:
*/

SELECT vend_name, prod_name, prod_price
FROM Vendors, Products
WHERE Vendors.vend_id = Products.vend_id

/*
vend_name			prod_name			prod_price
-------------------- -------------------- ----------
Doll House Inc.		Fish bean bag toy	3.4900
Doll House Inc.		Bird bean bag toy	3.4900
Doll House Inc.		Rabbit bean bag toy 3.4900
Bears R Us			8 inch teddy bear	5.9900
Bears R Us			12 inch teddy bear	8.9900
Bears R Us			18 inch teddy bear	11.9900
Doll House Inc.		Raggedy Ann			4.9900
Fun and Games		King doll			9.4900
Fun and Games		Queen doll			9.4900
*/

/*
Let's take a look at the preceding code. The SELECT statement starts in the same way 
as all the statements you've looked at thus far, by specifying the columns to be retrieved.
The big difference here is that two of the specified columns (prod_name and prod_price) are 
in one table, whereas the other(vend_name) is in another table.

Now look at the FORM clause. Unlike all the prior SELECT statements, this one has two tables listed 
in the FROM clause, Vendors and Products. These are the names of the two tables that are being joined
in this SELECT statement. The tables are correctly joined with a WHERE clause that instructs the DBMS
to match vend_id in the Vendors table with vend_id in the Products table.

You’ll notice that the columns are specified as Vendors.vend_id and
Products.vend_id. This fully qualified column name is required here because if
you just specified vend_id, the DBMS cannot tell which vend_id columns you are
referring to. (There are two of them, one in each table.) As you can see in the
preceding output, a single SELECT statement returns data from two different tables.
*/

/*
Caution: Fully Qualifying Column Names
As noted in the previous lesson, you must use the fully qualified column name
(table and column separated by a period) whenever there is a possible
ambiguity about which column you are referring to. Most DBMSs will return
an error message if you refer to an ambiguous column name without fully
qualifying it with a table name.
*/

-- ============== The Importance of the WHERE cluse ====================== --
/*
It might seem strange to use a WHERE clause to set the join relationship, but
actually, there is a very good reason for this. Remember, when tables are joined
in a SELECT statement, that relationship is constructed on the fly. There is nothing
in the database table definitions that can instruct the DBMS how to join the tables. You have to do that yourself. When you join two tables, what you are actually
doing is pairing every row in the first table with every row in the second table. The WHERE clause acts as a filter to only include rows that match the specified
filter condition—the join condition, in this case. Without the WHERE clause, every
row in the first table will be paired with every row in the second table,
regardless of whether they logically go together or not
*/

/*
New Term: Cartesian Product
The results returned by a table relationship without a join condition. The number of rows retrieved will
be the number of rows in the first table multiplied by the number of rows in the second table.
*/

/*
To understand this, loot at the following SELECT statement and output:
*/

SELECT vend_name, prod_name, prod_price
FROM Vendors, Products;

/*
vend_name prod_name prod_price
---------------- ---------------------------- ----------
Bears R Us 8 inch teddy bear 5.99
Bears R Us 12 inch teddy bear 8.99
Bears R Us 18 inch teddy bear 11.99
Bears R Us Fish bean bag toy 3.49
Bears R Us Bird bean bag toy 3.49
Bears R Us Rabbit bean bag toy 3.49
Bears R Us Raggedy Ann 4.99
Bears R Us King doll 9.49
Bears R Us Queen doll 9.49
Bear Emporium 8 inch teddy bear 5.99
Bear Emporium 12 inch teddy bear 8.99
Bear Emporium 18 inch teddy bear 11.99
Bear Emporium Fish bean bag toy 3.49
Bear Emporium Bird bean bag toy 3.49
Bear Emporium Rabbit bean bag toy 3.49
Bear Emporium Raggedy Ann 4.99
Bear Emporium King doll 9.49
Bear Emporium Queen doll 9.49
Doll House Inc. 8 inch teddy bear 5.99
Doll House Inc. 12 inch teddy bear 8.99
Doll House Inc. 18 inch teddy bear 11.99
Doll House Inc. Fish bean bag toy 3.49
Doll House Inc. Bird bean bag toy 3.49
Doll House Inc. Rabbit bean bag toy 3.49
Doll House Inc. Raggedy Ann 4.99
Doll House Inc. King doll 9.49
Doll House Inc. Queen doll 9.49
Furball Inc. 8 inch teddy bear 5.99
Furball Inc. 12 inch teddy bear 8.99
Furball Inc. 18 inch teddy bear 11.99
Furball Inc. Fish bean bag toy 3.49
Furball Inc. Bird bean bag toy 3.49
Furball Inc. Rabbit bean bag toy 3.49
Furball Inc. Raggedy Ann 4.99
Furball Inc. King doll 9.49
Furball Inc. Queen doll 9.49
Fun and Games 8 inch teddy bear 5.99
Fun and Games 12 inch teddy bear 8.99
Fun and Games 18 inch teddy bear 11.99
Fun and Games Fish bean bag toy 3.49
Fun and Games Bird bean bag toy 3.49
Fun and Games Rabbit bean bag toy 3.49
Fun and Games Raggedy Ann 4.99
Fun and Games King doll 9.49
Fun and Games Queen doll 9.49
Jouets et ours 8 inch teddy bear 5.99
Jouets et ours 12 inch teddy bear 8.99
Jouets et ours 18 inch teddy bear 11.99
Jouets et ours Fish bean bag toy 3.49
Jouets et ours Bird bean bag toy 3.49
Jouets et ours Rabbit bean bag toy 3.49
Jouets et ours Raggedy Ann 4.99
Jouets et ours King doll 9.49
Jouets et ours Queen doll 9.49
*/

/*
As you can see in the preceding output, the Cartesian product is seldom what you want.
The data returned here has matched every product with every vendor;
including products with the incorrect vendor (and even vendors with no products at all)
*/


/*
Caution: Don't Forget the where clause
Make sure all your joins have where clauses; otherwise, the DBMS will return fare more data you want.
Similarly, make sure your where clauses are correct. AN incorrect filter condition will cause the DBMS
to return incorrect data.
*/

/*
Tip: Cross Joins
Sometimes you'll hear the type of join that returns a Cartesian Product referred to as a cross join.
*/

/*
Inner joins
The join you have been using so far is called an equijoin-a join based on the 
testing of quality between two tables. This kind of join is also called an inner 
join. In fact, you may use a slightly different syntax for these join, specifying the
type of join explicitly. The following SELECT statement returns the exact same data
as an earlier example:
*/
SELECT vend_name, prod_name, prod_price
FROM Vendors
INNER JOIN Products ON Vendors.vend_id = Products.vend_id

/*
The SELECT in the statement is the same as the preceding SELECT statement, but the FROM clause is different.
Here the relationship between the two tables is part of the FROM clause specified as INNER JOIN. 
In this syntax, the join condition is specified using the special ON clause instead of a WHERE clause.
The actual condition passed to ON is the same as would be passed to WHERE.
*/

/*
The "Right" syntax
Per the ANSI SQL specification, use of the INNER JOIN syntax is preferred over the simple equijoins syntax used previoysly.
Indeed, SQL purist tend to look upon the simple syntax with disdain. That being said, DBMs do indeed support
both the simpler and the standard formats.
*/

/*
Joining Multiple Tables
SQL imposes no limit to the number of tables that may be joined in a SELECT statement. 
The basic rules for creating the join remain the same. First, list all the tables, and then
define the relationship between each. Example
*/

SELECT prod_name, vend_name, prod_price, quantity
FROM OrderItems, Products, Vendors
WHERE Products.vend_id = Vendors.vend_id 
		AND OrderItems.prod_id = Products.prod_id
		AND order_num = 20007;

/*
prod_name vend_name prod_price quantity
--------------- ------------- ---------- --------
18 inch teddy bear Bears R Us 11.9900 50
Fish bean bag toy Doll House Inc. 3.4900 100
Bird bean bag toy Doll House Inc. 3.4900 100
Rabbit bean bag toy Doll House Inc. 3.4900 100
Raggedy Ann Doll House Inc. 4.9900 50
*/

/*
This example displays the items in order number 20007. Order items are stored in
the OrderItems table. Each product is sotred by its product ID, Which refers to a
product in the Products table. The products are linked to the appropriate vendor
in the Vendors table by the vendor ID, which is stored with each product record.
The FROM clause here lists the three tables, and the WHERE clause defines both of those join conditions.
An additional WHERE condition is then used to filter jist the items for order 20007.
*/

/*
Caution: Performance Considerations
DBMSs process joins at runtime relating each table as specified. This
process can become very resource intensive, so be careful not to join tables unnecessarily.
The more tables you join, the more performance will degrade.
*/

/*
Caution: Maximium Number of tables in a Join
While it is true that SQL itself has no maximumu number of tables per join restriction,
many DBMSs do indeed have restrictions. Refer to your DBMS documentation to determine what restrictions there are, if any
*/

/*
Now would be a good time to revisit the following example "Working with Subqueries"
This statement returns a list of customers who ordered product RGAN01:
*/

SELECT cust_name, cust_contact
FROM Customers
WHERE cust_id IN (SELECT cust_id
				    FROM Orders
					WHERE order_num IN (SELECT order_num
										FROM OrderItems
										WHERE prod_id = 'RGAN01'));

/*
As mentioned, subqueries are not always the most efficient way to perform complex SELECT opetaions, and so as promised,
here is the same query using joins
*/

SELECT DISTINCT cust_name, cust_contact
FROM Customers, Orders, OrderItems
WHERE Customers.cust_id = Orders.cust_id 
		AND Orders.order_num = OrderItems.order_num 
		AND prod_id = 'RGAN01';


/*
cust_name						cust_contact
----------------------------- --------------------
Fun4All							Denise L. Stephens
The Toy Store					Kim Howard

*/

/*
Returning the dât needed in this query requires the use of three tables.
Bu instead of using them withing nested subqueries, here two joins
are used to connect the tables. There are three WHERE clause conditions here.
The first two connect the tables in the join, and the last one filters the data for product RGAN01.
*/

/*
Tip: It Pays to Experiment
As you can see, there is often more than one way to perform any given SQL operation.
And there is rearly a definitive right or wrong way. Performance can be affected by the type of operations,
the DBMS being used, the amount of data in the tables, whether or not indexes and keys are present, and a whole
slew of the other creteria. Therefore, it is often worth experimenting with different selection mechanisms
to find the one that works best for you.
*/

/*
Note: Joined Column Names
The columns being joined are named the same (cust_id in both CUstomers and Orders, for example). Having identically named
colunmns is not a requirement, and you'll often encounter database that use different naming convertions.
*/


/*
Challenges

Write a SQLstatement to return customer name (cust_name) from the
Customers table and related order numbers (order_num) from the Orders
table, sorting the result by customer name and then by order number. 
Actually, try this one twice—once using simple equijoin syntax and once
using an INNER JOIN.
*/

--  equijoin syntax
SELECT cust_name, order_num
FROM Customers, Orders
WHERE Customers.cust_id = Orders.cust_id
ORDER BY cust_name, order_num

SELECT cust_name, order_num
FROM Customers INNER JOIN Orders
 ON Customers.cust_id = Orders.cust_id
ORDER BY cust_name, order_num;



/*
2. Let's make the previous challenge more useful. In addition to returning the customer name and order number, add a third column named OrderTotal
containing the total price of each order.
*/


-- calculated field
SELECT cust_name, 
		order_num, 
		(SELECT SUM(OrderItems.quantity * OrderItems.item_price)
		FROM OrderItems
		WHERE OrderItems.order_num = Orders.order_num) AS OrderTotal
FROM Customers, Orders
WHERE Customers.cust_id = Orders.cust_id
ORDER BY cust_name, order_num



--  JOIN
SELECT cust_name, Orders.order_num, SUM(OrderItems.item_price*OrderItems.quantity) AS OrderTotal
FROM Customers
INNER JOIN Orders
	ON Customers.cust_id = Orders.cust_id
INNER JOIN OrderItems
	ON OrderItems.order_num = Orders.order_num
GROUP BY cust_name, Orders.order_num
ORDER BY cust_name, order_num

/*3

Privious challenge:
You need to know the dates when product BR01 was ordered. Write a SQL
statement that uses a subquery to determine which orders (in OrderItems)
purchased items with a prod_id of BR01 and then returns customer ID
(cust_id) and order date (order_date) for each from the Orders table. Sort
the results by order date


Write a SQLstatement that
retrieves the dates when product BR01 was ordered, but this time use a join
and simple equijoin syntax.
*/



SELECT cust_id, order_date
FROM Orders
WHERE order_num IN (
					SELECT order_num
					FROM OrderItems
					WHERE prod_id = 'BR01')
ORDER BY order_date


-- JOIN --
SELECT cust_id, order_date
FROM Orders
INNER JOIN OrderItems
	ON Orders.order_num = OrderItems.order_num
WHERE OrderItems.prod_id = 'BR01'
ORDER BY order_date


-- simple equijoin syntax --
SELECT Orders.cust_id, order_date
FROM Orders, OrderItems
WHERE OrderItems.order_num = Orders.order_num AND
		OrderItems.prod_id = 'BR01'
ORDER BY order_date
/*4
Previous Challenge: Now let’s make it a bit more challenging. Update the previous challenge to
return the customer email (cust_email in the Customers table) for any
customers who purchased items with a prod_id of BR01. Hint: this involves
the SELECT statement, the innermost one returning order_num from
OrderItems, and the middle one returning cust_id from Customers.

But this time using ANSI INNER JOIN syntax. The code you wrote there employed two nested subqueries. To re-create it, you’ll need
two INNER JOIN statements, each formatted like the INNER JOIN example
earlier in this lesson. And don’t forget the WHERE clause to filter by prod_id.

*/


SELECT DISTINCT cust_email
FROM Customers
INNER JOIN Orders ON Orders.cust_id = Customers.cust_id
INNER JOIN OrderItems ON OrderItems.order_num = Orders.order_num
WHERE OrderItems.prod_id = 'BR01'


/*
5
a challenge to find
all order numbers with a value of 1000 or more. Those results are useful, but what would be even more useful is the names of the customers who placed
orders of at least that amount. So, write a SQLstatement that uses joins to
return customer name (cust_name) from the Customers table and the total
price of all orders from the OrderItems table. Here’s a hint: to join those
tables, you’ll also need to include the Orders table (because Customers is
not related directly to OrderItems, Customers is related to Orders, and
Orders is related to OrderItems). Don’t forget GROUP BY and HAVING, and sort
the results by customer name. You can use simple equijoin or ANSI INNER
JOIN syntax for this one. Or, if you are feeling brave, try writing it both ways.
*/

/*
-cust_name 
- total price of all orders from the OrderItems table
- require total amount >= 1000
*/



-- JOIN --
SELECT Customers.cust_name, SUM(OrderItems.item_price * OrderItems.quantity) AS total_amount
FROM Customers
INNER JOIN Orders ON Orders.cust_id = Customers.cust_id
INNER JOIN OrderItems ON Orders.order_num = OrderItems.order_num
GROUP BY Customers.cust_name
HAVING SUM(OrderItems.item_price * OrderItems.quantity) >= 1000
ORDER BY cust_name;




-- simple equijoin
SELECT Customers.cust_name, SUM(OrderItems.item_price * OrderItems.quantity) AS total_amount
FROM Customers, Orders, OrderItems
WHERE Customers.cust_id = Orders.cust_id AND	
		Orders.order_num = OrderItems.order_num
GROUP BY Customers.cust_name
HAVING SUM(OrderItems.item_price * OrderItems.quantity) >= 1000
ORDER BY cust_name;