--================= Calculated Fields =================================

-- Understanding Calculated Fields----------
/*
Data stored within a database's tables is often not available in the the exact format needed by your applications. Here are some example:

- You need to display a field containing the name of a company along with the company’s location, but that information is stored in separate table
columns.

- City, state, and ZIP codes are stored in separate columns (as they should
be), but your mailing label printing program needs them retrieved as one
correctly formatted field.

- Column data is in mixed upper- and lowercase, and your report needs all
data presented in uppercase.

- An OrderItems table stores item price and quantity, but not the expanded
price (price multiplied by quantity) of each item. To print invoices, you
need that expanded price.

- You need total, averages, or other calculations based on table data
*/


/*
In each of these examples, the data stored in the table is not exactly what your
application needs. Rather than retrieve the data as it is and then reformat it withinyour client application or report, what you really want is to retrieve converted,
calculated, or reformatted data directly from the database.

This is where calculated fields come in. Unlike all the columns that we have
retrieved in the lessons thus far, calculated fields don’t actually exist in database
tables. Rather, a calculated field is created on-the-fly within a SQLSELECT
statement.
*/

/*
New Term: Field
Essentially means the same thing as column and often used interchangeably, 
although database columns are typically called columns and the term fields is
usually used in conjunction with calculated fields.

*/

/*
It is important to note that only the database knows which columns in a SELECT
statement are actual table columns and which are calculated fields. From the perspective of a client, a calculated field’s data isreturned in the same way as data from any other column.
*/

/*
Tip: Client Versus Server Formatting
Many of the conversions and reformatting that can be performed within SQL
statements can also be performed directly in your client application. However, as a rule, it is far quicker to perform these operations on the
database server than it is to perform them within the client.
*/

/*
Concatenating Fields
To demonstrate working with calculated fields, let’s start with a simple example —creating a title that is made up of two columns.

The Vendors table contains vendor name and address information. Imagine that
you are generating a vendor report and need to list the vendor location as part of
the vendor name, in the format name (location).

The report wants a single value, and the data in the table is stored in two
columns: vend_name and vend_country. In addition, you need to surround
vend_country with parentheses, and those are definitely not stored in the databasetable. The SELECT statement that returns the vendor names and locations is simple
enough, but how would you create this combined value?
*/


/*
New Term: Concatenate
Joining values together (by appending them to each other) to form a single
long value.
*/

/*
The solution is to concatenate the two columns. In SQLSELECT statements, you
can concatenate columns using a special operator. Depending on what DBMS youare using, this operator can be a plus sign (+) or two pipes (||). And in the case
of MySQLand MariaDB, a special function must be used as seen below.
*/

/*
Note: +or || ?
SQLServer uses + for concatenation. DB2, Oracle, PostgreSQL, and SQLite
support ||. Refer to your DBMS documentation for more details.
*/

SELECT vend_name + '(' + vend_country + ')'
FROM Vendors
ORDER BY vend_name

/*
-----------------------------------------------------------
Bear Emporium			(USA			)
Bears R Us				(USA			)
Doll House Inc.			(USA			)
Fun and Games			(England		)
Furball Inc.			(USA			)
Jouets et ours			(France			)
*/

-- same result
SELECT Concat(vend_name, '(', vend_country, ')')
FROM Vendors
ORDER BY vend_name;


/*
-----------------------------------------------------------
Bear Emporium			(USA			)
Bears R Us				(USA			)
Doll House Inc.			(USA			)
Fun and Games			(England		)
Furball Inc.			(USA			)
Jouets et ours			(France			)
*/

/*
Analysis
The above SELECT statements concatenate the following elements:
	- The name stored in the vend_name column
	- A string containing  an open parenthesis
	- The country stored in the vend_country column
	- A string containing the close parenthesis
*/

/*
As you can see in the output shown above, the SELECT statement returns a single
column (a calculated field) containing all these four elements as one unit

Look again at the output returned by the SELECT statement. The two columns that
are incorporated into the calculated field are padded with spaces. Many
databases (although not all) save text values padded to the column width, so your
own results may indeed not contain those extraneous spaces. To return the data
formatted properly, you must trim those padded spaces. This can be done using
the SQLRTRIM() function, as follows:
*/


SELECT RTRIM(vend_name) + ' (' + RTRIM(vend_country) + ')'
FROM [dbo].[Vendors]
ORDER BY vend_name;

/*
-----------------------------------------------------------
Bear Emporium (USA)
Bears R Us (USA)
Doll House Inc. (USA)
Fun and Games (England)
Furball Inc. (USA)
Jouets et ours (France)
*/

/*
The RTRIM() function trims all space from the right of a value. When you use
RTRIM(), the individual columns are all trimmed properly.
*/

/*
Note: The TRIM FunctionsMost DBMSs support RTRIM() (which, as just seen, trims the right side of a
string), as well as LTRIM(), which trims the left side of a string, and TRIM(), which trims both the right and left.
*/

