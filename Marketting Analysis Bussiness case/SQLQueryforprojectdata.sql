select * from [dbo].[products]
select * from [dbo].[customers]
select * from [dbo].[geography]
select * from [dbo].[customer_reviews]
select * from [dbo].[engagement_data]
select * from [dbo].[customer_journey]

--categorize products based on their price :
--max=500 min =25  --> p<50 =low , 50~200=Medium , else~500= High
select ProductID,ProductName,Price,
case
	when price<50 then 'Low Price'
	when price>=50 and price<=200  then 'Medium Price'
	else 'High Price' end as [Price Category]
from products
order by Price desc

--no duplicate data in products table
select *,ROW_NUMBER() over(partition by productid,productname,category,price order by price) from products

--adding customer age Group and complete Geographic Data of customer in a same table
select a.CustomerID,a.CustomerName,a.Email,a.Gender,a.Age,
case
    when age <13 then 'kids'
	when age<20 then 'Teens'
	when age<=39  then 'Young Adults'
	when age<=59  then 'Middle Age'
	else 'Senior Citizen'
	end as 'Age Group'
	,b.Country,b.City
from customers a
left join geography b
on a.GeographyID=b.GeographyID

--checking for any duplicay in the above table
with cte1 as(
select a.CustomerID,a.CustomerName,a.Email,a.Gender,a.Age,
case
    when age <13 then 'kids'
	when age<20 then 'Teens'
	when age<=39  then 'Young Adults'
	when age<=59  then 'Middle Age'
	else 'Senior Citizen'
	end as 'Age Group'
	,b.Country,b.City
from customers a
left join geography b
on a.GeographyID=b.GeographyID)
,cte2 as (
select *,ROW_NUMBER() over (partition by CustomerID,CustomerName,Email,Gender,Age,[Age Group]
	,Country,City order by CustomerID  ) as rn from cte1)

select * from cte2
where rn>1

--solving double white spaces issue in review text column
select ReviewID,CustomerID,ProductID,ReviewDate,Rating,
REPLACE(ReviewText,'  ',' ') as ReviewText
from customer_reviews

--clean and prepare engagement data 
select EngagementID,ContentID,EngagementDate,
upper(replace(ContentType,'socialmedia','social media')) as ContentType
,CampaignID,ProductID,Likes,
LEFT(ViewsClicksCombined, CHARINDEX('-', ViewsClicksCombined)-1 ) AS Views
,RIGHT(ViewsClicksCombined, len(ViewsClicksCombined)-CHARINDEX('-', ViewsClicksCombined)) as Clicks
from engagement_data
where ContentType!='NEWSLETTER'


--handle duplicate records in customer_journey data and nulls
with cte as(
select JourneyID,CustomerID,ProductID,VisitDate,upper(stage) as Stage,Action
,COALESCE(Duration,Avergae_Duration,Global_Avg_Duration) as Duration
,row_number() over(partition by JourneyID,CustomerID,ProductID,VisitDate
,stage,Duration,Action order by JourneyID ) as rn
from 
(select JourneyID,CustomerID,ProductID,VisitDate,stage,Action,
Duration,avg(Duration) over (partition by visitdate) as 
Avergae_Duration,
AVG(Duration) OVER () AS Global_Avg_Duration--if duration and average both are zero

from customer_journey)x --subquery
)

select JourneyID,CustomerID,ProductID,VisitDate,Stage,Action,Duration from cte 
where rn=1
order by JourneyID

