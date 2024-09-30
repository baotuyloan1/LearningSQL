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
products for several reasons:	- Because the vendor information is the same for each product that vendor
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