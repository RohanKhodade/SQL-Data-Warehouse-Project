insert into datawarehouse_silver.crm_cust_info(
	cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
select 
	cast(cst_id as unsigned),
    cst_key,
    trim(cst_firstname) as cst_firstname,
    trim(cst_lastname) as cst_lastname,
    case 
		when lower(trim(cst_marital_status))="m" then "Married"
        when lower(trim(cst_marital_status))="s" then "Single"
        else "na"
	end as cst_marital_status,
    case 
		when lower(trim(cst_gndr))="m" then "Male"
        when lower(trim(cst_gndr))="f" then "Female"
        else "na"
	end as cst_gndr,
    str_to_date(cst_create_date,'%Y-%m-%d')as  cst_create_date
from (
	select *,row_number() over (partition by cst_id order by cst_create_date desc) as flag
    from datawarehouse_bronze.crm_cust_info
    where cst_id is not NULL
    ) as t
where flag=1;

-- ========================================================================================================
 --  crm prd_info table
SELECT * FROM datawarehouse_bronze.crm_prd_info;
INSERT INTO datawarehouse_silver.crm_prd_info(
	 prd_id,
     cat_key,
     prd_key,
     prd_nm,
     prd_cost,
     prd_line,
     prd_start_dt,
     prd_end_dt
)
SELECT 
	prd_id,
    REPLACE(SUBSTRING(TRIM(prd_key),1,5),"-","_") AS cat_key,
    SUBSTRING(TRIM(prd_key),7,length(prd_key))as prd_key,
    TRIM(prd_nm) AS prd_nm,
    COALESCE(prd_cost,0) AS prd_cost,
    CASE LOWER(TRIM(prd_line))
		WHEN "r" then "Road"
        when "m" then "Mountain"
        when "s" then "Other Sales"
        when "t" then "Touring"
        else "na"
    END as prd_line,
    CAST(STR_TO_DATE(prd_start_dt,"%Y-%m-%d") AS DATE) as prd_start_dt,
	DATE_SUB(
		CAST(LEAD(CAST(STR_TO_DATE(prd_start_dt,"%Y-%m-%d") AS DATE))
		OVER(PARTITION BY prd_key ORDER BY CAST(STR_TO_DATE(prd_start_dt,"%Y-%m-%d") AS DATE))
        AS DATE),INTERVAL 1 DAY)
        AS prd_end_dt
from (
	SELECT *, ROW_NUMBER() OVER(PARTITION BY prd_id) AS flag
    FROM datawarehouse_bronze.crm_prd_info
    WHERE prd_id IS NOT NULL
    ) AS t
WHERE flag=1;

-- =========================================================================================
-- crm sales table 

SELECT * 
FROM datawarehouse_bronze.crm_sales_details;

INSERT INTO datawarehouse_silver.crm_sales_details(
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)

SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,

    CASE 
        WHEN CAST(NULLIF(TRIM(REPLACE(REPLACE(sls_order_dt, '\r',''), '\n','')), '') AS SIGNED) <= 0 
             OR LENGTH(NULLIF(TRIM(REPLACE(REPLACE(sls_order_dt, '\r',''), '\n','')), '')) != 8 
        THEN NULL
        ELSE STR_TO_DATE(
                NULLIF(TRIM(REPLACE(REPLACE(sls_order_dt, '\r',''), '\n','')), ''), 
                '%Y%m%d'
             )
    END AS sls_order_dt,

    CASE 
        WHEN CAST(NULLIF(TRIM(REPLACE(REPLACE(sls_ship_dt, '\r',''), '\n','')), '') AS SIGNED) <= 0 
             OR LENGTH(NULLIF(TRIM(REPLACE(REPLACE(sls_ship_dt, '\r',''), '\n','')), '')) != 8 
        THEN NULL
        ELSE STR_TO_DATE(
                NULLIF(TRIM(REPLACE(REPLACE(sls_ship_dt, '\r',''), '\n','')), ''), 
                '%Y%m%d'
             )
    END AS sls_ship_dt,

    CASE 
        WHEN CAST(NULLIF(TRIM(REPLACE(REPLACE(sls_due_dt, '\r',''), '\n','')), '') AS SIGNED) <= 0 
             OR LENGTH(NULLIF(TRIM(REPLACE(REPLACE(sls_due_dt, '\r',''), '\n','')), '')) != 8 
        THEN NULL
        ELSE STR_TO_DATE(
                NULLIF(TRIM(REPLACE(REPLACE(sls_due_dt, '\r',''), '\n','')), ''), 
                '%Y%m%d'
             )
    END AS sls_due_dt,

    CASE 
        WHEN NULLIF(TRIM(REPLACE(REPLACE(sls_sales, '\r',''), '\n','')), '') IS NULL
             OR CAST(NULLIF(TRIM(REPLACE(REPLACE(sls_sales, '\r',''), '\n','')), '') AS SIGNED) <= 0
             OR CAST(NULLIF(TRIM(REPLACE(REPLACE(sls_sales, '\r',''), '\n','')), '') AS SIGNED) != 
                CAST(NULLIF(TRIM(REPLACE(REPLACE(sls_quantity, '\r',''), '\n','')), '') AS SIGNED) *
                CAST(NULLIF(TRIM(REPLACE(REPLACE(sls_price, '\r',''), '\n','')), '') AS SIGNED)
        THEN CAST(
                CAST(NULLIF(TRIM(REPLACE(REPLACE(sls_quantity, '\r',''), '\n','')), '') AS SIGNED) *
                ABS(CAST(NULLIF(TRIM(REPLACE(REPLACE(sls_price, '\r',''), '\n','')), '') AS SIGNED))
             AS SIGNED)
        ELSE CAST(NULLIF(TRIM(REPLACE(REPLACE(sls_sales, '\r',''), '\n','')), '') AS SIGNED)
    END AS sls_sales,

    CAST(NULLIF(TRIM(REPLACE(REPLACE(sls_quantity, '\r',''), '\n','')), '') AS SIGNED) AS sls_quantity,

    CASE 
        WHEN CAST(NULLIF(TRIM(REPLACE(REPLACE(sls_price, '\r',''), '\n','')), '') AS SIGNED) <= 0
             OR NULLIF(TRIM(REPLACE(REPLACE(sls_price, '\r',''), '\n','')), '') IS NULL
        THEN CAST(
                CAST(NULLIF(TRIM(REPLACE(REPLACE(sls_sales, '\r',''), '\n','')), '') AS SIGNED) /
                NULLIF(CAST(NULLIF(TRIM(REPLACE(REPLACE(sls_quantity, '\r',''), '\n','')), '') AS SIGNED), 0)
             AS SIGNED)
        ELSE CAST(NULLIF(TRIM(REPLACE(REPLACE(sls_price, '\r',''), '\n','')), '') AS SIGNED)
    END AS sls_price

FROM datawarehouse_bronze.crm_sales_details;


-- ================================================================================================
-- ERP TABLES
-- erp customer info 
select * from datawarehouse_bronze.erp_cust_az12;
INSERT INTO datawarehouse_silver.erp_cust_az12(
	cid,
    bdate,
    gen
)
SELECT 
	CASE 
		WHEN  TRIM(cid) LIKE "NAS%" THEN SUBSTRING(TRIM(cid),4,LENGTH(cid))
        ELSE TRIM(cid)
	END AS cid,
    CASE 
		WHEN STR_TO_DATE(bdate,"%Y-%m-%d")< 1900-01-01 or STR_TO_DATE(bdate,"%Y-%m-%d") > CURRENT_DATE() THEN NULL
        ELSE STR_TO_DATE(bdate,"%Y-%m-%d")
	END AS bdate,
    CASE 
		WHEN LOWER(TRIM(REPLACE(REPLACE(gen, '\r',''), '\n',''))) IN ('f','female') 
			THEN 'Female'
		WHEN LOWER(TRIM(REPLACE(REPLACE(gen, '\r',''), '\n',''))) IN ('m','male') 
			THEN 'Male'
    ELSE 'NA'
END AS gen

FROM datawarehouse_bronze.erp_cust_az12;


-- erp location table
select * from datawarehouse_bronze.erp_loc_a101;
INSERT INTO datawarehouse_silver.erp_loc_a101(
	cid,
    cntry
)
SELECT 
	REPLACE(TRIM(cid),"-","") AS cid,
    CASE 
		WHEN TRIM(REPLACE(REPLACE(cntry,'\n',''),'\r','')) ="DE" THEN "Germany"
        WHEN LOWER(TRIM(REPLACE(REPLACE(cntry,'\n',''),'\r',''))) IN ('us','usa') THEN "United States"
        WHEN cntry IS NULL or TRIM(cntry)='' THEN "na"
        ELSE TRIM(cntry)
	END AS cntry
from datawarehouse_bronze.erp_loc_a101;


-- product cTEGORY
select * from datawarehouse_bronze.erp_px_cat_g1v2;
INSERT INTO datawarehouse_silver.erp_px_cat_g1v2(
	id,
    cat,
    subcat,
    maintenance
)
select
	TRIM(id),
    TRIM(cat) AS cat,
    TRIM(subcat) AS subcat,
	TRIM(maintenance) as maintenance
from  datawarehouse_bronze.erp_px_cat_g1v2;
