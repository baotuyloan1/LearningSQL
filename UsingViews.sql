-- ================= Creating Views ====================== --

/*
Views are created using the CREATE VIEW statement. Like CREATE TABLE, CREATE
VIEW can only be used to create a view that does not exist.
*/

/*
Note: Renaming views
To remove a view, you use the DROP statement. The syntax is simply DROP VIEW viewname;
To override (or update) a view, you must first DROP it and then re-create it.
*/

/*
Using Views to Simplify Complex Joins
One of the most common uses of views is to hide complex SQL, and this often involves
joins
*/

CREATE VIEW ProductCusomters AS
SELECT cust_name, cust_contact, prod_id
FROM Customers C, Orders O, OrderItems OI
WHERE C.cust_id = O.cust_id AND
	OI.order_num = O.order_num


/*
This statement creates a view named Product, which joins three tables
to return a list of all customers who have order any product. If you were to use
SELECT * FROM ProductCustomers, you'd list every customer who ordered anything.

To retrieve a list of customers who ordered product RGAN01, you can do the following:
*/

SELECT cust_name, cust_contact
FROM ProductCusomters
WHERE prod_id = 'RGAN01';

/*
cust_name			cust_contact
------------------- ------------------
Fun4All				Denise L. Stephens
The Toy Store		Kim Howard

*/

/*
This statement retrieves specific data from the view by issuing a WHERE clause.
When the DBMS process the request, it adds the specified WHERE clause to any
existing WHERE clause in the view query so that the data is filtered correctly.

As you can see, views can greatly simplify the use of complex SQL statements.
Using views, you can write the underlying SQL once and then reuse it as needed.
*/

/*
Tip: Creating Reusable Views
It is a good idea to create views that are not tried to specific data. For
example, the view created above returns for all products, not just product
RGAN01 (for which the view was first created). Expanding the scope of the view
enables it to be reused, making it even more useful. It also eliminates
the need for you create and maintain multiple similar views.
*/

/*
Using Views to reformat retrieved data.
Another common use of views is for reformatting retrived data.
The following SQL Server SLECT statement return vendor name and location
in a single combined calculated column:
*/

SELECT RTRIM(vend_name) + '(' + RTRIM(vend_country) + ')'
	AS vend_title
FROM Vendors
ORDER BY vend_name

/*
vend_title
-----------------------------------------------------------
Bear Emporium (USA)
Bears R Us (USA)
Doll House Inc. (USA)
Fun and Games (England)
Furball Inc. (USA)
Jouets et ours (France)
*/

/*
Now suppose that you regularly needed results in this format. Rather than perform
the concetenation each time it was needed, you could create a view and use that
instead. To turn this statement into a view, you can do the following:
*/

CREATE VIEW VendorLocations AS
SELECT RTRIM(vend_name) + ' (' + RTRIM(vend_country) + ')' AS vend_title
FROM Vendors

/*
This statement creates a view using the exact same query as the previous SELECT
statement. To retrieve the data to create all mailing labels, simply do the following:
*/

SELECT * FROM VendorLocations;

/*
vend_title
-----------------------------------------------------------
Bear Emporium (USA)
Bears R Us (USA)
Doll House Inc. (USA)
Fun and Games (England)
Furball Inc. (USA)
Jouets et ours (France)
*/


/*
Note: SELECT Restrictions all apply
The syntax used to create views is rather consistent between DBMSs.
So why multiple versions of statements? A view simply wraps a SELECT statement,
and the syntax of that SELECT must  adhere to all the rules and restrictions of the DBMS being used.
*/

-- ================== Using Views to FIlter Unwanted Data =========== --

/*
Views are also useful for applying common WHERE clause. For example, you
might want to define a CustomerEmailList view so that it filters out customers
without email address. To do this, you can use the following statement:
*/

CREATE VIEW CusomterEmailList AS
SELECT cust_id, cust_name, cust_email
FROM Customers
WHERE cust_email IS NOT NULL;

/*
Obviously, when sending email to a mailing list, you'd want to ignore users who 
have no email address. THe WHERE clause here filters out those rows that have 
NULL values in the cust_email columns so that they'll not be retrieved.

View CustomerEmailList can now be used like any table:
*/

SELECT *
FROM CusomterEmailList;

/*
cust_id		cust_name		cust_email
---------- ------------ ---------------------
1000000001 Village Toys		sales@villagetoys.com
1000000003 Fun4All			jjones@fun4all.com
1000000004 Fun4All			dstephens@fun4all.com
*/

/*
Note: WHERE Clauses and WHERE clauses

If a WHERE clause is used when retrieving dât frrom the view, the two sets of
clauses(the one in the view and the one passed to it) will be combined automatically
*/

-- ========= Using Views with Calculated Fields =========== --

/*
Views are exceptionally useful from simplifying the use of calculated fields. The
following SELECT statement retrieves the order items for a specific order, calculating
the exapanded price for each item:
*/

SELECT prod_id,
		quantity,
		item_price,
		quantity*item_price AS expanded_price
FROM OrderItems
WHERE order_num = 20008;/*prod_id		quantity	item_price		expanded_price
--------	---------	-----------		--------------
RGAN01		5			4.9900			24.9500
BR03		5			11.9900			59.9500
BNBG01		10			3.4900			34.9000
BNBG02		10			3.4900			34.9000
BNBG03		10			3.4900			34.9000*/CREATE VIEW OrderItemsExpanded AS 
SELECT order_num,
		prod_id,
		quantity,
		item_price,
		quantity*item_price AS expanded_price
FROM OrderItems;

/*
To retrieve the details for order 20008 (the output above), do the following:
*/

SELECT *
FROM OrderItemsExpanded
WHERE order_num = 20008

/*
order_num		prod_id		quantity	item_price		expanded_price
---------		-------		--------- ----------		--------------
20008			RGAN01		5			4.99			24.95
20008			BR03		5			11.99			59.95
20008			BNBG01		10			3.49			34.90
20008			BNBG02		10			3.49			34.90
20008			BNBG03		10			3.49			34.90
*/

/*
As you can see, views are easy to create and even easier to use. Used correctly,
views can greatly simplify complex data manipulation.
*/

/*
1. Create a view called CustomersWithOrders that contains all of the columns
in Customers but includes only those who have placed orders. Hint: you can
use JOIN on the Orders table to filter just the customers you want. Then use a
SELECT to make sure you have the right data.
*/

CREATE VIEW CustomersWithOrders AS
SELECT C.*
FROM Customers C
	INNER JOIN Orders O ON C.cust_id = O.cust_id
	
SELECT * FROM CustomersWithOrders;
/*
What is wrong with the following SQLstatement? (Try to figure it out without running it.)
CREATE VIEW OrderItemsExpanded AS
SELECT order_num,
		prod_id,
		quantity,
		item_price,
		quantity*item_price AS expanded_price
FROM OrderItems
ORDER BY order_num;  // Many DBMSs prohibit the use of the ORDER BY clause in view queries.
*/

/*
ORDER BY is not allowed in views. VIews are used like tables, if you need sorted data
use ORDER BY in the SELECT that retrieves data from a view
*/