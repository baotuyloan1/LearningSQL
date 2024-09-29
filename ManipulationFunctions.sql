-- ========================= Using Data Manipulation Functions ================================--

/*
Understanding Functions

Like almost any other computer language, SQLsupports the use of functions to manipulate data. Functions are operations that are usually performed on data,
usually to facilitate conversion and manipulation, and they are an important part
of your SQLtoolbox.

An example of a function is RTRIM(), which we used in the last lesson to trim
spaces from the end of a string.

*/

/*
The Problem with Functions
Before you work through this lesson and try the examples, you should be aware
that, unfortunately, using SQLfunctions can be highly problematic.

Unlike SQLstatements (for example, SELECT), which for the most part are
supported by all DBMSs equally, functions tend to be very DBMS specific. In
fact, very few functions are supported identically by all major DBMSs. Although
all types of functionality are usually available in each DBMS, the function names
or syntax can differ greatly.

This means that code you write for a specific SQLimplementation might not work on
another implementation.

*/

/*
With code portability in mid, some SQL programmers opt not to use implementation-specific features. Although this is a somewhat noble and
idealistic view, it is not always in the best interests of application performance. If
you opt not to use these functions, you make your application code work harder,
as it must use other methods to do what the DBMS could have done more efficiently.

*/

/*
Tip: Should You Use Functions?
So now you are trying to decide whether you should or shouldn’t use
functions. Well, that decision is yours, and there is no right or wrong choice.
If you do decide to use functions, make sure you comment your code well so
that at a later date you (or another developer) will know exactly what SQL
implementation you were writing to.
*/

/*
Using Functions.
Most SQL implementations support the following types of functions:

- Text functions are used to manipulate strings of text (for example, trimming
or padding values and converting values to upper- and lowercase).

- Numeric functions are used to perform mathematical operations on numeric
data (for example, returning absolute numbers and performing algebraic
calculations).

- Date and time functions are used to manipulate date and time values and to
extract specific components from these values (for example, returning
differences between dates and checking date validity

- Formatting functions are used to generate user-friendly outputs (for
example, displaying dates in local languages and formats, or currencies with the right symbols and comma placement).

- System functions return information specific to the DBMS being used (for
example, returning user login information).
*/

/*
, you saw a function used as part of a column list in a SELECT
statement, but that’s not all functions can do. You can use functions in other parts
of the SELECT statement (for instance, in the WHERE clause)
*/

-- ====================== Text Manipulation Functions ============================= --

-- UPPER Function
SELECT vend_name, UPPER(vend_name) AS vend_name_upcase
FROM Vendors
ORDER BY vend_name;

/*
vend_name vend_name_upcase
--------------------------- ----------------------------
Bear Emporium BEAR EMPORIUM
Bears R Us BEARS R US
Doll House Inc. DOLL HOUSE INC.
Fun and Games FUN AND GAMES
Furball Inc. FURBALL INC.
Jouets et ours JOUETS ET OURS
*/
/*
As you can see, UPPER() converts text to uppercase, and so in this example each
vendor is listed twice—first exactly as stored in the Vendors table, and then
converted to uppercase as column vend_name_upcase.

*/
/*
Tip: UPPERCASE, lowercase, MixedCase
As should be clear by now, SQLfunctions are not case sensitive, so you can
use upper(), UPPER(), Upper(), or substr(), SUBSTR(), SubStr(), and so on. Case is a user preference, so do as you choose, but be consistent and don’t
keep changing styles in your code; it makes the SQLreally hard to read.
*/

/*
Commonly Used Text Manipulation functions

LEFT()(or use substring function)				Returns characters from left of string
LENGTH() (also DATALENGTH() or LEN())			Returns the length of a string
LOWER()											Converts string to lowercase
LTRIM()											Trims white space from left of string
RIGHT() (or use substring function)				Returns characters from right of string
RTRIM()											Trims white space from right of string
SUBSTR() or SUBSTRING()							Extracts part of a string
SOUNDEX()										Returns a string’s SOUNDEX value
UPPER()											Converts string to uppercase
*/

