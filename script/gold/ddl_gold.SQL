/* 
===========================================================================================
DDL Script: Create  Gold Views
===========================================================================================
Script Purpose:
         This script creates viewv for the gold layerin the data warehose.
         The Gold laywe represents the final dimension and fact tables (Star Schema)

         Each view performs transformations and combines data from Silver layer to 
         produce clean, enriched and business-ready dataset.

 Usage:
    These views can be quaried directly for analytics and reporting
    =======================================================================================
*/



------------------------------------------------------------------------------------------

/* 
====================================================================
create dimension: gold.dim_customers
====================================================================
*/

create view gold.dim_customers as 
select
row_number() over (order by cst_id) as customer_key,
ci.cst_id as customer_id,
ci.cst_key as customer_number,
ci.cst_firstname as first_name,
ci.cst_lastname as last_name,
la.CNTRY as country,
ci.cst_marital_status as marital_status,
case when ci.cst_gndr!=ca.GEN THEN ci.cst_gndr
else COALESCE(ca.GEN, 'n/a')
end as gender,
ca.BDATE as birthday,
ci.cst_create_date as create_date
from silver.crm_cust_info ci
left join silver.erp_CUST_AZ12 ca
on ci.cst_key=ca.CID
left join silver.erp_LOC_A101 la
on ci.cst_key=la.CID



/* 
====================================================================
create dimension: gold.dim_product
====================================================================
*/

  
create view gold.dim_products as 
select 
row_number() over (order by pn.prd_start_dt, pn.prd_key) as product_key,
pn.prd_id as product_id,
replace(pn.prd_key,'_','-') as product_number,
pn.prd_nm as prodct_name,
pn.category_id as category_id,
px.CAT as category,
px.SUBCAT as subcategory,
px.MAINTENANCE as maintanence,
pn.prd_cost as cost,
pn.prd_line as product_line,
pn.prd_start_dt as start_date
from silver.crm_prd_info pn
LEFT join silver.erp_PX_VAT_G1V2 px
on pn.category_id=px.ID
WHERE pn.prd_end_dt is NULL 




  /* 
====================================================================
create fact: gold.fact_sales
====================================================================
*/

  create view gold.fact_sales as
select 
sd.sls_ord_num as order_number,
pr.product_key,
cu.customer_key,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shipping_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales_amount,
sd.sls_quantity as quantity,
sd.sls_price as price
from silver.crm_sales_details sd
left join gold.dim_products pr
on sd.sls_prd_key=pr.product_number
left join gold.dim_customers cu
on sd.sls_cust_id=cu.custo

