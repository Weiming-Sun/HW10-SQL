USE sakila;

#1a. Display the first and last names of all actors from the table actor.
select first_name, last_name
from actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. 
#Name the column Actor Name.
select concat(first_name, " ", last_name) AS Actor_Name 
from actor;

#2a. You need to find the ID number, first name, and last name of an actor, 
#of whom you know only the first name, "Joe." 
#What is one query would you use to obtain this information?
select actor_id, first_name, last_name
from actor
where first_name = 'Joe';

#2b. Find all actors whose last name contain the letters GEN:
select first_name, last_name
from actor
where last_name like '%GEN%';

#2c. Find all actors whose last names contain the letters LI. 
#This time, order the rows by last name and first name, in that order:
select first_name, last_name
from actor
where last_name like '%LI%'
order by last_name, first_name;

#2d. Using IN, display the country_id and country columns of the following countries: 
#Afghanistan, Bangladesh, and China:
select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

#3a. Add a middle_name column to the table actor. Position it between first_name and last_name. 
#Hint: you will need to specify the data type.
alter table actor
add column middle_name VARCHAR(30) after first_name;
select * from actor;

#3b. You realize that some of these actors have tremendously long last names. 
#Change the data type of the middle_name column to blobs.
alter table actor
modify column middle_name blob;
select * from actor;

#3c. Now delete the middle_name column.
alter table actor
drop column middle_name;
select * from actor;

#4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*)
from actor
group by last_name;

#4b. List last names of actors and the number of actors who have that last name, 
#but only for names that are shared by at least two actors
select last_name, count(*)
from actor
group by last_name
having count(last_name) > 1;

#4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, 
#the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
update actor 
set first_name = 'HARPO'
where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
#It turns out that GROUCHO was the correct name after all! 
#In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. 
#Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. 
#BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! 
#(Hint: update the record using a unique identifier.)
update actor 
set first_name = 'GROUCHO'
where first_name = 'HARPO' and last_name = 'WILLIAMS';
update actor 
set first_name = 'MUCHO GROUCHO'
where actor_id = 172;
select * from actor where actor_id = 172;

#5a. You cannot locate the schema of the address table. 
#Which query would you use to re-create it? HINT: CHECK THIS OUT
show create table address;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
#Use the tables staff and address:
select s.first_name, s.last_name, a.address
from staff s 
join address a 
on s.address_id = a.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
#Use tables staff and payment.
select concat(s.first_name, " ", s.last_name), sum(p.amount)
from payment p
join staff s
on p.staff_id = s.staff_id
where (p.payment_date between '2005-08-01 00:00:00' and '2005-08-31 23:59:59')
group by p.staff_id;

#6c. List each film and the number of actors who are listed for that film. 
#Use tables film_actor and film. Use inner join.
select f.title, count(fa.actor_id)
from film_actor fa 
join film f 
on fa.film_id = f.film_id
group by f.film_id;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select count(*)
from inventory
where film_id in
(
	select film_id
    from film
    where title = 'Hunchback Impossible'
);

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
#List the customers alphabetically by last name:
select concat(c.first_name, " ", c.last_name), sum(p.amount)
from payment p
join customer c
on p.customer_id = c.customer_id
group by p.customer_id
order by c.last_name;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
#Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title
from film
where title like 'K%' or title like 'Q%'
and language_id in
(
	select language_id
    from language
    where name = 'English'
);

#7b. Use subqueries to display all actors who appear in the film Alone Trip
select concat(first_name, ' ', last_name) 
from actor
where actor_id in
(
	select actor_id
    from film_actor
    where film_id in
    (
		select film_id
        from film
        where title = 'Alone Trip'
	)
);

#7c. You want to run an email marketing campaign in Canada, 
#for which you will need the names and email addresses of all Canadian customers. 
#Use joins to retrieve this information.
select concat(cus.first_name, ' ', cus.last_name), cus.email
from customer cus
join address a
on cus.address_id = a.address_id
join city
on a.city_id = city.city_id
join country c
on city.country_id = c.country_id
where c.country = 'Canada';

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.
select title
from film
where film_id in
(
	select film_id
    from film_category
    where category_id in
    (
		select category_id
        from category
        where name = 'Family'
	)
);

#7e. Display the most frequently rented movies in descending order.
select f.title, count(r.rental_id)
from rental r
join inventory i 
on r.inventory_id = i.inventory_id
join film f
on i.film_id = f.film_id
group by i.film_id
order by count(r.rental_id) desc;

#7f. Write a query to display how much business, in dollars, each store brought in.
select store.store_id, sum(p.amount)
from payment p
join staff s 
on p.staff_id = s.staff_id
join store
on s.store_id = store.store_id
group by store.store_id;

#7g. Write a query to display for each store its store ID, city, and country.
select s.store_id, city.city, c.country
from store s
join address a
on s.address_id = a.address_id
join city
on a.city_id = city.city_id
join country c
on city.country_id = c.country_id;

#7h. List the top five genres in gross revenue in descending order. 
#(Hint: you may need to use the following tables: 
#category, film_category, inventory, payment, and rental.)
select c.name, sum(p.amount)
from category c
join film_category fc 
on c.category_id = fc.category_id
join inventory i
on fc.film_id = i.film_id
join rental r
on i.inventory_id = r.inventory_id
join payment p
on r.rental_id = p.rental_id
group by c.name
order by sum(p.amount) desc
limit 5;

#8a. In your new role as an executive, 
#you would like to have an easy way of viewing the Top five genres by gross revenue. 
#Use the solution from the problem above to create a view. 
#If you haven't solved 7h, you can substitute another query to create a view.
create view exec_view as
select c.name, sum(p.amount)
from category c
join film_category fc 
on c.category_id = fc.category_id
join inventory i
on fc.film_id = i.film_id
join rental r
on i.inventory_id = r.inventory_id
join payment p
on r.rental_id = p.rental_id
group by c.name
order by sum(p.amount) desc
limit 5;

#8b. How would you display the view that you created in 8a?
select * from exec_view;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view exec_view;