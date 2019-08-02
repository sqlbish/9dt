USE ROLE SYSADMIN;

CREATE OR REPLACE WAREHOUSE DT_SMALL 
WITH 
	WAREHOUSE_SIZE = 'SMALL' 
	WAREHOUSE_TYPE = 'STANDARD' 
	AUTO_SUSPEND = 600 
	AUTO_RESUME = TRUE 
	MIN_CLUSTER_COUNT = 1 
	MAX_CLUSTER_COUNT = 2 
	SCALING_POLICY = 'STANDARD';
	
ALTER WAREHOUSE "DT_SMALL" SUSPEND;	
GRANT OWNERSHIP ON WAREHOUSE DT_SMALL TO ROLE BI_DBA;