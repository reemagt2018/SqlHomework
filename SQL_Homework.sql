USE sakila;


#1a. Display the first and last names of all actors from the table actor.

select first_name,last_name from actor;


#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

select  Upper(CONCAT(first_name, ' ', last_name))   as "Actor Name" from actor;


#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
 select actor_id,first_name, last_name from actor
 where first_name="Joe";

select * from actor;
#2b. Find all actors whose last name contain the letters GEN:

select actor_id,first_name, last_name from actor
 where upper(last_name) like "%GEN%";
 

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select actor_id,first_name, last_name from actor
 where upper(last_name) like "%LI%"
 order by last_name,first_name;


#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

select * from country
where country in ('Afghanistan', 'Bangladesh','China');


#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
alter table actor
ADD( description  blob );

select * from actor;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.

alter table actor
drop  description ;

select * from actor;

#4a. List the last names of actors, as well as how many actors have that last name.

select last_name,count(*) as number_of_actors_with_this_lastname from actor
group by 1;



#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name,count(*) as number_of_actors_with_this_lastname from actor
group by 1
having count(*) >1;
#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

select * from actor
where Upper(CONCAT(first_name, ' ', last_name)) = "GROUCHO WILLIAMS";

update actor
set  first_name="HARPO",
     last_name="WILLIAMS"
     where Upper(CONCAT(first_name, ' ', last_name)) = "GROUCHO WILLIAMS";

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update actor
set first_name="GROUCHO"
where first_name="HARPO";




#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;



#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select first_name, last_name , address, address2, district, city_id, postal_code, phone, location from  staff S
join address A
on S.address_id=A.address_id;




#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select first_name,last_name,sum(amount ) as total_amount    from staff S
join   payment P
on s.staff_id=p.staff_id
and substr(payment_date,1,7)='2005-08'
group by 1,2;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

select title, count(actor_id )  from  film F
join film_actor FA
on F.film_id=FA.film_id;


#6d. How many copies of the film Hunchback Impossible exist in the inventory system?

select "Hunchback Impossible" as Movie_Inventory,count(inventory_id) from inventory I
join film F
on F.film_id=I.film_id
where F.title="Hunchback Impossible";



#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:


select first_name,last_name , sum(amount) as total_paid   from  customer C
join payment P
on C.customer_id=P.customer_id
group by 1,2
order by 2;



#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
# As an unintended consequence, films starting with the letters K and Q have also soared in popularity.
# Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

select title from film F
where language_id in 
(select language_id from language
where name='English');



#7b. Use subqueries to display all actors who appear in the film Alone Trip.

select first_name,last_name from actor  A
Join film_actor FA
on FA.actor_id=A.actor_id
and film_id in 
(select film_id from film
where title='Alone Trip');
#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

select first_name,last_name,email from customer C
join address A
on C.address_id=A.address_id
join City CI
on CI.city_id=A.city_id
join country CO
on CO.country_id=CI.country_id
and country='Canada';



#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
# Identify all movies categorized as family films.
SELECT 
    title
FROM
    film F
        JOIN
    film_category FC ON F.film_id = FC.film_id
        JOIN
    category C ON C.category_id = FC.category_id
WHERE
    name = 'Family';

#7e. Display the most frequently rented movies in descending order.
select title, count(*) from film F
join inventory I
on F.film_id= I.film_id
join rental R
on I.inventory_id=R.inventory_id
group by 1
Order by 2 DESC;



#7f. Write a query to display how much business, in dollars, each store brought in.
 
 select s.store_id,sum(amount) from payment p
 join staff st
 on st.staff_id=p.staff_id
 join store s
 on s.store_id=st.store_id
 group by 1;
 
 
 

#7g. Write a query to display for each store its store ID, city, and country.

select store_id, city,country from store s
join address a
on a.address_id=s.address_id
join city  c
on c.city_id=a.city_id
join country co
on co.country_id=c.country_id;

#7h. List the top five genres in gross revenue in descending order.
# (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

select c.name,sum(p.amount)  from category c
join film_category fc
on fc.category_id=c.category_id
join inventory i 
on i.film_id=fc.film_id
join rental r
on r.inventory_id=i.inventory_id
join payment p
on p.rental_id=r.rental_id
group by 1
order by 2
limit 5;





#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

create view vw_top_5_genre_revenue as
select c.name,sum(p.amount)  from category c
join film_category fc
on fc.category_id=c.category_id
join inventory i 
on i.film_id=fc.film_id
join rental r
on r.inventory_id=i.inventory_id
join payment p
on p.rental_id=r.rental_id
group by 1
order by 2
limit 5;

#8b. How would you display the view that you created in 8a?

select * from vw_top_5_genre_revenue;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

drop view vw_top_5_genre_revenue;

