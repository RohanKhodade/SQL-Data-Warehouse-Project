
select * from datawarehouse_bronze.erp_px_cat_g1v2;
select * from datawarehouse_bronze.crm_sales_details;

-- ===========================================================================================================

select * from datawarehouse_silver.crm_cust_info;
select * from (
	select *, 
		row_number() over (partition by cst_id order by cst_create_date) as flag
	from datawarehouse_silver.crm_cust_info
	where cst_id is not NULL
	) as t
where flag !=1;

select cst_firstname 
from datawarehouse_silver.crm_cust_info
where cst_firstname!=trim(cst_firstname);

select cst_lastname 
from datawarehouse_silver.crm_cust_info
where cst_lastname!=trim(cst_lastname);

select distinct cst_marital_status
from datawarehouse_silver.crm_cust_info;

select distinct cst_gndr
from datawarehouse_silver.crm_cust_info;

-- ===============================================================================================
-- checking for crm_prd_info table 

select * from datawarehouse_bronze.crm_prd_info;

select * from
	( select * , row_number() over(partition by prd_id order by prd_end_dt) as flag
	from datawarehouse_bronze.crm_prd_info 
    where prd_id is not null
     ) as t
where flag=1;

select substring(prd_key,1,5) as cat_key 
from datawarehouse_bronze.crm_prd_info;

select substring(trim(prd_key),7,length(prd_key)) as prd_key
from datawarehouse_bronze.crm_prd_info;
-- validation checks on datawarehouse_silver.crm_prd_info layer;
select * from datawarehouse_silver.crm_prd_info;
select prd_id,count(*) from datawarehouse_silver.crm_prd_info group by prd_id having count(*)>1 or prd_id is null;
select * from datawarehouse_silver.crm_prd_info where prd_cost<0 or prd_cost is null;
select distinct prd_line from datawarehouse_silver.crm_prd_info;
select * from datawarehouse_silver.crm_prd_info where prd_start_dt>prd_end_dt;


-- ==========================================================================================================================================
-- crm_sales_details
select * from datawarehouse_bronze.crm_sales_details ;

select * from datawarehouse_bronze.crm_sales_details
where sls_cust_id not in (select cst_id from datawarehouse_silver.crm_cust_info);

select prd_key from datawarehouse_silver.crm_prd_info;


select sls_ord_num, count(*) from datawarehouse_bronze.crm_sales_details 
group by sls_ord_num
having count(*)>1 or sls_ord_num is null;


select sls_order_dt from datawarehouse_bronze.crm_sales_details 
where CAST(sls_order_dt AS SIGNED) <=0  or LENGTH(sls_order_dt) !=8;
select * from 
(
	select 
		CASE 
			WHEN CAST(sls_order_dt AS SIGNED) <=0 OR LENGTH(sls_order_dt)!=8 THEN NULL
			else CAST(sls_order_dt AS DATE)
		end AS sls_order_dt
	from datawarehouse_bronze.crm_sales_details
) as t
where sls_order_dt IS NULL;


select CAST(sls_sales AS SIGNED) 
from datawarehouse_bronze.crm_sales_details 
where CAST(sls_sales AS SIGNED)<=0;

select sls_sales
from datawarehouse_bronze.crm_sales_details 
where sls_sales<=0;

select * from datawarehouse_bronze.crm_sales_details
where CAST(sls_order_dt AS DATE)> CAST(sls_ship_dt AS DATE) OR CAST(sls_order_dt AS DATE) > CAST(sls_due_dt AS DATE);

select * from datawarehouse_silver.crm_sales_details; 


-- ================================================================================================
-- ERP TABLES
select 
	SUBSTRING(TRIM(cid),4,length(cid))
from datawarehouse_bronze.erp_cust_az12;

select 
	STR_TO_DATE(bdate,"%Y-%m-%d") as birth
from datawarehouse_bronze.erp_cust_az12
where STR_TO_DATE(bdate,"%Y-%m-%d") <= 1900-01-01 or STR_TO_DATE(bdate,"%Y-%m-%d") > CURRENT_DATE();

select DISTINCT gen 
from datawarehouse_bronze.erp_cust_az12;
select * from datawarehouse_silver.erp_cust_az12;

-- erp location 

select distinct cntry from datawarehouse_bronze.erp_loc_a101
order by cntry;

select * from  datawarehouse_bronze.erp_px_cat_g1v2;
select distinct cat from  datawarehouse_bronze.erp_px_cat_g1v2;
select distinct subcat from  datawarehouse_bronze.erp_px_cat_g1v2;
select distinct maintenance from  datawarehouse_bronze.erp_px_cat_g1v2;
select * from  datawarehouse_silver.erp_px_cat_g1v2;
