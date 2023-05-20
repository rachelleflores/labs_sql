# Lab | Aggregation Revisited - Subqueries
USE sakila;

# Write the SQL queries to answer the following questions:
# Select the first name, last name, and email address of all the customers who have rented a movie.
SELECT DISTINCT
    r.customer_id, c.first_name, c.last_name, c.email
FROM
    rental r
        JOIN
    customer c USING (customer_id);

# What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
SELECT DISTINCT
    p.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ROUND(AVG(p.amount), 2) AS avg_payment
FROM
    payment p
        JOIN
    customer c USING (customer_id)
GROUP BY customer_id , customer_name;

# Select the name and email address of all the customers who have rented the "Action" movies: 
## Write the query using multiple join statements
SELECT DISTINCT
    cust.customer_id,
    CONCAT(cust.first_name, ' ', cust.last_name) AS customer_name,
    cust.email
FROM
    customer AS cust
        JOIN
    rental r USING (customer_id)
        JOIN
    inventory i USING (inventory_id)
        JOIN
    film_category fc USING (film_id)
        JOIN
    category AS cat USING (category_id)
WHERE
    cat.name = 'Action';


## Write the query using sub queries with multiple WHERE clause and IN condition
SELECT DISTINCT
    cust.customer_id,
    CONCAT(cust.first_name, ' ', cust.last_name) AS customer_name,
    cust.email
FROM
    customer AS cust
WHERE
    customer_id IN (
		SELECT 
            customer_id
        FROM
            inventory i
        WHERE
            film_id IN (
				SELECT 
                    film_id
                FROM
                    film_category
                WHERE
                    category_id = (
						SELECT 
                            category_id
                        FROM
                            category
                        WHERE
                            name = 'Action')))
;

## Verify if the above two queries produce the same results or not
-- Both do NOT produce the same results. The join method returned 510 rows while the WHERE, IN method returned 599 rows.


# Use the case statement to create a new column classifying existing columns as either low, medium or high value transactions based on the amount of payment. 
## If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
-- I'm not sure if we just need to create a column or do a pivot like the exercise in class...

### PIVOT
WITH pivot AS (
SELECT payment_id, ROUND(amount,2) AS amount
FROM payment
)
SELECT payment_id,
	   SUM(CASE WHEN amount BETWEEN 0 AND 2 THEN amount END) AS low,
	   SUM(CASE WHEN amount BETWEEN 2.1 AND 4 THEN amount END) AS medium,
	   SUM(CASE WHEN amount > 4 THEN amount END) AS high
FROM pivot
GROUP BY payment_id
ORDER BY payment_id;

### ADD NEW COLUMN
SELECT payment_id, ROUND(amount,2) as amount,
	   (CASE WHEN amount BETWEEN 0 AND 2 THEN 'low'
       WHEN amount BETWEEN 2.1 AND 4 THEN 'medium'
       WHEN amount > 4 THEN 'high' END) AS amount_class
FROM payment;
