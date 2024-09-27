-- Retrieving Invidual Columns
SELECT prod_name
FROM Products;

-- The output from this statement is shown in the following
/*
	prod_name
--------------------
	Fish bean bag toy
	Bird bean bag toy
	Rabbit bean bag toy
	8 inch teddy bear
	12 inch teddy bear
	18 inch teddy bear
	Raggedy Ann
	King doll
	Queen doll
*/

/*
	NOTE: It is important to note that SQL statements are not case sensitive, so SELECT is the same as select.

	All extra white space within a SQLstatement is ignored when that statement is processed. SQLstatements can be specified on one long line or broken up over many lines. So, the following three statements are functionally identical:
*/
SELECT prod_name
FROM Products;

SELECT prod_name FROM Products;

SELECT
prod_name
FROM
Products; 

-- A reserverd word that is a part of the SQL language. Never name a table or column using a keyword.
/*
	To use SELECT to retrieve table data, you must, at a minimin, specify two pieces of information - what you want to select and from where you want to select it
*/


-- Retrieving Multiple Columns
/*
To retrieve multiple columns from a table, the same SELECT statement is used. The
only difference is that multiple column names must be specified after the SELECT
keyword, and each column must be separated by a comma.

Tip: Take care with commas
When selecting multiple columns, be sure to specify a comma between each
column name, but not after the last column name. Doing so will generate an
error.
*/
SELECT prod_id, prod_name, prod_price FROM Products;

/*
Just as in the prior example, this statement uses the SELECT statement to retrieve
data from the Products table. In this example, three column names are specified,
each separated by a comma. The output from this statement is shown below:

prod_id prod_name prod_price
--------- -------------------- ----------
BNBG01 Fish bean bag toy 3.49
BNBG02 Bird bean bag toy 3.49
BNBG03 Rabbit bean bag toy 3.49
BR01 8 inch teddy bear 5.99
BR02 12 inch teddy bear 8.99
BR03 18 inch teddy bear 11.99
RGAN01 Raggedy Ann 4.99
RYL01 King doll 9.49
RYL02 Queen dool 9.49
*/

/*
NOTE: Presentation of Data
SQLstatements typically return raw, unformatted data, and different DBMSs
and clients may display the data differently. Data formatting is a presentation issue, not a
retrieval issue. Therefore, presentation is typically specified in the
application that displays the data.
*/

/**/

/*
	Retrieving all columns
	using the asterisk (*) wildcard character
*/
SELECT *
FROM Products;

/*
	As a rule, you are better of not using the * wildcard unless you really do
need every column in the table. Even though use of wildcards may save you
the time. Even though use of wildcards may save you
the time and effort needed to list the desired columns explicitly,retrieving
unnecessary columns usually slows down the performance of your retrieval
and your application.
*/

/*
Tip: Retrieving Unknown Columns

There is one big advantage to using wildcards. As you do not explicitly
specify column names (because the asterisk retrieves every column), it is
possible to retrieve columns whose names are unknown.
*/

-- =============== Retrieving Distinct Rows================
SELECT DISTINCT vend_id FROM Products;

/*
SELECT DISTINCT vend_id tells the DBMS to only return distinct (unique) vend_id rows, and so only three rows are returned.
If used, the DISTINCT keyword must be placed directly in front of the column names
*/

/*
Caution: Can't be Partially DISTINCT
The DISTINCT keyword applies to all columns, not just the one it precedes. If
you were to specify SELECT DISTINCT vend_id, prod_price, six of the nine
rows would be retrieved because the combined specified columns produced
six unique combinations.
*/
SELECT DISTINCT vend_id, prod_price FROM Products;
SELECT vend_id, prod_price FROM Products;

--====================Limiting Results====================
SELECT  TOP 2   prod_name FROM Products;

/*
Output:
prod_name
-----------------
8 inch teddy bear
12 inch teddy bear
18 inch teddy bear
Fish bean bag toy
Bird bean bag toy
*/

/*
The previous statement uses the SELECT TOP 5 statement to retrieve just the first
five rows.
*/


/*
To get the next five rows, specify both where to start and the number of rows to
retrieve, like this:

*/

SELECT prod_name
FROM ProductsORDER BY prod_name -- required, when getting the next five rows,OFFSET 5 ROWS -- numbers row ignoreFETCH NEXT 5 ROWS ONLY;  -- limit results/*ORDER BY prod_nameOFFSET 5 ROWSFETCH NEXT 5 ROWS ONLYprod_name
-------------------King doll                                                                                                                                                                                                                                                      
Queen doll                                                                                                                                                                                                                                                     
Rabbit bean bag toy                                                                                                                                                                                                                                            
Raggedy Ann                                                                                                                                                                                                                                                    ORDER BY is required,  OFFETS 5 ROWS FETCH NEXT 5 ROWS ONLY instructs supported DBMSs return fieve rows starting from row 5.The first number is where to start, and the second number is the number of rows to retrieve.So FETCH NEXT specifies the number of rows to return,  OFFSET ... ROWS specifies where to start from. In the example, there are only nine products in the Products table so  OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY returned just four row (as there was no fifth)*//*Caution: Row 0The first row retrieved is is row 0, not row 1. Such as, ORDER BY prod_name OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY; will retrieve the second row, not the first one.*//*Challengens1. Write a SQLstatement to retrieve all customer IDs (cust_id) from the
Customers table.

2. The OrderItems table contains every item ordered (and some were ordered multiple times). Write a SQLstatement to retrieve a list of the products
(prod_id) ordered (not every order, just a unique list of products). Here’s a
hint: you should end up with seven unique rows displayed.

3. Write a SQLstatement that retrieves all columns from the Customers table
and an alternate SELECT that retrieves just the customer ID. Use comments to
comment out one SELECT so as to be able to run the other. (And, of course,
test both statements.)*/-- 1SELECT cust_id FROM Customers;-- 2SELECT DISTINCT prod_id FROM OrderItems;-- 3SELECT * FROM Customers;SELECT cust_id FROM Customers;