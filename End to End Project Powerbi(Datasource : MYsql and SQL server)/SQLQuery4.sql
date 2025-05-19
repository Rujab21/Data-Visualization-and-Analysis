/*Basically when we are working on a real time project first we make the project on the test enviroment which is the subset of production enviroment 
and then switch the project to production enviroment*/

--Test Enviroment 
create database testenviroment
use testenviroment

select * from [dbo].[Products]
select * from [dbo].[Test+Environment+Inventory+Dataset]

select * into Final_product_table from
(select a.Product_id, a.product_name ,Unit_price ,Order_Date_DD_MM_YYYY,Availability,Demand from [dbo].[Products] a left join [dbo].[Test+Environment+Inventory+Dataset] b
on a.product_id= b.product_id)x

select distinct Order_Date_DD_MM_YYYY from Final_product_table
select Order_Date_DD_MM_YYYY, Sum(demand) from Final_product_table
group by Order_Date_DD_MM_YYYY

select * from Final_product_table

-------Production Enviroment
create database prod

use prod
select * from [dbo].[Products+(1)]
select * from [dbo].[Prod+Env+Inventory+Dataset]

--Checking our data 
select distinct Order_Date_DD_MM_YYYY from [dbo].[Prod+Env+Inventory+Dataset]
where Order_Date_DD_MM_YYYY is null or Order_Date_DD_MM_YYYY= ''

select distinct Product_id from [dbo].[Prod+Env+Inventory+Dataset]
where Product_id is null or Product_id= ''

select availability from [dbo].[Prod+Env+Inventory+Dataset]
where availability is null or availability= ''

select * from [dbo].[Prod+Env+Inventory+Dataset]
where availability is null or availability= ''

select * from [dbo].[Prod+Env+Inventory+Dataset]
where demand is null or demand= ''

-- check if products inventory data have excess product ids that are not present in availability
select a.product_id as [pid from inventory],b.product_id as [pid from product table] from [dbo].[Prod+Env+Inventory+Dataset] a left join [dbo].[Products+(1)]  b
on a.product_id=b.product_id
where b.product_id is null 
--bug there are 2 records 22 and 21 which are not part of our product list but they have data so after consulting with 
--data engineering team it is found out that basically they are for record 11, 7
--fixing 22-->11 and 21-->7
update [dbo].[Prod+Env+Inventory+Dataset]
set product_id=11 where product_id=22 

update [dbo].[Prod+Env+Inventory+Dataset]
set product_id=7 where product_id=21

select * from [dbo].[Products+(1)] a join [dbo].[Prod+Env+Inventory+Dataset] b
on a.product_id=b.product_id
where a.product_id in (7,21)

-- shifting the joint data into new table Production_complete_data
select * into Production_complete_data from(
select a.product_id,a.product_name,a.unit_price,b.Order_Date_DD_MM_YYYY ,b.Availability,b.Demand from [dbo].[Products+(1)] a join [dbo].[Prod+Env+Inventory+Dataset] b
on a.product_id=b.product_id)x

select * from Production_complete_data
order by product_id

--the names of the tables that we are gonna in pbi report should be same and that is for columns headers too.
sp_rename 'Production_complete_data', 'Final_product_table';

select * from Final_product_table