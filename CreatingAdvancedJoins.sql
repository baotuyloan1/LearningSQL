-- =============== Creating Advanced Joins ========= 

-- ===== Using  Table Aliases ===== --
/*
In addition to using aliases for column names and calculated fields, SQL also enables you to alias table names
There are two primary reasons to do this:
	- To shorten the SQL syntax
	- To enable multiples uses of the same table within a single SELECT statement.
*/
SELECT cust_name, cust_contact
FROM Customers C, Orders O, OrderItems OI
WHERE C.cust_id = O.cust_id
	AND O.order_num = OI.order_num
	AND OI.prod_id = 'RGAN01';

/*
You'll notice that the three tables in the FROM clauses all have aliases. Customers
C establishes C as an alias for Customers, and so on. This approach enables
you to use the abbreviated C instead of the full text CUstomers. In this example, the
table aliases were used only in the WHERE clause, but aliases are not limited to just WHERE.
You can use aliases in the SELECT list, the ORDER BY clause, and in any other part of the statement as well.
*/

/*
Caution: No AS in Oracle
Oracle does not support the AS keyword when aliasing tables. To use aliases in Oracle, simply specify
the alias without AS (so Customers C instead of CUstomers AS C)
*/

/*
It is also worth noting that table aliases are only used during query execution.
Unlike column aliases, table aliases are never returned to the client.
*/

-- ==== Using Different Join Types =========== --
/*
Thus far you have used only simple joins known as inner joins or equijoins.
But take a look at three additional join types: the self join, the natural join, and the outer join.
*/

-- Self Joins
/*
One of the primary reasons to use table aliases is to be able to refer to the same table
more than once in a single SELECT statement.

Suppose you wanted to send a mailing to all the customer contacts who work for the same company
for which Jim Jones works. This query requires that you first find out which company Jim Jones works for
and next which customers work for that company. The following is one way to approach this problem:
*/
SELECT cust_id, cust_name, cust_contact
FROM Customers
WHERE cust_name = (SELECT cust_name
					FROM Customers
					WHERE cust_contact = 'Jim Jones');

/*
cust_id		cust_name	cust_contact
-------- -------------- --------------
1000000003	Fun4All		Jim Jones
1000000004	Fun4All		Denise L. Stephens
*/

/*
The first solution uses subqueries. The inner SELECT statement does a simple retrieval to return
the cust_name of the company that Jim Jones works for. That name is the one used in the WHERE clause of
the outer query so that all employees who work for that company are retrieved.
*/

/*
The same query using a join
*/

SELECT C1.cust_id, C1.cust_name, C1.cust_contact
FROM Customers C1, Customers C2
WHERE C1.cust_name = C2.cust_name
	AND C2.cust_contact = 'Jim Jones';

/*
cust_id		cust_name	cust_contact
------- ----------- --------------
1000000003	Fun4All		Jim Jones
1000000004	Fun4All		Denise L. Stephens
*/

/*
The two tables needed in this query are actually the same table, and so the Customers table appears
in the FROM clause twice. Although this is perfectly legal, any references to table Customers would be ambiguous
because the DBMS does not know which Customers table you are referring to.

To resolve this problem, table aliases are used. The first occurrence of Customers has an alias of C1,
and the second has an alias of C2. Now those aliases can be used as table names. The SELECT statement,
for example, uses the C1 prefix to explicitly state the full name of the desired columns. If it did not,
the DBMS would return an error because there are two of each column named cust_id, cust_name and cust_contact.
It cannot know which one you want. The WHERE clause first joins the tables and then filters the data by
cust_contact in the second table to return only the wanted data.
*/

/*
Tip: Self Joins Instead of Subqueries
Self joins are often used to repalce statements using subqueries that retrieve data from the same table as the outer statement.
Although the end result is the same, manu DBMSs process joins far more quickly than they do subqueries.
It is usually worth experimenting with both to determine which performs better.
*/

