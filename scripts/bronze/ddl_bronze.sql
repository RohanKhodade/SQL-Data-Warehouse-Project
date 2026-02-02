/*
DDL Script : Create tables into bronze layers
purpose : THis script create tables into database datawarehouse_bronze 
			Existing tables are dropped and recreated

*/

USE datawarehouse_bronze;

-- CRM CUSTOMER INFO TABLE

DROP TABLE IF EXISTS crm_cust_info;
CREATE TABLE crm_cust_info(
	cst_id VARCHAR(50),
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date VARCHAR(50)
    );

-- CRM PRODUCT INFO TABLE 

DROP TABLE IF EXISTS crm_prd_info;
CREATE TABLE crm_prd_info(
	prd_id VARCHAR(50),
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost VARCHAR(50),
    prd_line VARCHAR(50),
    prd_start_dt VARCHAR(50),
    prd_end_dt VARCHAR(50)
	);

-- CRM SALES DETAILS TABLE

DROP TABLE IF EXISTS crm_sales_details;
CREATE TABLE crm_sales_details(
	sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id VARCHAR(50),
    sls_order_dt VARCHAR(50),
    sls_ship_dt VARCHAR(50),
    sls_due_dt VARCHAR(50),
    sls_sales VARCHAR(50),
    sls_quantity VARCHAR(50),
    sls_price VARCHAR(50)
	);
    
-- ==========================
 -- ERP LOCATION
 -- =========================
 
DROP TABLE IF EXISTS erp_cust_az12;
CREATE TABLE erp_cust_az12(
	cid VARCHAR(50),
    bdate VARCHAR(50),
    gen VARCHAR(50)
	);

 DROP TABLE IF EXISTS erp_loc_a101;
 CREATE TABLE erp_loc_a101(
	cid VARCHAR(50),
    cntry VARCHAR(50)
    );
    
-- ERP CUstomer


    
-- ERP Product Category
DROP TABLE IF EXISTS erp_px_cat_g1v2;
CREATE TABLE erp_px_cat_g1v2(
	id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50)
    );
    
