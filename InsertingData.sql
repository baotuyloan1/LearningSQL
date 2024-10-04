-- ================= Inserting Data ===================== --
-- ========= Understanding Data Insertion ============ --
/*
SELECT is undoubtedly the most frequently used SQL statement.
But there are three other frequently used SQL statements.
THe first on is INSERT

As its name suggests, INSERT is used to insert(add) rows to a database table.
Insert can be used in several ways:
	- Inserting a single complete row.
	- Inserting a single partial row.
	- Inserting the results of a query
*/

/*
Tip: INSERT and System Security
Use of the INSERT statment might require special security privileges in client/sever DBMSs.
Before you attempt to use INSERT, make sure you have adequate security privileges to do so.
*/

-- ========= Inserting Complete Rows ============= --
/*
The simplest way to insert data into a table is to use the basic INSERT syntax,
which requires that you specify the table name and the values to be inserted into the new row.
Example:
*/

INSERT INTO Customers
VALUES(1000000006,
'Toy Land',
'123 Any Street',
'New York',
'NY',
'11111',
'USA',
NULL,
NULL);


/*
The above example inserts a new customer into the Customers table. The data to 
be stored in each table column is specified in the VALUES clause, and a value must
be provided for every column. If a column has no value(for example, the 
cust_contact and cust_email columns above), the NULL value should be used 
(assuming the tables allows no value to be specified for that column). The columns
must be populated in the order in which they appearin the table definition.
*/

/*
Tip: The INTO Keyword
In some SQL implementations, the INTO keyword following INSERT is
optional. However, it is good pratice to provide this keyword even if it is 
not needed. Doing so will ensure that your SQL code is portable between DBMSs.
*/

/*
Although this syntax is indeed simple, it is not at all safe and should generally be
avoided at all costs. The above SQL statement is highly dependent on the order in 
which the columns are defined in the table. It also depends on information about
that order being readily available. Even if it is available, there is no guarantee
that the columns will be in the exact same order the next time table is reconstructed.
Therefore, wiring SQL statements that depend on specific column ordering is very unsafe.
If you do so, something will inevitably break at some point.
The safer (and unfortunately more cumbersome) way to write the INSERT statement is as follows:
*/

INSERT INTO Customers(cust_id,
						cust_name,
						cust_address,
						cust_city,
						cust_state,
						cust_zip,
						cust_country,
						cust_contact,
						cust_email)
VALUES(1000000006,
		'Toy Land',
		'123 Any Street',
		'New York',
		'NY',
		'11111',
		'USA',
		NULL,
		NULL);

/*
This example does the exact same thing as the previous INSERT statement, but this
time the column names are explicitly stated in parentheses after table name.
When the row is inserted, the DBMS will match each item in the columns list
with the appropriate value in the VALUES list. The first entry in VALUES
corresponds to the first specified column name. The second value corresponds to
the second column name, and so on.

Because column names are provided, the VALUES must match the specified column names in the order
in which they are specified, and not necessarily in the order that the columns appear in the actual table.
The advantage of this is that, even if the table layout changes, the INSERT statement will still work correctly.
*/

/*
Note: Can't INSERT same record twice

If you tried both versions of this example, you'll have discovered that the 
second generated an error because a customer with an ID of 1000000006 
already existed. Primary key values must be unique, and because cust_id is the primary key,
the DBMS won't allow you to insert two rows with the same cust_id value. The same
is true for the next example. To try the other INSERT statements, you'd need to delete the first row added.
*/

/*
The folowing INSERT statement populates all the row columns (just as before),
but it does so in a different order. Because the column names are specified, the
insertion will work correctly.
*/

INSERT INTO Customers(cust_id,
						cust_contact,
						cust_email,
						cust_name,
						cust_address,
						cust_city,
						cust_state,
						cust_zip)
VALUES(1000000006,
	NULL,
	NULL,
	'Toy Land',
	'123 Any Street',
	'New York',
	'NY',
	'11111');

/*
Tip: Always use a Columns list

As a rule, never use INSERT without explicitly specifying the column lust. This
will greatly increase the probability that your SQL will continue to function in
the event that table changes occur.
*/

/*
Cation: Use VALUES carefully

Regardless of the INSERT syntax being used, the correct number of VALUES
must be specified. If no column name are provided, a value must be present
for every table column. If column names are provided, a value must be present for each listed column.
if none is present, an error message will be generated, and the row will not be inserted.
*/
-- ============ Inserting Partial Rows ============== --

/*
The recommended way to use INSERT is to explicitly specify table column names.
Using this syntax, you can also omit columns. This means you provide values for
only some columns, but not for others.
*/

INSERT INTO Customers(
				cust_id, 
				cust_name,
				cust_address,
				cust_city,
				cust_state,
				cust_zip,
				cust_country)
VALUES (1000000006,
		'Toy Land',
		'123 Any Street',
		'New York',
		'NY',
		'11111',
		'USA');

