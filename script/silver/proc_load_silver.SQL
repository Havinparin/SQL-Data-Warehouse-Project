/*
===================================================================
Stored Procedure: Load Silver Layer (bronze --> silver)
===================================================================
script purpose:
    this stored procedure performs ETL (Extract, Transfrom, Load) process to populate the 'silver'
    schema tables from the 'bronze' schema

actions performed:
     -Truncates Silver tables,
     - Inserts transformed and cleaned data from bronze to silver tables


Usage Example;
      EXEC silver.load_silver
====================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver as
begin 
            
            TRUNCATE TABLE silver.crm_cust_info
            insert into silver.crm_cust_info (
            cst_id,
            cst_key,
            cst_firstname,
            cst_lastname,
            cst_gndr,
            cst_marital_status,
            cst_create_date)

            select 
            cst_id,
            cst_key,
            trim(cst_firstname) as cst_firstname,
            trim (cst_lastname) as cst_lastname,

            case when upper(trim(cst_gndr))='F' then 'Female'
                 when upper(trim(cst_gndr))='M' then 'Male'
                 else 'n/a'
                 end cst_gndr,
            case when trim(cst_marital_status)='S' then 'Single'
                 when trim(cst_marital_status)='M' then 'Married'
                 else 'n/a'
                 end cst_marital_status,
                 cst_create_date
            from (

            select
            *,
            row_number() over (partition by cst_id order by cst_create_date desc)as flag_last
            from bronze.crm_cust_info
            where cst_id is not null
            )t
            where flag_last = 1

            TRUNCATE TABLE silver.crm_sales_details
            insert into silver.crm_sales_details(
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            sls_order_dt,
            sls_ship_dt,
            sls_due_dt,
            sls_sales,
            sls_price,
            sls_quantity
            )
            select
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
 
            case when sls_order_dt = 0 or len(sls_order_dt)!= 8 then null
            else cast(cast(sls_order_dt as varchar) as date)
            end sls_order_dt,

            case when sls_ship_dt = 0 or len(sls_ship_dt)!= 8 then null
            else cast(cast(sls_ship_dt as varchar) as date)
            end sls_ship_dt,

            case when sls_due_dt = 0 or len(sls_due_dt)!= 8 then null
            else cast(cast(sls_due_dt as varchar) as date)
            end sls_due_dt,

            case when sls_sales is null or sls_sales<=0 or sls_sales != sls_quantity*abs(sls_price)
                  then  sls_quantity*abs(sls_price)
                  else sls_sales
                  end sls_sales,

                  case when sls_price is null or sls_price<=0 
                  then  sls_sales / nullif(sls_quantity,0)
                  else sls_price
                  end sls_price,

            sls_quantity
            from bronze.crm_sales_details
            TRUNCATE TABLE silver.erp_CUST_AZ12
            INSERT INTO silver.erp_CUST_AZ12(
            CID,
            BDATE,
            GEN )

            select
            case when CID like 'NAS%' then substring(CID,4,len(CID))
                 else CID
                 end CID,
            CASE WHEN BDATE<'1924-01-01' OR BDATE>GETDATE() THEN NULL
                 ELSE BDATE
                 END BDATE,   
            case when trim(GEN) in ('F', 'Female') then 'Female'
                 when trim(GEN) in ('M', 'Male') then 'Male'
                 ELSE 'n/a'
                 end GEN
            from bronze.erp_CUST_AZ12

            TRUNCATE TABLE silver.erp_LOC_A101
            INSERT into silver.erp_LOC_A101(CID,CNTRY)

            SELECT 
            replace(CID,'-','') AS CID,
            CASE WHEN CNTRY IN ('USA','US','United States') then 'United States'
                  when CNTRY IN ('DE','Germany') THEN 'germany'
                  when CNTRY is null then 'n/a'
                  when CNTRY = '' THEN 'n/a'
                  ELSE CNTRY 
                  END CNRTY
            FROM bronze.erp_LOC_A1

            TRUNCATE TABLE silver.crm_prd_info
            insert into silver.crm_prd_info(
            prd_id,
            category_id,
            prd_key,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_dt,
            prd_end_dt
            )
            select 
            prd_id,
            replace(SUBSTRING(prd_key,1,5), '-', '_') as category_id,
            replace(SUBSTRING(prd_key,7,len(prd_key)), '-', '_') as prd_key,
            prd_nm,
            isnull(prd_cost,0) as prd_cost,
            case when upper(trim(prd_line))='M' then 'Mountain'
                 when upper(trim(prd_line))='R' then 'Road'
                 when upper(trim(prd_line))='S' then 'Other Sales'
                 when upper(trim(prd_line))='T' then 'Touring'
                 else 'n/a'
                 end prd_line,
            cast(prd_start_dt as date) as prd_start_dt,
            cast(lead(prd_start_dt) over (partition by prd_key order by prd_start_dt)-1 as date) prd_end_dt
            from bronze.crm_prd_info

            TRUNCATE TABLE silver.erp_PX_VAT_G1V2
            insert into silver.erp_PX_VAT_G1V2(ID,CAT,SUBCAT,MAINTENANCE)

            select 
            ID,
            CAT,
            SUBCAT,
            MAINTENANCE
            from bronze.erp_PX_VAT_G1V2
end
