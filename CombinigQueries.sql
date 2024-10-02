-- ============== Combining Queries ======== --

-- ==== Understanding Combined Queries === --
/*
Most SQL queries contain a single SELECT statement that returns data from one or 
more tables. SQL also enables you to perform multiple queries (multiple SELECT 
statements) and return the results as a single query result set. These combined
queries are usually known as unions or compound queries.

There are basically two scanarios in which you'd use combined queries:
	- To return similarly structured data from different tables in a single query.
	- To perform multiple queries against a single table returning the data as one query.
*/

/*
Tip: Combining Queries and Multiple WHERE conditions

For the most part, combining two queries to the same table accomplishes the same thing as a single query
with multiple WHERE clause condions. In other words, any SELECT statement with multiple WHERE clauses can 
also be specified as a combined query.
*/

/*
Creating Combined Queries
SQL queries are combined using the UNION operator. Using UNION, you can specifu multiple SELECT statements,
and their results can be combined into a single result set.
*/

-- == Using UNION == --
/*
Using UNION is simple enough. All you do is specify each SELECT statement 
and place the keyword UNION between each.

Example: You need a report on all your customers in Illinois, 
Indiana, and Michiga. You also want to include all Fun4All locations, 
regarless of state. Of course, you can create a WHERE clase that will do this, but this time
use a UNION instead.

Creating a UNION involves writing multiple SELECT statements.
*/

SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL','IN','MI');

/*
cust_name		cust_contact		cust_email
-----------		-------------		------------
Village Toys	John Smith			sales@villagetoys.com
Fun4All			Jim Jones			jjones@fun4all.com
The Toy Store	Kim Howard			NULL
*/

SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All';

/*
cust_name		cust_contact		cust_email
------------	-----------			-------------
Fun4All			Jim Jones			jjones@fun4all.com
Fun4All			Denise L. Stephens	dstephens@fun4all.com
*/

/*
The first SELECT retrieves all rows in Illinois, Indiana, and Michigan by passing
those state abbreviations to IN clause. The second SELECT uses a simple equality 
test to find all Fun4All locations. You'll notice that one row appears on both outputs
as it meets both WHERE conditions.
To combine these two statements, do the following:
*/

SELECT cust_name as custName1, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL','IN','MI')
UNION
SELECT cust_name AS custName2 , cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All1'
UNION
SELECT cust_name AS custName3 , cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All'
ORDER BY custName1 DESC;


/*
cust_name		cust_contact		cust_email
-----------		-----------			----------------
Fun4All			Denise L. Stephens	dstephens@fun4all.com
Fun4All			Jim Jones			jjones@fun4all.com
Village Toys	John Smith			sales@villagetoys.com
The Toy Store	Kim Howard			NULL
*/

/*
The preceding statements are made up of both of the previous SELECT statements separated by the
UNION keyword. UNION instructs the DBMS to execute both SELECT statements and combine the output
into a single query result set.

As a point of reference, the same query using multiple WHERE clases instead of a UNION:
*/

SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL','IN','MI') 
	OR cust_name = 'Fun4All';

/*
In our simple example, the UNION might actually be more complicated than using a WHERE clause.
But with more complex filtering conditions, or if the data is being retrieved from multiple tables
(and not just a single table), the UNION could have made the process much simpler indeed.
*/

/*
Tip: UNION Limits
There is no standard SQL limit to the number of SELECT statements that can be combined with
UNION statements. However, it is best to consult your DBMS documentation to ensure that it does not enforce
any maximum statement restrictions of its own.
*/

/*
Caution: Performance Issues
Most good DBMSs use an internal query optimizer to combine the SELECT statements before they are even processed.
In theory, this means that from a performance perspective, there should be not real difference between using
multiple WHERE clause conditions or a UNION. I say in "theory", because, in practice, most query optimizers
don't always do as good a job as they should. Your best bet is to test both methods to see which will work best
for you
*/

-- == UNION Rules === --- 
/*
As you can see, unions are very easy to use. But there are a few rules governing exactly which can be combined:
	- A UNION must be composed of two or more SELECT statements, each 
	separated by the keyword UNION(so, if you're combining four SELECT statements, you would use three UNION keywords)
	- Each query in a UNION must contain the same columns, expression, or aggregate function (and some DBMSs even require that columns 
	be listed in the same order).
	- Column datatypes must be compatible. They need not be the same name or the exact same type, but
	they must be of a type that the DBMS can implicitly convert (for example, different numeric types of different data types)
*/

/*
Note: UNION Column Names
If SELECT statements that are combined with a UNION have diferent column names, what name is actually returned? 
For example, if one statement contained SELECT produc_name and the next used SELECT productname, what would be the the name 
of the combined returned column?

The answer is that the first name is used, so in our example the combined column would be named prod_name, even though the second 
SELECT used a different name. This is also means that you can use an alias on the first name to set the returned column name as needed.

This behavior has another interesting side effect. Because the first set of 
column names are used, only those names can be specified when shorting.
Again, in our example, you could use ORDER BY prod_name to sort the
combined results, but ORDER BY productname would display an error message because
there is no column productname in the combined results.
*/

