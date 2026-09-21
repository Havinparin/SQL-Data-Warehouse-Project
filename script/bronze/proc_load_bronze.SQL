/*
=============================================================================
stored procedure: Load Bronze Layer 
=============================================================================

 sctript purpose:
 This stored procedure loads data into the 'bronze' schema from external CSV files
    - trancates the bronz tales before loading data
	-uses 'BULK INSERT' command to load data from CSV files to bronze tables
	parameters: 
	    NONE
		
	Usage example:
	     exec bronze.load_bronzer

 ==============================================================================
		 */


CREATE OR ALTER PROCEDURE bronze.load_bronzer as
begin
   

		begin try

		print '==========================================';
		print 'loading the bronze layer';
		print '==========================================';
		
		print '------------------------------------------';
		print 'loading crm tables';
		print '------------------------------------------';
		truncate table bronze.crm_cust_info;
		BULK insert bronze.crm_cust_info
		from 'C:\Users\Casper\Desktop\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
	

		truncate table bronze.crm_prd_info;
		BULK insert bronze.crm_prd_info
		from 'C:\Users\Casper\Desktop\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);

		truncate table bronze.crm_sales_details;
		BULK insert bronze.crm_sales_details
		from 'C:\Users\Casper\Desktop\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);

		print '------------------------------------------';
		print 'loading erp tables';
		print '------------------------------------------';

		truncate table bronze.erp_CUST_AZ12;
		BULK insert bronze.erp_CUST_AZ12
		from 'C:\Users\Casper\Desktop\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);

		truncate table bronze.erp_LOC_A101;
		BULK insert bronze.erp_LOC_A101
		from 'C:\Users\Casper\Desktop\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);

		truncate table bronze.erp_PX_VAT_G1V2;
		BULK insert bronze.erp_PX_VAT_G1V2
		from 'C:\Users\Casper\Desktop\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);

		end try

begin catch
print '==================================='
print 'ERROR OCCURED DURING LOADING BRONZE LAYER'
print 'Error message' + error_message();
print '==================================='
end catch

end 
