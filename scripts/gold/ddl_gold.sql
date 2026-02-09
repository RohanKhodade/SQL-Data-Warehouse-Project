-- create dimension gold.dim_dimensions
DROP VIEW IF EXISTS datawarehouse_gold.dim_customers;
CREATE VIEW datawarehouse_gold.dim_customers as
select 
	ROW_NUMBER() OVER(ORDER BY cst_id) as customer_key,
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
    ci.cst_firstname as customer_firstname,
    ci.cst_lastname as customer_lastname,
	loc.cntry as customer_country,
    ci.cst_marital_status as customer_marital_status,
    CASE 
		WHEN ci.cst_gndr!="na" THEN ci.cst_gndr
        ELSE COALESCE(ca.gen,"na") 
	END as customer_gender,
    ca.bdate as customer_birth_date,
	ci.cst_create_date as customer_create_date
from datawarehouse_silver.crm_cust_info as ci
LEFT JOIN datawarehouse_silver.erp_cust_az12 as ca on ci.cst_key=ca.cid
LEFT JOIN datawarehouse_silver.erp_loc_a101 as loc on ci.cst_key=loc.cid;

-- =====================================================================================================
-- create dimension gold.dim_products
DROP VIEW IF EXISTS datawarehouse_gold.dim_products;
CREATE VIEW datawarehouse_gold.dim_products AS 
select 
	ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt,pn.prd_key) as product_key,
	pn.prd_id as product_id,
    pn.prd_key as product_number,
    pn.prd_nm as product_name,
    pn.cat_key as category_id,
    px.cat as category,
    px.subcat as sub_category,
    px.maintenance as maintenance,
    pn.prd_cost as product_cost,
    pn.prd_line as product_line,
    pn.prd_start_dt as start_date
from datawarehouse_silver.crm_prd_info as pn
LEFT JOIN datawarehouse_silver.erp_px_cat_g1v2 as px on pn.cat_key=px.id
WHERE pn.prd_end_dt IS NULL;
select * from datawarehouse_silver.erp_px_cat_g1v2;
select * from datawarehouse_silver.crm_prd_info;


-- ==============================================
DROP VIEW IF EXISTS datawarehouse_gold.fact_sales;
CREATE VIEW datawarehouse_gold.fact_sales AS
SELECT
    sd.sls_ord_num  AS order_number,
    pr.product_key  AS product_key,
    cu.customer_key AS customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price
FROM datawarehouse_silver.crm_sales_details sd
LEFT JOIN datawarehouse_gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN datawarehouse_gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
