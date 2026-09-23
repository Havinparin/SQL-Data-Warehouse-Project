/*
====================================================================================
DDL SCRPIPT: Cretae silver tables
====================================================================================
script purpse:
    this script create tables in the silver schema.
    run this script to re-define the ddl strucure of 'bronze' tables

====================================================================================
*/

create table silver.crm_cust_info(
cst_id int,
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_marital_status nvarchar(50),
cst_gndr nvarchar(50),
cst_create_date date,
dwh_create_date datetime2 default getdate()
);

create table silver.crm_prd_info(
prd_id int,
prd_key nvarchar(50),
prd_nm nvarchar(50),
prd_cost int,
prd_line nvarchar(50),
prd_start_dt datetime,
prd_end_dt datetime,
dwh_create_date datetime2 default getdate()
);

create table silver.crm_sales_details(
sls_ord_num varchar(50),
sls_prd_key varchar(50),
sls_cust_id int,
sls_order_dt int,
sls_ship_dt int,
sls_due_dt int,
sls_sales int,
sls_quantity int,
sls_price int,
dwh_create_date datetime2 default getdate()
);

create table silver.erp_CUST_AZ12(
CID nvarchar(50),
BDATE DATE,
GEN NVARCHAR(50),
dwh_create_date datetime2 default getdate()
);

create table silver.erp_PX_VAT_G1V2(
ID NVARCHAR(50),
CAT NVARCHAR(50),
SUBCAT NVARCHAR(50),
MAINTENANCE NVARCHAR(50),
dwh_create_date datetime2 default getdate()
);

create table silver.erp_LOC_A101(
CID NVARCHAR(50),
CNTRY NVARCHAR(50),
dwh_create_date datetime2 default getdate()
);
