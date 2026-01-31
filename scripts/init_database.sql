-- This scrit is for creating three databases in mysql 
/* bronze layer 
	silver 
    gold
    we need different databases for each layer (since we are working in mysql)
    */

-- Drop and recreate the databases


-- Bronze layer
DROP DATABASE IF EXISTS datawarehouse_bronze;
CREATE DATABASE datawarehouse_bronze;

-- Silver Layer
DROP DATABASE IF EXISTS datawarehouse_silver;
CREATE DATABASE datawarehouse_silver;

-- Gold Layer
DROP DATABASE IF EXISTS datawarehouse_gold;
CREATE DATABASE datawarehouse_gold;

-- now all the layers databases are created we will use it in next scripts