/*
The SOUNDEX algorithm is used to match words based on their pronunciation, rather than their exact spelling. 
This is useful in scenarios where variations in spelling or typographical errors might occur, but the sound of the word remains similar.*/

SELECT RIGHT('SQL Tutorial', 3) AS ExtractString;


/*
Here’s an example using the SOUNDEX() function. Customer Kids Place is in the
Customers table and has a contact named Michelle Green. But what if that were a
typo, and the contact actually was supposed to have been Michael Green?
Obviously, searching by the correct contact name would return no data, as shown
here:
*/​


SELECT cust_name, cust_contact
FROM Customers
WHERE cust_contact = 'Michael Green';

/*
cust_name cust_contact
-------------------------- ----------------------------
*/

/*
Now try the same search using the SOUNDEX() function to match all contact names
that sound similar to Michael Green:
*/

SELECT cust_name, cust_contact
FROM Customers
WHERE SOUNDEX(cust_contact) = SOUNDEX('Michael Green')

/*
cust_name cust_contact
-------------------------- ----------------------------
Kids Place Michelle Green
*/

/*
In this example, the WHERE clause uses the SOUNDEX() function to convert both the
cust_contact column value and the search string to their SOUNDEX values. Because
Michael Green and Michelle Green sound alike, their SOUNDEX values match, and
so the WHERE clause correctly filtered the desired data.
*/

-- ============================= Date and Time Manipulation Functions =======================-------
/*
Date and times are stored in tables using datatypes, and each DBMS uses its own
special varieties. Date and time values are stored in special formats so that they may be sorted or filtered quickly and efficiently, as well as to save physical
storage space.
The internal format used to store dates and times is usually of no use to your
applications, and so date and time functions are almost always used to read,
expand, and manipulate these values. Because of this, date and time manipulation
functions are some of the most important functions in the SQLlanguage. Unfortunately, they also tend to be the most inconsistent and least portable.
To demonstrate the use of a date manipulation function, here is a simple example. The Orders table contains all orders along with an order date. To retrieve all of
the orders placed in a specific year, you’d need to filter by order date, but not the
entire date value, just the year portion of it. This obviously necessitates extractingthe year from the complete date.

To retrieve a list of all orders made in 2020 in SQLServer, do the following
*/

SELECT order_num
FROM Orders
WHERE DATEPART (yy, order_date) = 2020;

/*
order_num
-----------
20005
20006
20007
20008
20009
*/

-- ======================== Numeric Manipulation Functions =============================== --
/*
Numeric manipulation functions do just that—manipulate numeric data. These
functions tend to be used primarily for algebraic, trigonometric, or geometric
calculations and, therefore, are not as frequently used as string or date and time manipulation functions.

The ironic thing is that of all the functions found in the major DBMSs, the numericfunctions are the ones that are most uniform and consistent.
the more commonly used numeric manipulation functions.
*/

/*
ABS()			Returns a number’s absolute valueCOS()			Returns the trigonometric cosine of a specified angle...

Refer to your DBMS documentation for a list of the supported mathematical manipulation functions.
*/

/*
Challenges

Our store is now online, and customer accounts are being created. All users
need a login, and the default login will be a combination of their name and
city. Write a SQLstatement that returns customer ID (cust_id), customer
name (customer_name), and user_login, which is all uppercase and
composed of the first two characters of the customer contact (cust_contact)
and the first three characters of the customer city (cust_city). So, for
example, my login (Ben Forta living in Oak Park) would be BEOAK. Hint: for
this one you’ll use functions, concatenation, and an alias.
*/
SELECT cust_id, cust_name, UPPER(LEFT(cust_contact, 2) + LEFT(cust_city,3)) AS user_login
FROM [dbo].[Customers]


/*
Write a SQLstatement to return the order number (order_num) and order date(order_date) for all orders placed in January 2020, sorted by order date. You should be able to figure this out based on what you have learned thus
far, but feel free to consult your DBMS documentation as needed.
*/

SELECT order_num, order_date
FROM Orders
WHERE DATEPART(mm,order_date) = 1 AND  DATEPART(yy, order_date) = 2020
ORDER BY order_date

