select cst_id,
	cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status
    cst_gndr,
    cst_create_date
from datawarehouse_silver.crm_cust_info;
select * from datawarehouse_silver.erp_cust_az12;
select * from datawarehouse_silver.erp_loc_a101;

select * from datawarehouse_gold.dim_customers;
select * from datawarehouse_gold.dim_products;
select * from datawarehouse_gold.fact_sales;
