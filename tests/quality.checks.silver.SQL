/*
==========================================
Quality checks
==========================================
script purpose:
  this script perform various quality checks for data consistency, accuarcy ad stanartization for 'silver' schemas.
  it includes checks for:
  - null or duplicates
  - unwanted spaces
  -invalid dates
  -data stantardization and data consistency between related fields
==========================================
*/



/* 
--------------------------------------------
checklist for  bronze.crm_cust_info
--------------------------------------------*/
select 
cst_id,
count(*)
from bronze.crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null


select cst_lastname
from bronze.crm_cust_info
where cst_lastname != trim(cst_lastname)

select distinct cst_gndr
from bronze.crm_cust_info


/* 
--------------------------------------------
checklist for  bronze.crm_prd_info
--------------------------------------------*/

select 
prd_id,
prd_nm
from bronze.crm_prd_info
where  prd_nm != trim(prd_nm)

select prd_cost
from bronze.crm_prd_info
where prd_cost <1 or prd_cost  is null

select distinct prd_line
from bronze.crm_prd_info

select 
prd_start_dt,
prd_end_dt
from bronze.crm_prd_info
where prd_end_dt<prd_start_dt


/* 
--------------------------------------------
checklist for  bronze.crm_sales_details
--------------------------------------------*/

select
nullif(sls_order_dt,0)
from bronze.crm_sales_details
where sls_order_dt<=0 or len(sls_order_dt)!= 8

select
nullif(sls_ship_dt,0)
from bronze.crm_sales_details
where sls_ship_dt<=0 or len(sls_ship_dt)!= 8

select* from bronze.crm_sales_details
where sls_order_dt>sls_ship_dt or sls_order_dt>sls_due_dt

select 
sls_sales as old_sales,
sls_quantity,
sls_price as old_price,

case when sls_sales is null or sls_sales<=0 or sls_sales != sls_quantity*abs(sls_price)
      then  sls_quantity*abs(sls_price)
      else sls_sales
      end sls_sales,

      case when sls_price is null or sls_price<=0 
      then  sls_sales / nullif(sls_quantity,0)
      else sls_price
      end sls_price

from bronze.crm_sales_details

where sls_price is null or sls_price<=0 
    
/* 
--------------------------------------------
checklist for erp_CUST_AZ12
--------------------------------------------*/
select distinct
case when trim(GEN) in ('F', 'Female') then 'Female'
     when trim(GEN) in ('M', 'Male') then 'Male'
     ELSE 'n/a'
     end GEN
from bronze.erp_CUST_AZ12


/* 
--------------------------------------------
checklist for  bronze.erp_LOC_A101
--------------------------------------------*/
SELECT DISTINCT
CNTRY,
CASE WHEN CNTRY IN ('USA','US','United States') then 'United States'
      when CNTRY IN ('DE','Germany') THEN 'germany'
      when CNTRY is null then 'n/a'
      when CNTRY = '' THEN 'n/a'
      ELSE CNTRY 
      END CNRTY

      FROM bronze.erp_LOC_A101

