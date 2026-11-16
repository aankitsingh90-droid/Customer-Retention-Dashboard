--Create Database Sales Analysis
-- Create and import data into table1 and table2
-- Union all both tables Table3
Select * into dbo.Table3
from
(
	Select * from Table1
union all
	Select * from Table2
) as T
-- Table3 renamed to Combined
-- Data Cleaning
--checking exact number of rows imported
Select count(*) from combined
--Checking null values
Select count(*) from combined where invoicedate is null

Select count(*) from combined where price is null

Select count(*) from combined where customer_ID  is null

Select count(*) from combined where Quantity <=0

--Checking exact duplicate rows
Select [Invoice],[StockCode],[Description],[Quantity],[InvoiceDate],[Price],[Customer_ID],[Country],  
	Count(*) as 'Count'
from combined c
	group by 
	[Invoice],[StockCode],[Description],[Quantity],[InvoiceDate],[Price],[Customer_ID],[Country]
	having count(*) >1
	order by Count desc

-- Removing duplicate rows and creating Retailcleaned table
With Final as
(
Select *,  
	ROW_NUMBER() over (partition by [Invoice],[StockCode],[Description],[Quantity],[InvoiceDate],[Price],[Customer_ID],[Country]
	order by (select null)) as 'Row'
	from combined c
)
Select [Invoice],[StockCode],[Description],[Quantity],[InvoiceDate],[Price],[Customer_ID],[Country] into RetailCleaned from final
	where Row =1 and [Quantity]>0 and Customer_ID is not null

select count(*) from RetailCleaned

-- Creating parameters and segmentation table (row count - 779493)

Select sub_1.*,sub_2.Frequency,Sub_3.Monetary into segmenttable from 
	(Select [Invoice],[StockCode],[Description],[Quantity],[InvoiceDate],[Price],[Customer_ID],[Country],
	DATEDIFF(day,Max([invoicedate])over(partition by [customer_ID] order by (select null)),(dateadd(day,1,Max([invoicedate])over()))) as Recency
	from RetailCleaned) as sub_1
left join 
	(select Customer_ID, COUNT(distinct Invoice) as Frequency from RetailCleaned group by [Customer_ID])  as Sub_2
	on sub_1.Customer_ID=Sub_2.Customer_ID
left join
	(select Customer_ID, sum(Price*Quantity) as Monetary from RetailCleaned group by [Customer_ID])  as Sub_3
	on sub_1.Customer_ID=Sub_3.Customer_ID

select top 1000 * from segmenttable

-- creating r score table 
with r as
(
Select distinct([Customer_ID]), [recency] from Segmenttable
)
select *, 6-ntile(5) over( order by [recency]) as r_score into r_scoretable from r

select * from r_scoretable
order by [recency]

-- creating f score table 
with f as
(
select distinct(customer_id),Frequency from Segmenttable
)
select *, 6-ntile(5) over (order by Frequency desc) as f_score into f_scoretable from f

select * from f_scoretable
order by Frequency desc

-- creating m score table 
with m as
(
select distinct(customer_id),Monetary from Segmenttable
)
select *, 6-ntile(5) over (order by Monetary desc) as m_score into m_scoretable from m

select * from m_scoretable
order by Monetary desc

--Creating finaltable (row count - 779493)
with final as
(
select s.*,r.r_score,f.f_score,m.m_score from Segmenttable s
join r_scoretable r
on r.Customer_ID = s.Customer_ID
join f_scoretable f
on f.Customer_ID = s.Customer_ID
join m_scoretable m
on m.Customer_ID = s.Customer_ID
)
Select *,
	format(invoicedate,'MMM') as 'Invoice Month',
	[price]*[Quantity] as 'Revenue',
	case
	when r_score>= 4 and f_score>=4 and m_score>=4 then 'Champions'
	when r_score>= 3 and f_score>=3 then 'Loyal'
	when r_score<= 2 and f_score>=3 then 'At Risk'
	when r_score>= 4 and f_score<=2 then 'New'
	when r_score = 3 and f_score<=2 then 'Needs Attention'
	else 'Lost'
	end as 'Segment',
	case
	when [Recency] > 90 then 'Is churned'
	else 'Not Churned'
	end as 'Churned'
	into Finaltable
from final


Select * from Finaltable