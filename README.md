# Customer-Retention-Dashboard
<img width="593" height="329" alt="image" src="https://github.com/user-attachments/assets/34c40642-0378-4753-a19d-862155d7b6d7" />

<img width="593" height="329" alt="image" src="https://github.com/user-attachments/assets/6fe14966-f32f-469f-8356-244bdc72083a" />

**Overview**
RFM Analysis on customer ordering data to analyse revenue from potential customers to plan a customer retention statergy.

**Approach**
**-- Data preparation and data cleaning within database using SQL**
-- Create database in sql server and import 2 csv files with customer ordering information such as invoice number, stockcode, production description, invoice date, 
   Unit price, Quantity ordered, Customer ID and Country.
-- Union data from 2 tables to create a combined table with all information in a signle table.
-- Perform datatype correction of columns, check nulls, remove duplicate rows to create a clean table with customer id and valid purchase quantity.
-- Creating parameters such for Recency, Frequency and Monetary for RFM analysis
-- Creating rfm scores basis the parameters and finally creating segmentation of Customers basis the rfm scores
-- Export final cleaned table from sql server in csv format

**-- Generate key insights and Data Visualization using Power BI**
-- Import final cleaned csv from sql server into power bi
-- Create calculated measure to achive required set of calculation 
-- Create data visuals in line to RFM analysis which is easy to understand and provide key insight from data

**--Conclusion**
Using RFM analysis we are able to determine about 49% of total customer are doing continuously business and ordering products.
On the other hand the 51% customer to have reduce and even stop ordering and are churned.
We are able to see that highest number of orders are in month of November followed by reduction in order in month of decemeber each year.
Highest amount of Avg. cutomer value is from Ireland followed by Singapore and Netherlands. On the other hand UK is where highest revenue is acheived.
All these insight will assist business to plan customer retention stratergy.
