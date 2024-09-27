SELECT prod_name
FROM Products;/*The data appears to be
displayed in no particular order at all.prod_name
--------------------
Fish bean bag toy
Bird bean bag toy
Rabbit bean bag toy
8 inch teddy bear
12 inch teddy bear
18 inch teddy bear
Raggedy Ann
King doll
Queen doll*//*if data was subsequently updated or deleted, the order will be affected
by how the DBMS reuses reclaimed storage space*/

/*
To explicitly sort data retrieved using a SELECT statement, you use the ORDER BY
clause.
ORDER BY takes the name of one or more columns by which to sort the
output.
*/

SELECT prod_name
FROM Products
ORDER BY prod_name;

/*
prod_name
--------------------
12 inch teddy bear
18 inch teddy bear
8 inch teddy bear
Bird bean bag toy
Fish bean bag toy
King doll
Queen doll
Rabbit bean bag toy
Raggedy Ann
*/

/*
Caution: Position of ORDER BY clause

When specifying an ORDER BY clause, be sure that it is the last clause in your
SELECT statement. If it is not the last clause, an error will be generated.
*/

/*
Although more often than not the columns used in an ORDER BY clause will be
ones selected for display, this is actually not required. It is perfectly legal to
sort data by a column that is not retrieved.
*/

SELECT vend_id
FROM Products
ORDER BY prod_name;


-- ============Sorting by Multiple Columns===============
/*
To sort by multiple columns, simply specify the column names separated by
commas (just as you do when you are selecting multiple columns).
*/

/*

e, if you aredisplaying an employee list, you might want to display it sorted by last name and
first name (first by last name, and then within each last name sort by first name). This type of sort would be useful if there are multiple employees with the same
last name

The following code retrieves three columns and sorts the results by two of them —first by price and then by name.
*/

SELECT prod_id, prod_price, prod_name
FROM Products
ORDER BY prod_price, prod_name;/*prod_id prod_price prod_name
------- ---------- --------------------
BNBG02 3.4900 Bird bean bag toy
BNBG01 3.4900 Fish bean bag toy
BNBG03 3.4900 Rabbit bean bag toy
RGAN01 4.9900 Raggedy Ann
BR01 5.9900 8 inch teddy bear
BR02 8.9900 12 inch teddy bear
RYL01 9.4900 King doll
RYL02 9.4900 Queen doll
BR03 11.9900 18 inch teddy bearIt is important to understand that when you are sorting by multiple columns, the
sort sequence is exactly as specified. In other words, using the output in the
example above, the products are sorted by the prod_name column only when multiple rows have the same prod_price value. If all the values in the prod_pricecolumn had been unique, no data would have been sorted by prod_name.*/
-- ============================ Sorting by Column Position=======================================
/*
, ORDER BY
also supports ordering specified by relative column position
*/
SELECT prod_id, prod_price, prod_name
FROM Products
ORDER BY 2, 3;

/*
prod_id prod_price prod_name
------- ---------- --------------------
BNBG02 3.4900 Bird bean bag toy
BNBG01 3.4900 Fish bean bag toy
BNBG03 3.4900 Rabbit bean bag toy
RGAN01 4.9900 Raggedy Ann
BR01 5.9900 8 inch teddy bear
BR02 8.9900 12 inch teddy bear
RYL01 9.4900 King doll
RYL02 9.4900 Queen doll
BR03 11.9900 18 inch teddy bear
*/

/*
As you can see, the output is identical to that of the query above. The difference
here is in the ORDER BY clause. Instead of specifying column names, you specify
the relative positions of selected columns in the SELECT list. ORDER BY 2 means
sort by the second column in the SELECT list, the prod_price column. ORDER BY 2,
3 means sort by prod_price and then by prod_name
*/

