-- Bike Reantal  Shop Case Study Questions & Answers :-

/* Task 1:- Display the category name and the number of bikes the shop owns in each category (call this column number_of_bikes ). 
Show only the categories where the number of bikes is greater than 2.*/
--Query:-
select * from bikes;

select
     category,
	 count(model) as number_of_bikes
from bikes
    group by category
	    having count(model) > 2;

/*Task 2:-  For each customer, display the customer's name and the count of memberships purchased (call this column membership_count ). 
Sort the results by membership_count , starting with the customer who has purchased the highest number of memberships.
Keep in mind that some customers may not have purchased any memberships yet. In such a situation, display 0 for the membership_count .*/
--Query:-
select * from customers;
select * from membership;

select
     c.full_name as customer_name,
	 count(m.membership_type_id) as membership_count
from customers as c
left join membership as m on c.customer_id = m.customer_id
    group by c.full_name
	    order by membership_count desc;

/* Task 3:- For each bike, display its ID, category, old price per hour (call this column 
old_price_per_hour ), discounted price per hour (call it 
new_price_per_hour ), old 
price per day (call it 
old_price_per_day ), and discounted price per day (call it 
new_price_per_day ).
 Electric bikes should have a 10% discount for hourly rentals and a 20% 
discount for daily rentals. Mountain bikes should have a 20% discount for 
hourly rentals and a 50% discount for daily rentals. All other bikes should 
have a 50% discount for all types of rentals.
 Round the new prices to 2 decimal digits.
*/
--Query:-
 select * from bikes; 

 select
      bike_id,
	  category,
	  price_per_hour as old_price_per_hour,
	  (case
	      when category = 'electric' then round(price_per_hour * 0.9,2)
		  when category = 'mountain bike' then round(price_per_hour * 0.8, 2)
		  else round(price_per_hour / 2,2)
	  end) as new_price_per_hour,
	  price_per_day as old_price_per_day,
	  (case
	      when category = 'electric' then round(price_per_day * 0.8,2)
		  when category = 'mountain bike'  then round(price_per_day / 2, 2)
		  else round(price_per_day /2,2)
	  end) as new_price_per_day
from bikes;	  
	  
/* Task 4:-  Display the number of available bikes (call this column 
available_bikes_count ) and the number of rented bikes (call this column 
rented_bikes_count ) by bike category
*/
--Query:-
select * from bikes;

select
     category,
	 sum(case when status = 'available' then 1 else 0 end ) as available_bikes_count,
	 sum(case when status = 'rented' then 1 else 0 end ) as rented_bikes_count
from bikes
    group by category

/* Task 5:- Display the total revenue from rentals for each month, the total for each 
year, and the total across all the years. Do not take memberships into 
account. There should be 3 columns: 
year , 
month , and 
revenue .
 Sort the results chronologically. Display the year total after all the month 
totals for the corresponding year. Show the all-time total as the last row.*/
--Query:-

select
     extract(year from start_timestamp) as yearly,
	 extract(month from start_timestamp) as monthly,
	 sum(total_paid) as revenue
from rental
    group by grouping sets ((extract(year from start_timestamp),extract(month from start_timestamp)),(extract(year from start_timestamp)),())
	     order by yearly,monthly

/* Task 6:-  Display the year, the month, the name of the membership type (call this 
column 
membership_type_name ), and the total revenue (call this column 
total_revenue ) for every combination of year, month, and membership type. 
Sort the results by year, month, and name of membership type.*/
--Query:-
select * from membership_type;
select * from membership;
select * from rental;
select
     extract(year from m.start_date ) as yearly,
	 extract(month from m.start_date) as monthly,
	 mt.membership_name as membership_type_name,
	 sum(m.total_paid) as total_revenue
from membership as m
join membership_type as mt on m.membership_type_id = mt.id
    group by extract(year from m.start_date ) ,extract(month from m.start_date),mt.membership_name
	     order by monthly;

/* Task 7:-  Display the total revenue from memberships purchased in 2023 for each 
combination of month and membership type. Generate subtotals and 
grand totals for all possible combinations.  There should be 3 columns: 
membership_type_name , 
month , and 
total_revenue .
 Sort the results by membership type name alphabetically and then 
chronologically by month.*/
--Query:-
select * from membership;
select * from membership_type;

select
     mt.membership_name,
	 extract(month from m.start_date) as monthly,
	 sum(total_paid) as total_revenue
from membership as m
join membership_type as mt on m.membership_type_id = mt.id
      where extract(year from m.start_date) = 2023
           group by cube(mt.membership_name,extract(month from m.start_date))
		        order by mt.membership_name asc , extract(month from m.start_date);

/* Task 8:- Now it's time for the final task.
 Emily wants to segment customers based on the number of rentals and 
see the count of customers in each segment. Use your SQL skills to get 
this!
 Categorize customers based on their rental history as follows:
 Customers who have had more than 10 rentals are categorized as 
than 10' .
 'more 
Customers who have had 5 to 10 rentals (inclusive) are categorized as 
'between 5 and 10' .
 Customers who have had fewer than 5 rentals should be categorized as 
'fewer than 5' .
 Calculate the number of customers in each category. Display two columns: 
rental_count_category (the rental count category) and 
number of customers in each category).*/
--Query:-
select * from bikes;
select * from rental;
with customers_rental_count as (
select
     b.category as rental_count_category,
	 count(r.customer_id) as total_number_of_customer
from bikes as b
join rental as r on b.bike_id = r.bike_id
    group by b.category
	     order by rental_count_category asc
)

select
     *,
	 case
	     when total_number_of_customer > 10 then 'more than 10'
		 when (total_number_of_customer between 5 and 10) then 'between 5 and 10'
		 when total_number_of_customer < 5 then 'fewer than 5'
	 end as rental_customer_category
from customers_rental_count;	 