/*
	=======================================================
    purpose: 
		 used to load the data from external csv files into tables of bronze layers
	actions:
		truncates the bronze tables before inserting data from csv files
        uses "load data infile " command to load data
*/

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

show variables like "secure_file_priv";


use datawarehouse_bronze;
-- CRM TABLEs
	TRUNCATE TABLE datawarehouse_bronze.crm_cust_info;
--     LOAD DATA LOCAL INFILE 'C:\Users\HP\OneDrive\Desktop\Data warehouse project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/datawarehouse_project/source_crm/cust_info.csv'
    INTO TABLE datawarehouse_bronze.crm_cust_info
    FIELDS TERMINATED BY ","
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY "\n"
    IGNORE 1 ROWS
    (
		@cst_id ,
		@cst_key ,
		@cst_firstname,
		@cst_lastname ,
		@cst_marital_status ,
		@cst_gndr ,
		@cst_create_date
	)
    SET
		cst_id=NULLIF(@cst_id,''),
        cst_key=NULLIF(@cst_key,''),
        cst_firstname=NULLIF(@cst_firstname,''),
        cst_lastname=NULLIF(@cst_lastname,''),
        cst_marital_status=NULLIF(@cst_marital_status,''),
        cst_gndr=NULLIF(@cst_gndr,''),
        cst_create_date=NULLIF(@cst_create_date,'')
        ;
        
-- 	select * from datawarehouse_bronze.crm_cust_info;

    TRUNCATE TABLE datawarehouse_bronze.crm_prd_info;
    LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/datawarehouse_project/source_crm/prd_info.csv"
    INTO TABLE datawarehouse_bronze.crm_prd_info
    FIELDS TERMINATED BY ","
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY "\n"
    IGNORE 1 ROWS
    (
		@prd_id ,
		@prd_key ,
		@prd_nm ,
		@prd_cost ,
		@prd_line ,
		@prd_start_dt ,
		@prd_end_dt
		)
	SET
		prd_id=NULLIF(@prd_id,''),
		prd_key=NULLIF(@prd_key,''),
        prd_nm=NULLIF(@prd_nm,''),
        prd_cost=NULLIF(@prd_cost,''),
        prd_line=NULLIF(@prd_line,''),
        prd_start_dt=NULLIF(@prd_start_dt,''),
        prd_end_dt=NULLIF(@prd_end_dt,'')
    ;
    
    TRUNCATE TABLE datawarehouse_bronze.crm_sales_details;
    LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/datawarehouse_project/source_crm/sales_details.csv"
    INTO TABLE datawarehouse_bronze.crm_sales_details
    FIELDS TERMINATED BY ","
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY "\n"
    IGNORE 1 ROWS
    (
		@sls_ord_num ,
		@sls_prd_key ,
		@sls_cust_id ,
		@sls_order_dt ,
		@sls_ship_dt ,
		@sls_due_dt ,
		@sls_sales,
		@sls_quantity,
		@sls_price
        )
	SET
		sls_ord_num=NULLIF(@sls_ord_num,''),
        sls_prd_key=NULLIF(@sls_prd_key,''),
        sls_cust_id=NULLIF(@sls_cust_id,''),
        sls_order_dt=NULLIF(@sls_order_dt,''),
        sls_ship_dt=NULLIF(@sls_ship_dt,''),
        sls_due_dt=NULLIF(@sls_due_dt,''),
        sls_sales=NULLIF(@sls_sales,''),
        sls_quantity=NULLIF(@sls_quantity,''),
        sls_price=NULLIF(@sls_price,'')
    ;
    
-- ==================================================================================================
-- ERP TABLES
	
    TRUNCATE TABLE datawarehouse_bronze.erp_cust_az12;
    LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/datawarehouse_project/source_erp/CUST_AZ12.csv"
    INTO TABLE datawarehouse_bronze.erp_cust_az12
    FIELDS TERMINATED BY ","
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY "\n"
    IGNORE 1 ROWS
    (
		@cid,
        @bdate,
        @gen
        )
	SET
		cid=NULLIF(@cid,''),
        bdate=NULLIF(@bdate,''),
        gen=NULLIF(@gen,'')
        ;
    
    
	TRUNCATE TABLE datawarehouse_bronze.erp_loc_a101;
    LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/datawarehouse_project/source_erp/LOC_A101.csv"
    INTO TABLE datawarehouse_bronze.erp_loc_a101
    FIELDS TERMINATED BY ","
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY "\n"
    IGNORE 1 ROWS
    (
		@cid,
        @cntry
        )
	SET
		cid=NULLIF(@cid,''),
        cntry=NULLIF(@cntry,'')
	;
    
    TRUNCATE TABLE datawarehouse_bronze.erp_px_cat_g1v2;
    LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/datawarehouse_project/source_erp/PX_CAT_G1V2.csv"
    INTO TABLE datawarehouse_bronze.erp_px_cat_g1v2
    FIELDS TERMINATED BY ","
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY "\n"
    IGNORE 1 ROWS
	(
		@id ,
		@cat,
		@subcat ,
		@maintenance
    )
    SET
		id=NULLIF(@id,''),
        cat=NULLIF(@cat,''),
        subcat=NULLIF(@subcat,''),
        maintenance=NULLIF(@maintenance,'')
    ;
