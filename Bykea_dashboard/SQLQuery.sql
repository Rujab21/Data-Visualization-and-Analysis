--bykea project analysis
select * from [dbo].[bykea_rides]

-- Retrieve all successful bookings:
select * from [dbo].[bykea_rides]
where booking_status='Success'

--Find the average ride distance for each vehicle type:
select vehicle_type,avg(ride_distance) [avg Ride Distance] from [dbo].[bykea_rides]
group by vehicle_type

--Get the total number of cancelled rides by customers:
select count(booking_status )[total number of cancelled rides] from bykea_rides
where booking_status in('Cancelled by Customer')

--List the top 5 customers who booked the highest number of rides:
with cte as
(select customer_id,count(booking_id) [No of Rides] from [dbo].[bykea_rides]
group by customer_id)
select top 5 * from cte
order by [No of Rides] desc


--Get the number of rides cancelled by drivers due to personal and car-related issues:
select * from bykea_rides
where booking_status='Cancelled by Driver' and reason_for_cancelling_by_driver='Personal & Car related issues'

--Find the maximum and minimum driver ratings for Prime Sedan bookings:
select max(driver_ratings)[max driver rating],min(driver_ratings)[min driver rating] from bykea_rides
where vehicle_type='Prime Sedan'
--adding new column update to original data :
drop table bykea_rides
sp_rename 'bykea_rides2', 'bykea_rides';

-- Retrieve all rides where payment was made using card:

select * from bykea_rides
where payment_method ='Card'



--Find the average customer rating per vehicle type:
select vehicle_type,avg(customer_rating)[Avg customer rating] from bykea_rides
group by vehicle_type

--Calculate the total booking value of rides completed successfully:
select sum(booking_value)[Total booking value] from bykea_rides
where booking_status='Success'


--List all incomplete rides along with the reason:select booking_id,booking_status,incomplete_rides_reasonfrom bykea_rideswhere incomplete_rides=1