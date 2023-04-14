use company;
select *
from people ;

-- Addresses need to broken up 

select address
from people 
where address not regexp '^[0-9a-zA_Z\. ]+;[a-zA-z ]+; [A-Z ]+;[0-9 ]+$';


-- Fix 3 addresses which are not in  the same format as other address . 

--  These are SQL queries that extract different parts of an address stored in a column called "address" in a table called "people". The address is assumed to have four parts: street, city, state, and zip code, separated by semicolons (;).
select substring_index(substring_index(address, ';', 2), ';', -1) from people;
select substring_index(substring_index(address, ';', 3), ';', -1) from people;
select substring_index(substring_index(address, ';', 1), ';', -1) as street, 
 substring_index(substring_index(address, ';', 2), ';', -1) as city,
 substring_index(substring_index(address, ';', 3), ';', -1) as state, 
 substring_index(substring_index(address, ';', 4), ';', -1) as zip
 from people ;
 
 -- This is a SQL command to create a table named "address" with six columns: "id", "street", "city", "state", "zip", and "pfk".
 -- The "id" column is set to be an auto-incrementing integer that is not null, meaning it cannot be left blank and will automatically be assigned a unique value for each new record added to the table.
 -- The "primary key" constraint is applied to the "id" column, indicating that it will be the primary key of the table, which will ensure that each record in the table has a unique identifier.

create table address (
id int not null auto_increment, 
street varchar(255) not null, 
city varchar(255) not null,
state varchar(2) not null,
zip varchar(10) not null,
pfk int,
primary key (id)
);


-- This is a SQL command that inserts data into a table called "address". The data is selected from the "people" table, and the different parts of each address in that table are extracted and inserted into the corresponding columns of the "address" table.
-- The command starts with the "insert into" keyword, followed by the name of the table to which the data will be inserted, which is "address". The column names that will be populated with the values are listed in parentheses after the table name.
--  In this case, the columns are "street", "city", "state", "zip", and "pfk".


insert into address(street, city, state, zip, pfk)
select trim(substring_index(substring_index(address, ';', 1), ';', -1)) as street, 
 trim(substring_index(substring_index(address, ';', 2), ';', -1)) as city,
 trim(substring_index(substring_index(address, ';', 3), ';', -1)) as state, 
 trim(substring_index(substring_index(address, ';', 4), ';', -1)) as zip,
 id 
 from people;
 
 -- This is a SQL query that selects data from two tables named "people" and "address" within the "company" database. 
 -- The query uses a join operation to combine the data from these tables based on the "id" column in the "people" table matching the "pfk" column in the "address" table.
 
select * 
from company.people, company.address
where people.id = address.pfk;