/*
Aside from these basic rules and restrictions, unions can be used for any data retrieval tasks.
*/

-- ===================== Including or Eliminating Duplicate Rows =================== --
/*
Go back to the preceding section titled "Using UNION" and look at the sample
SELECT statements used. You'll notice that when executed individually, the first SELECT
statement returns three rows, and the second SELECT statement returns two rows. 
However, when the two SELECT statements are combined with a UNION, only four rows are returned, not five.

The UNION automatically removes any duplicate rows from the query result set (in other words, it behaves just as
multiple WHERE clase conditions in a single SELECT would). Because there is a Fun4All location in Indian, that row
was returned by both SELECT statements. WHhen the UNION was used, the duplicate row was eliminated.

This is the default behavior of UNION, but you can change it if you so desire. If you
would, in fact,want all occurences of all matches returned, you could use UNION ALL instead of UNION.
*/

SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL','IN','MI')
UNION ALL
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All';

/*
cust_name			cust_contact		cust_email
-----------			-------------		------------
Village Toys		John Smith s		ales@villagetoys.com
Fun4All				Jim Jones			jjones@fun4all.com
The Toy Store		Kim Howard			NULL
Fun4All				Jim Jones			jjones@fun4all.com
Fun4All				Denise L. Stephens	dstephens@fun4all.com
*/

/*
When you use UNION ALL, the DBMS does not eliminate duplicates. Therefore, the preceding example
returns five rows, one of them occurring twice.
*/

/*
Tip: UNION versus WHERE

UNION almost always accomplishes the same thing as multiple WHERE conditions.
UNION ALL is the form of UNION that accomplishes what cannot be done with WHERE clauses.
If you do, in fact, wall all occurrences of matches for every condition (including duplicates), you must use UNION ALL and no WHERE.
*/

-- =========== Sorting COmbined Query Results ============= --
/*
SELECT statement output is sorted using the ORDER BY clause. When combining 
queries with a UNION, you may use only one ORDER BY clause, and it must occur after the final SELECT statement.
There is very little point in sorting part of a result set one way and part another way, and so multiple ORDER BY 
clauses are not allowed.

The following example sorts the results returned by the previously used UNION:
*/

SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL','IN','MI')
UNION
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All'
ORDER BY cust_name, cust_contact;

/*
cust_name			cust_contact		cust_email
-----------			-------------		-------------
Fun4All				Denise L. Stephens	dstephens@fun4all.com
Fun4All				Jim Jones			jjones@fun4all.com
The Toy Store		Kim Howard			NULL
Village Toys		John Smith s		ales@villagetoys.com
*/

/*
This UNION takes a single ORDER BY clause after the final SELECT statement. Even 
though the ORDER BY appears to be a part of only that last SELECT statement, the
DBMS will in fact use it to sort all the results returned by all the SELECT statements.
*/

/*
Note: Other UNION Types
Some DBMSs support two additional types of UNION. EXCCEPT(sometimes called MINUS) can be used to retrieve only
the rows that exist in the first table but not in the second, and INTERSECT can be used to retrieve only the rows
that exist in both tables. In practice, however, these UNION types are rarely used because the same results can
be accomplished using joins.
*/

/*
Tip: Working with Multiple Tables
For simplicity's sake, the previous examples have all used UNION to combine multiple queries
on the same table. In practice, UNION is really useful, when you need to combine data from multiple tables,
even tables with mismatched column names, in which case you can combine UNION with aliases to retrieve a
single set of results
*/

/*
Challenges

1. Write a SQLstatement that combines two SELECT statements that retrieve
product ID (prod_id) and quantity from the OrderItems table, one filtering
for rows with a quantity of exactly 100, and the other filtering for products with an ID that begins with BNBG. Sort the results by product ID.
*/
SELECT prod_id, quantity
FROM OrderItems
WHERE quantity = 100
UNION 
SELECT prod_id, quantity
FROM OrderItems
WHERE prod_id LIKE 'BNBG%'
ORDER BY prod_id;

/*
2. Rewrite the SQLstatement you just created to use a single SELECT statement.
*/
SELECT prod_id, quantity
FROM OrderItems
WHERE quantity = 100 OR prod_id LIKE 'BNBG%'
ORDER BY prod_id;
/*

3. This one is a little nonsensical, I know, but it does reinforce a note earlier inthis lesson. Write a SQLstatement which returns and combines product name(prod_name) from Products and customer name (cust_name) from Customers,
and sort the result by product name.
*/
SELECT prod_name
FROM Products
UNION
SELECT cust_name
FROM Customers
ORDER BY prod_name
/*
4. What is wrong with the following SQLstatement? (Try to figure it out without running it.)

SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state = 'MI'
ORDER BY cust_name; // issue here
UNION
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state = 'IL'ORDER BY cust_name;

*/