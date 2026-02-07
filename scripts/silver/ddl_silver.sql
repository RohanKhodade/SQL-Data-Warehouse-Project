
/* 
	 Table Schemas for silver layer
*/

use datawarehouse_silver;

DROP TABLE IF EXISTS datawarehouse_silver.crm_cust_info;
CREATE TABLE datawarehouse_silver.crm_cust_info(
	cst_id INT,
    cst_key VARCHAR(100),
    cst_firstname VARCHAR(100),
    cst_lastname VARCHAR(100),
    cst_marital_status VARCHAR(20),
    cst_gndr VARCHAR(20),
    cst_create_date DATE,
    dwh_create_date_time DATETIME DEFAULT CURRENT_TIMESTAMP()
);

-- crm_prd_info table 
select * from datawarehouse_bronze.crm_prd_info;
DROP TABLE If EXISTS datawarehouse_silver.crm_prd_info;
CREATE TABLE datawarehouse_silver.crm_prd_info(
	prd_id INT,
	cat_key VARCHAR(50),
    prd_key VARCHAR(100),
    prd_nm VARCHAR(100),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE,
    dwh_create_date_time DATETIME DEFAULT CURRENT_TIMESTAMP()
);

-- crm_sales_details table

select * from datawarehouse_bronze.crm_sales_details;
DROP TABLE IF EXISTS datawarehouse_silver.crm_sales_details;
CREATE TABLE datawarehouse_silver.crm_sales_details(
	sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT,
    dwh_create_date_time DATETIME DEFAULT CURRENT_TIMESTAMP()
);
-- ===============================================================================

-- ERP Tables

-- erp cust info
select * from datawarehouse_bronze.erp_cust_az12;
DROP TABLE IF EXISTS datawarehouse_silver.erp_cust_az12;
CREATE TABLE datawarehouse_silver.erp_cust_az12(
	cid VARCHAR(100),
    bdate DATE,
    gen VARCHAR(20),
    dwh_create_date_time DATETIME DEFAULT CURRENT_TIMESTAMP()
);

-- erp customer location info
select * from datawarehouse_bronze.erp_loc_a101;
DROP TABLE IF EXISTS datawarehouse_silver.erp_loc_a101;
CREATE TABLE datawarehouse_silver.erp_loc_a101(
	cid VARCHAR(100),
    cntry VARCHAR(100),
	dwh_create_date_time DATETIME DEFAULT CURRENT_TIMESTAMP()
);

-- erp product category info
select * from datawarehouse_bronze.erp_px_cat_g1v2;
DROP TABLE IF EXISTS datawarehouse_silver.erp_px_cat_g1v2;
CREATE TABLE datawarehouse_silver.erp_px_cat_g1v2(
	id VARCHAR(100),
    cat VARCHAR(100),
    subcat VARCHAR(100),
    maintenance VARCHAR(20),
	dwh_create_date_time DATETIME DEFAULT CURRENT_TIMESTAMP()
);
