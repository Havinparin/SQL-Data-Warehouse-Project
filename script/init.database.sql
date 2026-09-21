/* -----------------------------------------------------------------------------------

CREATE DATABASE AMD SCHEMAS 

-------------------------------------------------------------------------------------
Script purpose:

this script creates new database named 'datawarehouse'. additionally the script sets up three schemas
within the database: 'bronze' , 'silver' and 'gold'
*/

use master; 
go
  
create database datawarehouse;
use datawarehouse;
go
  
create schema bronze;
go
create schema silver;
go
create schema gold;
go