-- ==================== Using Aliases ==============================--

/*
The SELECT statement used to concatenate the address field works well, as seen inthe above output. But what is the name of this new calculated column? Well, the
truth is, it has no name; it is simply a value. Although this can be fine if you are
just looking at the results in a SQLquery tool, an unnamed column cannot be used within a client application because there is no way for the client to refer to that
column.
*/

/*
To solve this problem, SQLsupports column aliases. An alias is just that, an
alternate name for a field or value. Aliases are assigned with the AS keyword. Take a look at the following SELECT statement:
*/

SELECT RTRIM(vend_name) + ' (' + RTRIM(vend_country) + ')' AS vend_title
FROM Vendors
ORDER BY vend_name;

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
The SELECT statement itself is the same as the one used in the previous code
snippet, except that here the calculated field is followed by the text AS
vend_title. This instructs SQL to create a calculated field named vend_title
containing the calculation specified. As you can see in the output, the results are
the same as before, but the column is now named vend_title, and any client
application can refer to this column by name, just as it would to any actual table
column.
*/

/*
Note: AS Often Optional
Use of the AS keyword is optional in many DBMSs, but using it is considered
a best practice.
*/

/*
Tip: Other Uses for Aliases
Aliases have other uses too. Some common uses include renaming a column if
the real table column name contains illegal characters (for example, spaces)
and expanding column names if the original names are either ambiguous or
easily misread.
*/

/*
Caution: Alias Names
Aliases may be single words or complete strings. If the latter is used, then the
string should be enclosed within quotes. This practice is legal but is strongly
discouraged. While multiword names are indeed highly readable, they create
all sorts of problems for many client applications—so much so that one of the most common 
uses of aliases is to rename multiword column names to single- word names (as explained above).
*/

-- ======================= Performing Mathematical Calculations ================================= --
/*
Another frequent use for calculated fields is performing mathematical
calculations on retrieved data. Let’s take a look at an example. The Orders table
contains all orders received, and the OrderItems table contains the individual
items within each order. The following SQLstatement retrieves all the items in
order number 20008:
*/

SELECT prod_id, quantity, item_price
FROM OrderItems
WHERE order_num = 20008;

/*
prod_id quantity item_price
---------- ----------- ---------------------
RGAN01 5 4.9900
BR03 5 11.9900
BNBG01 10 3.4900
BNBG02 10 3.4900
BNBG03 10 3.4900
*/

/*
The item_price column contains the per unit price for each item in an order. To
expand the item price (item price multiplied by quantity ordered), you simply do
the following:
*/

SELECT prod_id, quantity, item_price, quantity * item_price AS expanded_price
FROM OrderItems
WHERE order_num = 20008

/*
prod_id quantity item_price expanded_price
---------- ----------- ------------ -----------------
RGAN01 5 4.9900 24.9500
BR03 5 11.9900 59.9500
BNBG01 10 3.4900 34.9000
BNBG02 10 3.4900 34.9000
BNBG03 10 3.4900 34.9000
*/

/*
The expanded_price column shown in the output above is a calculated field; the
calculation is simply quantity*item_price. The client application can now use
this new calculated column just as it would any other column.
*/

/*
Operator Description
+ Addition
- Subtraction
* Multiplication
/ Division
*/


/*
Tip: How to Test CalculationsSELECT provides a great way to test and experiment with functions and
calculations. Although SELECT is usually used to retrieve data from a table, the
FROM clause may be omitted to simply access and work with expressions. For
example, SELECT 3 * 2; would return 6, SELECT Trim(' abc '); would
return abc, and SELECT Curdate(); uses the Curdate() function to return the
current date and time (on MySQLand MariaDB, for example). You get the
idea: use SELECT to experiment as needed
*/

/*
Challenges
1. A common use for aliases is to rename table column fields in retrieved
results (perhaps to match specific reporting or client needs). Write a SQL
statement that retrieves vend_id, vend_name, vend_address, and vend_city
from Vendors, renaming vend_name to vname, vend_city to vcity, and
vend_address to vaddress. Sort the results by vendor name (you can use the
original name or the renamed name).
*/

SELECT  vend_id , vend_name AS vname, vend_address AS vaddress, vend_city  AS vcity
FROM Vendors
ORDER BY vname

/*
2. Our example store is running a sale and all products are 10% off. Write a
SQLstatement that returns prod_id, prod_price, and sale_price from the
Products table. sale_price is a calculated field that contains, well, the sale
price. Here’s a hint: you can multiply by 0.9 to get 90% of the original value
(and thus the 10% off price).
*/

SELECT prod_id, prod_price, prod_price * (CAST(90 AS FLOAT)/100) AS sale_price
FROM [dbo].[Products]

SELECT prod_id, prod_price, prod_price * 0.9 AS sale_price
FROM Products