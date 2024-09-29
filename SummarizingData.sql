-- ============ Summarizing Data ====================

-- =================== Using Aggregate functions =================--
/*
It is often necessary to summarize data without actually retrieving it all, and SQLprovides special functions for this purpose. Using these functions, SQLqueries
are often used to retrieve data for analysis and reporting purposes. Examples of
this type of retrieval are
	- Determining the number of rows in a table (or the number of rows that meet some condition or contain a specific value)
	- Obtaining the sum of a set of rows in a table
	- Finding the highest, lowest, and average values in a table column (either for all rows or for specific rows)
*/

/*
In each of these examples, you want a summary of the data in a table, not the
actual data itself. Therefore, returning the actual table data would be a waste of
time and processing resources (not to mention bandwidth). To repeat, all you
really want is the summary information.
*/

/*
To facilitate this type of retrieval, SQL features a set of five aggregate functions. These functions enable you to perform all the types
of retrieval just enumerated. You’ll be relieved to know that unlike the data manipulation functions in the last lesson, SQL’s aggregate functions are supported
pretty consistently by the major SQLimplementations.
*/

/*
AVG()		Returns a column’s average value
COUNT()		Returns the number of rows in a column
MAX()		Returns a column’s highest value
MIN()		Returns a column’s lowest value
SUM()		Returns the sum of a column’s values
*/

/*
New Term: Aggregate Functions
Functions that operate on a set of rows to calculate and return a single value.
*/

-- =============== The AVG() Function ================= --
/*
AVG() is used to return the average value of a specific column by counting both thenumber of rows in the table and the sum of their values. AVG() can be used to
return the average value of all columns or of specific columns or rows.
*/

SELECT AVG(prod_price) AS avg_price
FROM Products;

/*
avg_price
-------------
6.823333
*/

/*
Analysis ▾
The SELECT statement above returns a single value—avg_price, which contains
the average price of all products in the Products table. avg_price is an alias
*/

/*
AVG() can also be used to determine the average value of specific columns or
rows. The following example returns the average price of products offered by a
specific vendor:
*/

SELECT AVG(prod_price) AS avg_price
FROM Products
WHERE vend_id = 'DLL01';

/*
avg_price
-----------
3.8650
*/

/*
This SELECT statement differs from the previous one only in that this one contains
a WHERE clause. The WHERE clause filters only products with a vendor_id of DLL01,
and, therefore, the value returned in avg_price is the average of just that vendor’s
products.
*/

/*
Caution: Individual Columns Only
AVG() may only be used to determine the average of a specific numeric
column, and that column name must be specified as the function parameter. To
obtain the average value of multiple columns, you must use multiple AVG()
functions. The exception to this is when returning a single value that is
calculated from multiple columns
*/

/*
Note: NULL values
Column rows containing NULL values are ignored by the AVG() function.
*/

-- ============== The COUNT() Function ================ -- 


/*
COUNT() does just that—it counts. Using COUNT(), you can determine the number of
rows in a table or the number of rows that match a specific criterion.

COUNT() can be used two ways:
	- Use COUNT(*) to count the number of rows in a table, whether columns contain values or NULL values.
	- Use COUNT(column) to count the number of rows that have values in a specific column, ignoring NULL values.
*/

-- This first example returns the total number of customers in the Customers table:
SELECT COUNT(*) AS num_cust
FROM Customers

/*
num_cust
--------
5
*/

/*
In this example, COUNT(*) is used to count all rows, regardless of values. The
count is returned in num_cust.
*/

-- The following example counts just the customers with an email address:
SELECT COUNT(cust_email) AS num_cust
FROM Customers;

/*
num_cust
--------
3
*/

/*
This SELECT statement uses COUNT(cust_email) to count only rows with a value inthe cust_email column. In this example, cust_email is 3 (meaning that only 3 of
the 5 customers have email addresses).
*/

/*
Note: NULL Values
Column rows with NULL values in them are ignored by the COUNT() function if
a column name is specified, but not if the asterisk (*) is used.
*/

-- ================ The MAX() Function ======================= --
/*
MAX() returns the highest value in a specified column. MAX() requires that the
column name be specified
*/
SELECT MAX(prod_price) AS max_price
FROM Products

/*
max_price
----------
11.9900
*/

/*
Here MAX() returns the price of the most expensive item in the Products table.
*/

/*
Tip: Using MAX() with Nonnumeric Data
Although MAX() is usually used to find the highest numeric or date values, many (but not all) DBMSs allow it to be used to return the highest value in
any columns including textual columns. When used with textual data, MAX()
returns the row that would be the last if the data were sorted by that column
*/

/*
Note: NULL Values
Column rows with NULL values in them are ignored by the MAX() function.
*/

-- =================== The MIN() Function ===================== --
/*
MIN() does the exact opposite of MAX()—it returns the lowest value in a specified
column. Like MAX(), MIN() requires that the column name be specified
*/

SELECT MIN(prod_price) AS min_price
FROM Products;


/*
min_price
----------
3.4900
*/

/*
Here MIN() returns the price of the least expensive item in the Products table
*/

