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
Most SQL implementations support the following types of functions:- Text functions are used to manipulate strings of text (for example, trimming
or padding values and converting values to upper- and lowercase).- Numeric functions are used to perform mathematical operations on numeric
data (for example, returning absolute numbers and performing algebraic
calculations).- Date and time functions are used to manipulate date and time values and to
extract specific components from these values (for example, returning
differences between dates and checking date validity- Formatting functions are used to generate user-friendly outputs (for
example, displaying dates in local languages and formats, or currencies with the right symbols and comma placement).- System functions return information specific to the DBMS being used (for
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
Tip: UPPERCASE, lowercase, MixedCaseAs should be clear by now, SQLfunctions are not case sensitive, so you can
use upper(), UPPER(), Upper(), or substr(), SUBSTR(), SubStr(), and so on. Case is a user preference, so do as you choose, but be consistent and don’t
keep changing styles in your code; it makes the SQLreally hard to read.
*/

