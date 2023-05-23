# Lab | Stored procedures
# Instructions
# Write queries, stored procedures to answer the following questions:
## In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
## Convert the query into a simple stored procedure. Use the following query:
USE sakila;

DROP PROCEDURE IF EXISTS spcustomers_rented_action;
DELIMITER //
CREATE PROCEDURE spcustomers_rented_action()
BEGIN
	SELECT first_name, last_name, email
    FROM customer
	JOIN rental 
    ON customer.customer_id = rental.customer_id
	JOIN inventory 
    ON rental.inventory_id = inventory.inventory_id
	JOIN film 
    ON film.film_id = inventory.film_id
	JOIN film_category 
    ON film_category.film_id = film.film_id
	JOIN category 
    ON category.category_id = film_category.category_id
	WHERE category.name = "Action"
	GROUP BY first_name, last_name, email;
END //
DELIMITER ;

CALL spcustomers_rented_action();
  
### Now keep working on the previous stored procedure to make it more dynamic. 
### Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. 
### For eg., it could be action, animation, children, classics, etc.

DROP PROCEDURE IF EXISTS spcustomers_rented_percategory;
DELIMITER //
CREATE PROCEDURE spcustomers_rented_percategory(in category varchar(15))
BEGIN
	SELECT first_name, last_name, email
    FROM customer
	JOIN rental 
    ON customer.customer_id = rental.customer_id
	JOIN inventory 
    ON rental.inventory_id = inventory.inventory_id
	JOIN film 
    ON film.film_id = inventory.film_id
	JOIN film_category 
    ON film_category.film_id = film.film_id
	JOIN category 
    ON category.category_id = film_category.category_id
	WHERE category.name = category COLLATE utf8mb4_general_ci
	GROUP BY first_name, last_name, email;
END //
DELIMITER ;

CALL spcustomers_rented_percategory("animation");

### Write a query to check the number of movies released in each movie category. 
### Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.

-- query
SELECT c.name AS category_name, COUNT(fc.film_id) AS film_count
FROM film_category fc
JOIN category c
USING (category_id)
GROUP BY category_name;

-- stored procedure
DROP PROCEDURE IF EXISTS film_count_per_category;
DELIMITER //
CREATE PROCEDURE film_count_per_category(in numfilms int)
BEGIN
SELECT c.name AS category_name, COUNT(fc.film_id) AS film_count
FROM film_category fc
JOIN category c
USING (category_id)
GROUP BY category_name
HAVING film_count > numfilms;
END //
DELIMITER ;

CALL film_count_per_category (70);
