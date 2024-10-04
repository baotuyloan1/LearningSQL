-- ============== Upading and Deleting Data =============== --

-- =============== Updating ======================== --
/*
To update (modify) data in a table, you use the UPDATE statement. UPDATE can be
used in two ways:
	- To update specific rows in a table.
	- To update all rows in a table
*/

/*
Caution: Don't Omit the WHERE clause

Special care must be exercised when using UPDATE because it is all too easy
to mistakenly update every row in your table. PLease read this entire section
on UPDATE before using this statement
*/

/*
Tip: UPDATE and Security

Use of the UPDATE statement might require special security privileges in
client/server DBMSs. Before you attemp to use UPDATE, make sure you have 
adequate security privileges to do so.
*/

/*
The UPDATE statement is very easy to use-some would say too easy. The basic
format of an UPDATE statement is made up of three parts:
	- The table to be updated.
	- The column names and their values.
	- THe filter condition that determines which rows should be updated.

Let's take a look at a simple example. Customer 1000000005 has no email adress
on file and now has an address, so that record needs updating. The following
statement performs this update.
*/

UPDATE Customers
SET cust_email = 'kim@thetoystore.com'
WHERE cust_id = 1000000005;

/*
The UPDATE statement always begins with the name of the table being updated. In
this example, it is the Customers table. The SET command is then used to assign
the new value to a column. As used here, the SET clause sets the cust_email
column to the specified value.

SET cust_email = 'kim@thetoystore.com'

*/

/*
The UPDATE statement finishes with a WHERE clause that tells the DBMS which row
to update. Without a WHERE clause, the DBMS wouold update all rows in the 
Customers table with this new email address-definitely not the desired outcome.

Updating multiple columns requires a slightly different syntax:
*/

UPDATE Customers
SET	cust_contact = 'Same Roberts',
	cust_email = 'sam@toyland.com'
WHERE cust_id = 1000000006;

/*
When you are updating multiple columns, you use only a single SET command, and
each column = value pair is separated by a comma.( No comma is specified after
the last column). In this example, columns cust_contact and cust_email will 
both be updated for customer 1000000006;
*/

/*
Tip: Using Subqueries in an UPDATE statement

Subqueries may be used in UPDATE statements, enabling you to update columns
with data retrived with a SELECT statement
*/

/*
Tip: the FROM keyword

Some SQL implementations support a FORM clause in the UPDATE statement that
can be used to update the rows in one table with data from another table.
Refer to your DBMS documentation to see if it supports this feature.
*/

/*
To delete a column's value, you can set it to NULL (assuming the table is defined to
allo NULL values). You can do this as follows:
*/

UPDATE Customers
SET cust_email = NULL
WHERE cust_id = 1000000005;


/*
Here the NULL keyword is used to save no value to the cust_email columns. That is
very different from saving an empty string. An empty string(specified as '') is a
value, whereas NULL means that there is no value at all.
*/

-- ================== Deleting Data ====================== --

/*
To delete(remove) data form a table, you use the DELETE statement. DELETE can be
used in two ways:
	- To delete specific row from a table
	- To delete all rows from a table
*/

/*
Caution: Don't Omit the WHERE clause

Special care must be exercised when using DELETE because it is all to easy 
to mistakenly delete every row from your table. Please read this entire 
section on DELETE before using this statement.
*/

/*
Tip: DELETE and Security

Use of the DELETE statement might require special security privileges in
client/server DBMSs. Before you attempt to use DELETE, make sure you have
adequate security privileges to do so.
*/

/*
The following statement deletes a single row from Customers table
*/

DELETE FROM Customers
WHERE cust_id = 1000000006;

/*
This statement should be self-explanatory. DELETE FROM requires that you specify
the name of the table from which that data is to be deleted. The WHERE clause filters
which rows are to be deleted. In this example, only customer 1000000006 will be deleted.
If the WHERE clause were omitted, this statement would have deleted every customer in the table.
*/

/*
Tip: Foreign Keys are your Friend

To join two tables, you simply need common fields in both of those tables.
But you can also have the DBMS enforce the relationship by using foreign keys.
When foreign keys are present, the DBMS uses them to enforce referential 
integrity. For example, if you tried to insert a new product into the Products
table, the DBMS would not allow you to insert it with an unknow vendor ID
because the vend_id column is connected to the Vendors table as a foreign key.
So what does this have to do with DELETE? Well, a nice side effect of using 
foregin keys to ensure referential integrity is that the DBMS usally prevents
the deletion of rows that are needed for a relationship. For example, if you tried
to delete a product from Products that was used in existing orders in OrderItems,
that DELETE statement would throw an error and would be aborted. That's another reason
to always define your foreign keys.
*/

/*
Tip: The FROM keyword

In some SQL implementations, the FORM keyword following DELETE is optional.
However, it is good practice to always provide this keyword, even it it is
not needed. Doging this will ensure that your SQL code is portable between DBMSs.
*/

/*
DELETE takes no column names or wildcard characters. DELETE deletes entri rows, not columns.
To delete specific columns, you use an UPDATE statement.
*/

/*
Note: Table Contents, Not tables
The DELETE statement deletes rows from tables, even all rows from tables.
But DELETE never deletes the table itself.
*/

/*
Tip: Faster deletes

If you really do want to delete all rows from a table, don't  use DELETE.
Instead, use the TRUNCATE TABLE statement, which accomplishes the same
thing but does it much quicker (because data changes are not logged)
*/

-- ================ Guidelines for Updating and Deleting Data===================

/*
The UPDATE and DELETE statements used in the previous section all have WHERE
clauses, and there is a very good reason for this. If you omit the WHERE clause, the
UPDATE or DELETE will be applied to every row in the table. In other words, if you 
execute an UPDATE without a WHERE clause, every row in the table will be updated
with the new values. Similarly, if you execute DELETE without a WHERE clause, all
the contents of the table will be deleted.
*/

/*
Here are some important guidelines that many SQL programmers follow:
	- Never execute an UPDATE or a DELETE without a WHERE clause unless you
	readlly do intent to update and delete every row.
	- Make sure every table has a primary key, and use it as the WHERE clause whenever possible.
	- Before you use a WHERE clause with an UPDATE or a DELETE, first test it with a 
	SELECT to make sure it is filtering the right records; it is far too easy to 
	write incorrect WHERE clausese.
	- Use database-enforced referential integrity so that the DBMS will not allow the deletion
	of rows that have data in other tables related to them.
	- Some DBMSs allow database administrators to impose restrictions that
	prevent the execution for UPDATE or DELETE without a WHERE clause. If your
	DBMS supports this feature, consider using it.

The bottom line is that SQL has no Undo button. Be very careful using UPDATE and DELETE,
or you'll find yourself updating and deleting the wrong data.
*/


-- ============ Challenges ================= 
/*
1. USA state abbreviations should always be in uppercase. Write a SQL
statement to update all USA addresses, both vendor states( vend_state in 
Vendors) and customer states (cust_state in Customers), so that they are uppercase.
*/
UPDATE Vendors
SET vend_state = UPPER(vend_state)
WHERE vend_country = 'usa'


UPDATE Customers
SET cust_state = UPPER(cust_state)
WHERE cust_country  = 'usa'

/*
Delete yourself ( you added yourself to the Customers table). Make sure to use
a WHERE clause

*/

SELECT *
FROM [dbo].[Customers]
WHERE [cust_id] = 1000000007;

DELETE FROM Customers
WHERE cust_id = 1000000007;