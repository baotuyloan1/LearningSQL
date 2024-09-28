-- percent sign (%) wildcard
-- underscore (_) wildcard


--===================== The Brackets ([]) Wildcard ========================

SELECT cust_contact
FROM Customers
WHERE  cust_contact LIKE '[JM]%'


/*
cust_contact
-----------------
Jim Jones
John Smith
Michelle Green
*/

/*
The where clause in this statement is '[JM]%'. This search pattern uses two different wildcards.
The [JM] matches any contact name that begin with either of the letters within the brackets, and it also matches only a single character.
Therefore, any names longer than on character will not match. The % wildcard
after the [JM] matches any number of characters after the first character, returning
the desired results.
*/

/*
This wildcard can be negated by prefixing the characters with ^ ( the caret character). 
For example,the following matches any contact name that does not begin with the letter J or the letter M
*/
SELECT cust_contact
FROM Customers
WHERE cust_contact LIKE '[^JM]%'

/*

Of course, you can accomplish the same result using the NOT operator. The only
advantage of ^ is that it can simplify the syntax if you are using multiple WHERE
clauses:
*/

SELECT cust_contact
FROM Customers
WHERE NOT cust_contact LIKE '[JM]%'

/*
Tips for Using WildCards
WildCard searches typically take far longer to process than any other search types.
Some rules to keep in mind when using wildcards:
- Don't overuse wildcards. If another search operator will do, use it instead.
- When you do use wildcards, try not to use them at the beginning of search pattern unless absolutely necessary. Search patterns that begin with wildcards are the slowest to process.
- Pay careful attention to the placement of the wildcard symbols. If they are misplaced, you might not return the data you indended

*/

/*
Challenges

1. Write a SQLstatement to retrieve the product name (prod_name) and
description (prod_desc) from the Products table, returning only products where the word toy is in the description.
*/

SELECT [prod_name], [prod_desc]
FROM [dbo].[Products]
WHERE [prod_desc] LIKE '%toy%'

/*
2. Now let’s flip things around. Write a SQLstatement to retrieve the product
name (prod_name) and description (prod_desc) from the Products table,
returning only products where the word toy doesn’t appear in the
description. And this time, sort the results by product name.
*/

SELECT [prod_name], [prod_desc]
FROM [dbo].[Products]
WHERE NOT [prod_desc] LIKE '%toy%'
ORDER BY [prod_name]

/*

3. Write a SQLstatement to retrieve the product name (prod_name) and
description (prod_desc) from the Products table, returning only products where both the words toy and carrots appear in the description. There are acouple of ways to do this, but for this challenge use AND and two LIKE
comparisons.

*/
SELECT [prod_name], [prod_desc]
FROM [dbo].[Products]
WHERE [prod_desc] LIKE '%toy%' AND [prod_desc] LIKE '%carrots%' 

/*
4. This next one is a little trickier. I didn’t show you this syntax specifically,
but see whether you can figure it out anyway based on what you have learned
thus far. Write a SQLstatement to retrieve the product name (prod_name) and description (prod_desc) from the Products table, returning only products where both the words toy and carrots appear in the description in that order
(the word toy before the word carrots). Here’s a hint: you’ll only need one
LIKE with three % symbols to do this.
*/
SELECT  [prod_name], [prod_desc]
FROM [dbo].[Products]
WHERE [prod_desc] LIKE '%toy%carrots%'