/*

The primary advantage of this technique is that it saves retyping the column
names. But there are some downsides too. First, not explicitly listing column
names increases the likelihood of you mistakenly specifying the wrong column.
Second, it is all too easy to mistakenly reorder data when making changes to the
SELECT list (forgetting to make the corresponding changes to the ORDER BY clause). And finally, obviously you cannot use this technique when sorting by columns that
are not in the SELECT list.
*/


--=========================================== Specifying Sort Direction ==========================================--
/*
The following example sorts the products by price in descending order (most
expensive first):
*/

SELECT prod_id, prod_price, prod_name
FROM Products
ORDER BY prod_price DESC;

/*
prod_id prod_price prod_name
------- ---------- --------------------
BR03 11.9900 18 inch teddy bear
RYL01 9.4900 King doll
RYL02 9.4900 Queen doll
BR02 8.9900 12 inch teddy bear
BR01 5.9900 8 inch teddy bear
RGAN01 4.9900 Raggedy Ann
BNBG01 3.4900 Fish bean bag toy
BNBG02 3.4900 Bird bean bag toy
BNBG03 3.4900 Rabbit bean bag toy
*/

/*
The following example sorts
the products in descending order (most expensive first), plus product name:
*/

SELECT prod_id, prod_price, prod_name FROM Products ORDER BY prod_price DESC, prod_name;

/*

prod_id prod_price prod_name
------- ---------- --------------------
BR03 11.9900 18 inch teddy bear
RYL01 9.4900 King doll
RYL02 9.4900 Queen doll
BR02 8.9900 12 inch teddy bear
BR01 5.9900 8 inch teddy bear
RGAN01 4.9900 Raggedy Ann
BNBG02 3.4900 Bird bean bag toy
BNBG01 3.4900 Fish bean bag toy
BNBG03 3.4900 Rabbit bean bag toy
*/

/*
The DESC keyword only applies to the column name that directly precedes it. In
the example above, DESC was specified for the prod_price column, but not for
the prod_name column. Therefore, the prod_price column is sorted in descending
order, but the prod_name column (within each price) is still sorted in standard
ascending order.
*/


/*
Caution: Sorting Descending on Multiple ColumnsIf you want to sort descending on multiple columns, be sure each column has
its own DESC keyword.
*/

/*
Tip: Case Sensitivity and Sort OrdersWhen you are sorting textual data, is A the same as a? And does a come before B or after Z? These are not theoretical questions, and the answers depend on how the database is set up

In dictionary sort order, A is treated the same as a, and that is the default
behavior for most DBMSs. However, most good DBMSs enable database
administrators to change this behavior if needed. (If your database contains
lots of foreign language characters, this might become necessary.)
The key here is that, if you do need an alternate sort order, you may not be
able to accomplish this with a simple ORDER BY clause. You may need to
contact your database administrator.

*/

/*
ORDER BY clasue must be the last in the SELECT statement, can
be used to sort data on one or more columns as needed.
*/

/*
Challenges
1. Write a SQLstatement to retrieve all customer names (cust_names) from the
Customers table, and display the results sorted from Z to A.

2. Write a SQLstatement to retrieve customer ID (cust_id) and order number
(order_num) from the Orders table, and sort the results first by customer ID
and then by order date in reverse chronological order.

3. Our fictitious store obviously prefers to sell more expensive items, and lots
of them. Write a SQLstatement to display the quantity and price
(item_price) from the OrderItems table, sorted with the highest quantity and
highest price first.

4. What is wrong with the following SQLstatement? (Try to figure it out without running it):
SELECT vend_name,
FROM Vendors
ORDER vend_name DESC;
- There should not be a comma after vender_name( a comma is only used to separate multiple columns), and BY is missing after ORDER
*/


SELECT cust_name FROM Customers ORDER BY cust_name DESC;

SELECT cust_id, order_num FROM Orders ORDER BY cust_id, order_date DESC;

SELECT quantity, item_price FROM OrderItems ORDER BY quantity DESC, item_price DESC;

