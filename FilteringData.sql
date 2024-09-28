/*
Within a SELECT statement, data is filtered by specifying search criteria in the
WHERE clause. The WHERE clause is specified right after the table name (the FROM
clause) as follows:

*/
SELECT prod_name, prod_price
FROM Products
WHERE prod_price = 3.49;

/*
prod_name prod_price
------------------- ----------
Fish bean bag toy 3.49
Bird bean bag toy 3.49
Rabbit bean bag toy 3.49
*/

/*
This example uses a simple equality test: It checks to see if a column has a
specified value, and it filters the data accordingly. But SQLlets you do more than
just test for equality.

*/


/*
Tip: SQL Versus Application Filtering
Data can also be filtered at the client application level, not in the DBMS but
by whatever tool or application retrieves the data from the DBMS. To do this,
the SQLSELECT statement retrieves more data than is actually required for the
client application, and the client code loops through the returned data to
extract just the needed rows.
As a rule, this practice is strongly discouraged. Databases are optimized to
perform filtering quickly and efficiently. Making the client application (or
development language) do the database’s job will dramatically impact
application performance and will create applications that cannot scale
properly. In addition, if data is filtered at the client, the server has to send
unneeded data across the network connections, resulting in a waste of
network bandwidth usage.
*/


/*
Caution: WHERE Clause Position
When using both ORDER BY and WHERE clauses, make sure that ORDER BY comes
after the WHERE. . Otherwise, an error will be generated.
*/

--============================The WHERE Clause Operators===========================
/*
WHERE Clause Operators
Operator Description
= Equality
<> Nonequality
!= Nonequality
< Less than
<= Less than or equal to
!< Not less than
> Greater than
>= Greater than or equal to
!> Not greater than
BETWEEN Between two specified values
IS NULL Is a NULL value
*/


/*
Caution: Operator Compatibility
Some of the operators listed are redundant; for example, <> is the
same as !=. !< (not less than) accomplishes the same effect as >= (greater
than or equal to). Not all of these operators are supported by all DBMSs. Refer to your DBMS documentation to determine exactly what it supports.

*/

-- ========================== Checking Against a Single Value ================================
-- This first example lists all products that cost less than $10:
SELECT prod_name, prod_price
FROM Products
WHERE prod_price < 10;

/*
prod_name prod_price
------------------- ----------
Fish bean bag toy 3.49
Bird bean bag toy 3.49
Rabbit bean bag toy 3.49
8 inch teddy bear 5.99
12 inch teddy bear 8.99
Raggedy Ann 4.99
King doll 9.49
Queen doll 9.49


*/

-- This next statement retrieves all products costing $10 or less
SELECT prod_name, prod_price
FROM Products
WHERE prod_price <= 10;


-- Checking for Nonmatches
SELECT vend_id, prod_name
FROM Products
WHERE vend_id <> 'DLL01';

/*
vend_id prod_name
---------- ------------------
BRS01 8 inch teddy bear
BRS01 12 inch teddy bear
BRS01 18 inch teddy bear
FNG01 King doll
FNG01 Queen doll

*/

/*
Tip: When to Use Quotes
If you look closely at the conditions used in the above WHERE clauses, you will
notice that some values are enclosed within single quotes, and others are not. The single quotes are used to delimit a string. If you are comparing a value
against a column that is a string datatype, the delimiting quotes are required. Quotes are not used to delimit values used with numeric columns.
*/

-- The following is the same example, except that this one uses the != operator instead of <>:
SELECT vend_id, prod_name
FROM Products
WHERE vend_id != 'DLL01';

/*
Caution: != or <>?
Usually, you can use != and <> interchangeably. However, not all DBMSs
support both forms of the nonequality operator. If in doubt, consult your DBMS documentation.

*/


-- =========================== Checking for a Range of Values ===========================================
/*
To check for a range of values, you can use the BETWEEN operator. Its syntax is a
little different from other WHERE clause operators because it requires two values:
the beginning and end of the range. The BETWEEN operator can be used, for
example, to check for all products that cost between $5 and $10 or for all dates
that fall between specified start and end dates.

The following example demonstrates the use of the BETWEEN operator by retrieving all products with a price between $5 and $10:
*/

SELECT prod_name, prod_price
FROM Products
WHERE prod_price BETWEEN 5 AND 10;

/*
prod_name prod_price
------------------- ----------
8 inch teddy bear 5.99
12 inch teddy bear 8.99
King doll 9.49
Queen doll 9.49

*/


/*
As seen in this example, when BETWEEN is used, two values must be specified—the low end and high end of the desired range. The two values must also be
separated by the AND keyword. BETWEEN matches all the values in the range,
including the specified start and end values.
*/

-- ===============================  Checking for No Value =======================================--
/*
When a table is created, the table designer can specify whether or not individual
columns can contain no value. When a column contains no value, it is said to
contain a NULL value.
*/

/*
New Term: NULL
No value, as opposed to a field containing 0, or an empty string, or just
spaces.
*/

SELECT prod_name
FROM Products
WHERE prod_price IS NULL;

/*
This statement returns a list of all products that have no price (an empty
prod_price field, not a price of 0), and because there are none, no data is
returned. The Customers table, however, does contain columns with NULL values —the cust_email column will contain NULL if a customer has no email address onfile:
*/


/*
Remember 

SELECT cust_name
FROM Products
WHERE prod_price = NULL;

OR

SELECT cust_name
FROM Products
WHERE prod_price != NULL;

This sentence is incorrect, because when you compare a NULL value with any value (including itself) , the result is always UNKNOW.  NULL can't be compared with any values
*/

SELECT cust_name
FROM Customers
WHERE cust_email IS NULL;



/*
cust_name
----------
Kids Place
The Toy Store

*/

/*
Caution: NULL and Nonmatches

You might expect that when you filter to select all rows, but do not have a parrticular value, rows with a NULL will be returned. But they will not.
NULL is strange this way, and rows with NULL in the filter column are not returned when filtering for matches or when filtering for nonmatches.
*/
SELECT *
FROM Customers
WHERE cust_email <> 'sales@villagetoys.com';                                                                                                                                                                                                                                    ;