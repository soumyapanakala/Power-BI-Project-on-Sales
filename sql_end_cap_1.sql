--- First create database and then use it--
create database sales_data;
use sales_data;

--- To import data select the database from object explorer and right click on the database, nagigate to tasks
-- and then go to import flat file and finally import data to sql..

select * from all_data;  -- select the data which is imported..(table name is all_data)

--- Delete all the null values from the table--
delete from all_data
where Product is null;

delete from all_data
where Quantity_Ordered is null;

--- Remove unwanted data from the data--
delete from all_data
where Quantity_Ordered = 'Quantity Ordered';

--- primary key means it should have both unique and not null values, i.e.,
--- from this table primary key column is ["Order_ID"] ---

--- Change the price of the product into dollars---
SELECT '$'+convert(varchar,Price_Each) Price_Each
FROM   all_data;

--- change the datatypes of columns which donot have proper datatypes--
alter table all_data
alter column Order_ID int;

alter table all_data
alter column Quantity_Ordered int;

alter table all_data
alter column Price_Each float;

alter table all_data
alter column Order_Date Datetime;

---create a new column "sales" by multiplying 'quantity_ordered and price_each'---
select *, Quantity_Ordered*Price_Each as total_sales_per_person from all_data;


---Create a Transaction to separate city column from the purchase_address column.---
begin transaction city
select *, substring([Purchase_Address],CHARINDEX(',',[Purchase_Address])+1,
  CHARINDEX(',',[Purchase_Address],CHARINDEX(',',[Purchase_Address])+1)-1-CHARINDEX(',',[Purchase_Address]))
  as city from all_data;
commit transaction city;


---Create a Transaction to Day,Month,Year column from the purchase Order Date column...
Begin transaction date_col
select *, FORMAT(Order_Date,'ddd') as Day,FORMAT(Order_Date,'m') as Month,FORMAT(Order_Date,'yyyy') as Year
from all_data;
commit transaction date_col;


---Create a procedure to find top sold Products---
CREATE PROCEDURE top_sold_products
as
begin
select Product,sum(Quantity_Ordered) as sold_quantity from all_data
group by product
order by sold_quantity desc;
end;

-- Now Execute the procedure top_sold_products--
exec top_sold_products;


---Create a procedure to find Total Unique Products-----
CREATE PROCEDURE total_Unique_Product
as
begin
select count(distinct product) as total_unique_products from all_data;
end;

-- Now Execute procedure total_UniqueProducts--
exec total_Unique_Product;


---Create a Procedure to find the top cities with the highest sales in descending order---
CREATE PROCEDURE topcities_having_high_sales
as
begin
select substring([Purchase_Address],CHARINDEX(',',[Purchase_Address])+1,
  CHARINDEX(',',[Purchase_Address],CHARINDEX(',',[Purchase_Address])+1)-1-CHARINDEX(',',[Purchase_Address]))
  as city, 
  sum(Quantity_Ordered*Price_Each) as total_sales
  from all_data
  group by substring([Purchase_Address],CHARINDEX(',',[Purchase_Address])+1,
  CHARINDEX(',',[Purchase_Address],CHARINDEX(',',[Purchase_Address])+1)-1-CHARINDEX(',',[Purchase_Address]))
  order by  total_sales desc;
end;

--Now execute the procedure top_cities_with_highest_sales---
exec topcities_having_high_sales;


        -------------END OF end_capstone_1------------          