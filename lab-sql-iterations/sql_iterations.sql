# Lab | SQL Iterations
USE sakila;

# 1. Write a query to find what is the total business done by each store.
-- join tables
-- STAFF: store_id corresponding the staff
-- RENTAL : rental counts per staff_id
-- PAYMENT : total revenue (amount)

SELECT s.store_id AS store, COUNT(r.rental_id) AS total_films_rented, ROUND(SUM(p.amount),2) AS total_revenue
FROM staff s
JOIN rental r
USING (staff_id)
JOIN payment p
USING (rental_id)
GROUP BY s.store_id;

# 2. Convert the previous query into a stored procedure.

DROP PROCEDURE IF EXISTS total_business;

DELIMITER //
CREATE PROCEDURE total_business()
BEGIN
	SELECT s.store_id AS store, COUNT(r.rental_id) AS total_films_rented, ROUND(SUM(p.amount),2) AS total_revenue
	FROM staff s
	JOIN rental r
	USING (staff_id)
	JOIN payment p
	USING (rental_id)
	GROUP BY store;
END // 
DELIMITER ;

CALL total_business;


# 3. Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

DROP PROCEDURE IF EXISTS total_business_inout;

DELIMITER //
CREATE PROCEDURE total_business_inout(in which_store int, out total_sales float)
BEGIN
	SELECT ROUND(SUM(p.amount),2) AS total_revenue into total_sales
	FROM staff s
	JOIN rental r
	USING (staff_id)
	JOIN payment p
	USING (rental_id)
    WHERE s.store_id = which_store;
END // 
DELIMITER ;

CALL total_business_inout(1, @total_sales);
SELECT ROUND(@total_sales,2);

CALL total_business_inout(2, @total_sales);
SELECT ROUND(@total_sales,2);

# 4. Update the previous query. 
## Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). 
### Call the stored procedure and print the results.

DROP PROCEDURE IF EXISTS total_business_per_store;

DELIMITER //
CREATE PROCEDURE total_business_per_store(in which_store int)
BEGIN
	DECLARE total_sales float;
	SELECT ROUND(SUM(p.amount),2) AS total_revenue into total_sales
	FROM staff s
	JOIN rental r
	USING (staff_id)
	JOIN payment p
	USING (rental_id)
    WHERE s.store_id = which_store;
    SELECT total_sales;
END // 
DELIMITER ;

CALL total_business_per_store(2);

# 5. In the previous query, add another variable flag. 
## If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
### Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.

DROP PROCEDURE IF EXISTS total_business_flags;

DELIMITER //
CREATE PROCEDURE total_business_flags(in which_store int)
BEGIN
	-- declare outputs
	DECLARE flag_value varchar(10) default "";
    DECLARE total_sales float;
    
    -- query
	SELECT 
    ROUND(SUM(p.amount), 2) AS total_revenue
INTO total_sales FROM
    staff s
        JOIN
    rental r USING (staff_id)
        JOIN
    payment p USING (rental_id)
WHERE
    s.store_id = which_store;
    
    -- condition
    IF total_sales > 30000 THEN 
		SET flag_value = "green_flag";
    ELSE
		SET flag_value = "red_flag";
    END IF;
    
    SELECT total_sales, flag_value;
    
END // 
DELIMITER ;

CALL total_business_flags(1);