-- ==== Natural Joins ====== --
/*
Whenever tables are joined, at least one column will appear in more than one table (the columns being used
to create the joins). Standard joins (the inner joins that you learned about) return all data, even multiple
occurrences of the same column. A natural join simply eliminates those multiple occurrences so that only one
of each column is returned.

How does it do this? The answer is it doesn't-you do it. A natural join is a join 
in which you select only columns that are unique. This is typically done using a
wildcard (SELECT *) for one table and explicit subsets of the columns for all other
tables. Example:
*/

SELECT C.*, O.order_num, O.order_date, OI.prod_id, OI.quantity, OI.item_price
FROM Customers C, Orders O, OrderItems OI
WHERE C.cust_id = O.cust_id 
	AND O.order_num = OI.order_num
	AND prod_id = 'RGAN01';

/*
A wildcard is used for the first table only. All other columns are 
explicitly listed so that no duplicate columns are retrieved.

The truth is, every innner join you have created thus far is actually a natural join,
and you will probably never need an inner join that is not a natural join.
*/

-- ============= Outer Joins ================ --
/*
Most joins relate rows in one table with rows in another. But occasionally, you
want to include rows that have no related rows. For example, you might use joins to
accomplish the folowing task:
	- Count how many orders were placed by each customer, including customers 
	that have yet to place an order.
	- List all products with order quantities, including products not ordered by anyone.
	- Calculate average sale sizes, taking into account customers that have not yet placed an order.

In each of these examples, the join includes table rows that have no associated rows in the related table.
This type of join is called an outer join.
*/

/*
The following SELECT statement is a simple inner join. It retrives a list of all customers and their orders
*/

SELECT Customers.cust_id, Orders.order_num
FROM Customers
	INNER JOIN Orders ON Customers.cust_id = Orders.cust_id

/*
Outer join syntax is similar. To retrieve a list of all customers including those who have placed no orders
*/
SELECT Customers.cust_id, Orders.order_num
FROM Customers
	LEFT OUTER JOIN Orders ON Customers.cust_id = Orders.cust_id

/*
cust_id		order_num
---------- ---------
1000000001	20005
1000000001	20009
1000000002	NULL
1000000003	20006
1000000004	20007
1000000005	20008
*/

/*
This SELECT statement uses the keywords OUTER JOIN to specify the join type 
(instead of sepcifying it in the WHERE clause). But unlike inner joins, which
relate rows in both tables, outer joins also include rows with no related rows.
When using OUTER JOIN syntax, you must use the RIGHT or LEFT keywords to specify
the table from which to include all rows (RIGHT for the one on the right of OUTER JOIN
and LEFT for the one on the left). The previous example uses LEFT OUTER JOIN to select 
all rows from the table on the left in the FROM clause (the Customers table). To select all rows
from the table on the right, you use a RIGHT OUTER JOIN as seen in this next example:
*/

SELECT Customers.cust_id, Orders.order_num
FROM Customers
	RIGHT OUTER JOIN Orders ON Customers.cust_id = Orders.cust_id;

/*
Tip: Outer Join Types

Remember that here are always two basic forms of outer joins - the left outer join
and the right outer join. The only differece between them is the order of tables
that they are relating. In other words, a left outer join can be turned into a right
outer join join simply by reversing the other of the tables in the FROM or WHERE clause.
As such, the two types of outer join can be used interchangeably, and the decision about 
which one is used is based purely on convenience.
*/

/*
There is one other variant of the outer join, one that tends to be rarely used.
The full outer join retrieves all rows from both tables and relates those that can be related.
Unlike a left outer join or right outer join, which inclues unrelated rows from a single tables,
the full ter join inclues unrelated rows from both tables. The syntax for full outer join is follows:
*/

SELECT Customers.cust_id, Orders.cust_id
FROM Customers
	FULL OUTER JOIN Orders ON Customers.cust_id = Orders.cust_id;

/*
Caution: FULL OUTER JOIN support

The FULL OUTER JOIN syntax is not supported by MariaDB, MySQL, or SQLite.
*/

-- ========= Using Joins with Aggregate Functions ========== --

/*
You want to retrieve a list of all customers and the number of orders that each has placed.
The following code uses the COUNT() function to achieve this:
*/

SELECT C.cust_id, COUNT(O.order_num) AS num_ord
FROM Customers C
	INNER JOIN Orders O ON C.cust_id = O.cust_id