/*
In the examples given earlier in this lesson, values were not provided for two of
the columns, cust_contact and cust_email. This means there is no reason to
include those columns in the INSERT statrement. This INSERT statement, therefore,
omits the two columns and the two corresponding values.
*/

/*
Caution: Omitting Columns

You may omit columns from an INSERT operation if the table definition so
allows. One of the following conditions must exit:
	- The column is defined as allowing NULL values (no value at all)
	- A default value is specified in the table definition. This means the
	default value will be used if no value is specified.
*/

/*
Caution: Omitting Required Values

If you omit a value from a table that does not allow NULL values and does not have a default, 
the DBMS will generate an error message, and the row will not be inserted.
*/

-- ============ Inserting Retrieved Data ==================

/*
INSERT is usally used to add a row to a table using specified values. There is
another form of INSERT that can be used to insert the result of a SELECT statement
into a table. This is known as INSERT SELECT, and, as its name suggests, it is made
up of an INSERT statement and a SELECT statement.

Suppose you want to merge a list of customers from another table into your
Customers table. Instead of reading one row at a time and inserting it with INSERT,
you can do the following:
*/

INSERT INTO Customers(cust_id,
						cust_contact,
						cust_email,
						cust_name,
						cust_address,
						cust_city,
						cust_state,
						cust_zip,
						cust_country)
SELECT cust_id,
						cust_contact,
						cust_email,
						cust_name,
						cust_address,
						cust_city,
						cust_state,
						cust_zip,
						cust_country
FROM CustNew;


/*
This example uses INSERT SELECT to import all the data from CustNew into
Customers. Instead of listing the values to be inserted, the SELECT statement
retrieves them from CustNew. Each column in the SELECT corresponds to a column
in the specified columns list. How many rows will this statement insert? That
depends on how many rows are in the CustNew table. If the table is empty, no
rows will be inserted( and no error will be generated because the operation is
sill valid). If the table does, in fact, contain data, all that data will be inserted
into Customers.
*/

/*
Tip: Column Names in INSERT SELECT

This example uses the same column names in both the INSERT and SELECT 
statements for simplicity's sake. But there is no requirement that the
column names match. In fact, the DBMS does not even pay attention to the column
names returned by the SELECT. Rather, the column position is used, so the first
column in the SELECT statements (regardless of its name) will be used to 
populate the first specified table column, and so on.
*/

/*
The SELECT statement used in a INSERT SELECT can include a WHERE clause to
filter the data to be inserted.
*/


/*
Tip: Inserting Multiple Rows
INSERT usaully inserts only a single row. To insert multiple rows, you must 
execute multiple INSERT statements. The exception to this rule is INSERT
SELECT, which can be used to insert multiple rows with a single statement;
whatever the SELECT statement returns will be inserted by the INSERT.
*/


-- ================= Copying from one table to another ======================== --
/*
There is another form of data insertion that does not use the INSERT statement at 
all. To copy contents of a table into a brand new table (one that is created on the fly),
you can use the CREATE SELECT statement ( or SELECT INTO if using SQL server).
*/

/*
Note: Not Supported By DB2

DB2 does not support the use of CREATE SELECT as described here .
*/

/*
Unlike INSERT SELECT, which appends data to an existing table, CREATE SELECT (SELECT INTO)
copies data into a new table (and depending on the DBMS being used, can overwrite the table
if it already exists).
*/

SELECT * INTO CustCopy FROM Customers;


/*
This SELECT statement creates a new table named CustCopy and copies the entire
contents of the CUstomers table into it. Because SELECT *  was used, every column
in the Customers table will be created ( and populated) in the CustCopy table. To
copy only a subset of the available columns, you can specify explicit column names
instead of the * wildcard character.

Here are some things to consider when using SELECT INTO:
	- Any SELECT options and clauses may be used, incluing WHERE and GROUP BY.
	- Joins may be used to insert data from multiple tables
	- Data may only be inserted into a single table regardless of how many tables
	the data was trieved from.
*/

/*
Tip: Making Copies of Tables

The technique described here is a greate way to make copies of tables before
experimenting with new SQL statements. By making a copy first, you'll be 
able to test your SQL on that copy instead of on live data.
*/

/*
Challenges

1. Using INSERT and columns specified, add your self to the Customers table.
Explicitly list the columns you are adding and only the ones you need.
*/

INSERT INTO Customers(cust_id,
						cust_name,
						cust_address,
						cust_city,
						cust_state,
						cust_zip,
						cust_country,
						cust_contact,
						cust_email)
VALUES (1000000007,
		'Self-Study', 
		'Hoa Vang Hoa Phong',
		'Da Nang', 
		NULL,
		550000, 
		'VN', 
		'Bao Nguyen', 
		'nguyendubaokey@gmail.com')


/*
2. Make backup copies of your Orders and OrderItems tables 
*/

SELECT * 
INTO Backup_Orders
FROM Orders

SELECT *
INTO Backup_OrderItems
FROM OrderItems