/*
Tip: Using MIN() with Nonnumeric Data

Although MIN() is usually used to find the lowest numeric or date values, many (but not all) DBMSs allow it to be used to return the lowest value in
any columns including textual columns. When used with textual data, MIN() will return the row that would be first if the data were sorted by that column.
*/


/*
Note: NULL Values
Column rows with NULL values in them are ignored by the MIN() function.
*/

-- ============ The SUM() Function ==================== --
/*
SUM() is used to return the sum (total) of the values in a specific column.
Here is an example to demonstrate this. The OrderItems table contains the actual
items in an order, and each item has an associated quantity. The total number of
items ordered (the sum of all the quantity values) can be retrieved as follows:
*/

SELECT SUM(quantity) AS items_ordered
FROM OrderItems
WHERE order_num = 20005;

/*
items_ordered
----------
200
*/

/*
The function SUM(quantity) returns the sum of all the item quantities in an order,
and the WHERE clause ensures that just the right order items are included.

SUM() can also be used to total calculated values. In this next example the total
order amount is retrieved by totaling item_price*quantity for each item:
*/

SELECT SUM(item_price * quantity) AS total_price
FROM OrderItems
WHERE order_num = 20005;

/*
The function SUM(item_price*quantity) returns the sum of all the expanded
prices in an order, and again the WHERE clause ensures that just the right order
items are included.
*/

/*
Tip: Performing Calculations on Multiple ColumnsAll the aggregate functions can be used to perform calculations on multiple
columns using the standard mathematical operators, as shown in the example.
*/

/*
Note: NULL Values
Column rows with NULL values in them are ignored by the SUM() function.
*/

-- =========================== Aggregates on Distinct Values ============================ --

/*
The five aggregate functions can all be used in two ways:
	- To perform calculations on all rows, specify the ALL argument or specify no argument at all (because ALL is the default behavior).	- To include only unique values, specify the DISTINCT argument.
*/

/*
Tip: All is Default
The ALL argument need not be specified because it is the default behavior. If
DISTINCT is not specified, ALL is assumed.
*/

/*
The following example uses the AVG() function to return the average product priceoffered by a specific vendor. It is the same SELECT statement used above, but here
the DISTINCT argument is used so that the average only takes into account unique
prices:
*/
SELECT AVG(ALL prod_price) AS avg_price
FROM Products
WHERE vend_id = 'DLL01';

SELECT AVG (DISTINCT prod_price) AS avg_price
FROM Products
WHERE vend_id = 'DLL01';

/*
avg_price is higher when DISTINCT is used
because there are multiple items with the same lower price. Excluding them
raises the average price.
*/

/*
Caution: No DISTINCT with COUNT(*)
DISTINCT may only be used with COUNT() if a column name is specified. DISTINCT may not be used with COUNT(*).
Similarly, DISTINCT must be used with a column name and not with a calculation or expression.
*/

/*
TIP: Using DISTINCT with MIN() and MAX()
Although DISTINCT can technically be used with MIN() and MAX(), there is
actually no value in doing so. The minimum and maximum values in a column will be the same whether or not only distinct values are included.
*/

/*
Note: Additional Aggregate Arguments

In addition to the DISTINCT and ALL arguments shown here, some DBMSs
support additional arguments such as TOP and TOP PERCENT that let you
perform calculations on subsets of query results. Refer to your DBMS
documentation to determine exactly what arguments are available to you.
*/

-- ======================  Combining Aggregate Functions ====================== --

/*
All the examples of aggregate functions used thus far have involved a single
function. But actually, SELECT statements can contain as few or as many aggregate
functions as needed. Look at this example:
*/

SELECT COUNT(*) AS num_items,
		MIN(prod_price) AS price_min,
		MAX(prod_price) AS price_max,
		AVG(prod_price) AS price_avg
FROM Products;

/*
num_items price_min price_max price_avg
---------- --------------- --------------- ---------
9			3.4900	11.9900		6.823333
*/

/*
Aggregate functions are used to summarize data. SQLsupports five aggregate
functions, all of which can be used in multiple ways to return just the results you
need. These functions are designed to be highly efficient, and they usually return
results far more quickly than you could calculate them yourself within your own
client application.
*/


/*
Here a single SELECT statement performs four aggregate calculations in one step
and returns four values (the number of items in the Products table and the highest,
lowest, and average product prices).
*/

/*
Caution: Naming Aliases
When specifying alias names to contain the results of an aggregate function, try to not use the name of an actual column in the table.
Although there is nothing actually illegal about doing so, many SQLimplementations do not
support this and will generate obscure error messages if you do so.
*/

-- ========= Challenges ============= --

/*
1. Write a SQLstatement to determine the total number of items sold (using the
quantity column in OrderItems).
*/

SELECT SUM([quantity]) AS total_items_sold
FROM  [dbo].[OrderItems]

/*
Modify the statement you just created to determine the total number of
product item (prod_item) BR01 sold
*/

SELECT SUM([quantity]) AS total_items_sold
FROM  [dbo].[OrderItems]
WHERE [prod_id] = 'BR01'

/*
Write a SQLstatement to determine the price (prod_price) of the most
expensive item in the Products table that costs no more than 10. Name the
calculated field max_price.
*/

SELECT MAX([prod_price]) as max_price
FROM [dbo].[Products]
WHERE [prod_price] <= 10