GROUP BY C.cust_id

/*
cust_id		num_ord
---------- --------
1000000001	2
1000000003	1
1000000004	1
1000000005	1
*/

/*
This SELECT statement uses INNER JOIN to relate the Customers and Orders tables to each other.
The GROUP BY clause groups the data by customer, and so the function call COUNT(O.order_num) counts
the number of orders for each customer and returns it as num_ord.

Aggregate functions can be used just as easily with other join types. Example:
*/

SELECT Customers.cust_id,
		COUNT(Orders.order_num) AS num_ord
FROM Customers
	LEFT OUTER JOIN Orders ON Customers.cust_id = Orders.cust_id
GROUP BY Customers.cust_id;/*cust_id		num_ord
---------- -------
1000000001	2
1000000002	0
1000000003	1
1000000004	1
1000000005	1*//*This example uses a left outer join to include all customers, even those who have not placed any orders.The results show that customer 1000000002 with 0 orders is included this time, unlike when the INNER JOIN was used.*/-- ======== Using Joins and Join Conditions =========== --/*Before I wrap up our two-lesson discussion on joins, I think it is worthwhile to summarize some keypointsregarding joins and their use:	- Pay carefull attention to the type of join being used. More often than not, youll	want an innder join, but there are often valid uses for outer joins too.	- Check your DBMS documentation for the exact join syntax it supports.	- Make sure you use the correct join condition ( regardless of the syntax being used), or you'll	return incorrect data.	- Make sure you always provide a join condition, or you'll end up with the Cartesian product or an error.	- You may include multiple tables in a join and even have different join types for each. 	Although this is legal and often useful, make sure you test each join separately before testing them together.	This will make troubleshooting far simpler.*//*Challenges1. Write a SQL statement using an INNER ORDER to retrieve customer name (cust_name in Customers) and all orders numbers (order_num in Orders) for each.*/SELECT C.cust_name, O.order_numFROM Customers C	INNER JOIN Orders O ON C.cust_id = O.cust_idORDER BY C.cust_nameSELECT C.cust_name, STRING_AGG(O.order_num, ', ') AS order_numbersFROM Customers C	INNER JOIN Orders O ON C.cust_id = O.cust_idGROUP BY C.cust_nameORDER BY C.cust_name/*2. Modify the SQLstatement you just created to list all customers, even those with no orders.*/SELECT C.cust_name, O.order_numFROM Customers C	LEFT OUTER JOIN Orders O ON C.cust_id = O.cust_idORDER BY C.cust_nameSELECT C.cust_name, STRING_AGG(O.order_num, ', ') AS order_numbersFROM Customers C	LEFT OUTER JOIN Orders O ON C.cust_id = O.cust_idGROUP BY C.cust_nameORDER BY C.cust_name/*3. Use an OUTER JOIN to join the Products and OrderItems tables, returning a
sorted list of product names (prod_name) and the order numbers (order_num)
associated with each*/SELECT P.prod_name, OI.order_numFROM Products P	LEFT OUTER JOIN OrderItems OI ON P.prod_id = OI.prod_idORDER BY P.prod_name/*4. Modify the SQLstatement created in the previous challenge so that it returns
a total of number of orders for each item (as opposed to the order numbers).*/SELECT P.prod_name, COUNT(OI.order_num) AS total_numberFROM Products P	LEFT OUTER JOIN OrderItems OI ON P.prod_id = OI.prod_idGROUP BY P.prod_nameORDER BY P.prod_name/*5. Write a SQLstatement to list vendors (vend_id in Vendors) and the number
of products they have available, including vendors with no products. You’ll want to use an OUTER JOIN and the COUNT() aggregate function to count the
number of products for each in the Products table. Pay attention: the vend_idcolumn appears in multiple tables, so any time you refer to it, you’ll need to
fully qualify it.*/SELECT V.vend_id, COUNT(P.prod_id) AS number_of_productsFROM Vendors V	LEFT OUTER JOIN Products P ON V.vend_id = P.vend_idGROUP BY V.vend_idORDER BY number_of_products DESC