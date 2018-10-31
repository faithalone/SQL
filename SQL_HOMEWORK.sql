# 1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name, last_name
FROM actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT 
CONCAT(first_name, '  ', last_name) AS 'Actor Name'
FROM actor;

# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe'; 

# 2b. Find all actors whose last name contain the letters `GEN`:
SELECT last_name 
FROM actor
WHERE last_name LIKE '%GEN%';

# 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE '%LI%';

# 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

# 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.
ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(25) AFTER first_name;

# 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.
ALTER TABLE actor MODIFY middle_name blob;

# 3c. Now delete the `middle_name` column.
ALTER TABLE actor DROP COLUMN middle_name;

# 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) AS Last_name_Count
FROM actor
GROUP BY last_name;

# 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) AS Last_name_Count
FROM actor
GROUP BY last_name
HAVING Last_name_Count > 1;

# 4c. 4d. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
    SET first_name = 'HARPO'
    WHERE actor_id = 172;
 
# 5a You cannot locate the schema of the `address` table. Which query would you use to re-create it?5
 
# 6a Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT first_name, last_name, address
FROM staff
JOIN address
USING (address_id);
 
# 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
# SELECT staff_id, payment_date
# FROM payment;

SELECT last_name, SUM(amount) AS 'Total amount'
FROM staff
JOIN payment 
USING (staff_id)
WHERE payment_date between '2005-08-01 00:00:01' and '2005-08-31 23:59:59'
GROUP BY last_name;

# 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT film_actor.actor_id,film.title
FROM film_actor
INNER JOIN film ON film_actor.film_id = film.film_id;


# 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT title, COUNT(title)
FROM film
WHERE title = 'Hunchback Impossible';
 
# 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer.
SELECT last_name, SUM(amount) as 'Total amount paid'
FROM customer
JOIN payment
USING (customer_id)
GROUP BY last_name;

# 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT title
FROM film
WHERE title LIKE 'K%'
UNION
SELECT title
FROM film
WHERE title LIKE 'Q%';

# 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT first_name, last_name
FROM actor
JOIN film_actor
USING (actor_id)
JOIN film
USING(film_id)
WHERE title = 'Alone Trip';

# 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email
FROM customer
JOIN address
USING (address_id)
JOIN city
USING (city_id)
JOIN country
USING (country_id)
WHERE country = 'Canada';

# 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title
FROM film
JOIN film_category
USING(film_id)
JOIN category
USING(category_id)
WHERE category.name = 'family'; 

# 7e. Display the most frequently rented movies in descending order.
SELECT title, rental_rate
FROM film
ORDER BY rental_rate DESC;

# 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store_id, sum(amount) as 'Total per store'
from store
join staff
using(store_id)
join payment
using(staff_id)
group by store_id;

# 7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country
FROM store
JOIN address
USING(address_id)
JOIN city
USING(city_id)
JOIN country
USING(country_id);

# 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT category.NAME, SUM(amount) AS 'Total Top 5 genres'
FROM category
JOIN film_category
USING(category_id)
JOIN film
USING(film_id)
JOIN inventory
USING(film_id)
JOIN rental
USING(inventory_id)
JOIN payment
USING(rental_id)
GROUP BY category.NAME
ORDER BY SUM(amount) DESC LIMIT 5;

# 8a. and 8b. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_genres as
SELECT category.NAME, SUM(amount) as 'Total Top 5 genres'
FROM category
JOIN film_category
USING(category_id)
JOIN film
USING(film_id)
JOIN inventory
USING(film_id)
JOIN rental
USING(inventory_id)
JOIN payment
USING(rental_id)
GROUP BY category.name
ORDER BY SUM(amount) desc limit 5;


# 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW top_five_genres;