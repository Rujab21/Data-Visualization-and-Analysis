create database PROD
use PROD

SELECT * FROM `PROD`.`prod+env+inventory+dataset+(1)`;
update `PROD`.`prod+env+inventory+dataset+(1)`
set `product id`=11 where `product id`=22 ;

update `PROD`.`prod+env+inventory+dataset+(1)`
set `Product ID`=7 where `Product ID`=21;

create table `Final_product_table` as 
select a.`Product ID` as`product_id`,a.`Product Name` as `product_name`,a.`Unit Price ($)` as `unit_price`,
b.`Order Date (DD/MM/YYYY)` as `Order_Date_DD_MM_YYYY` ,b.`Availability` as `Availability`,b.`Demand` as `Demand`
from prod.`products+(2)` as a left join `PROD`.`prod+env+inventory+dataset+(1)` as b
on a.`Product ID`=b.`Product ID`
select * from `Final_product_table`