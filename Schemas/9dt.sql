--THE NEXT THREE LINES SHOULD BE CONFIGURABLE ON THE COMMAND LINE
USE ROLE BI_DBA;
USE WAREHOUSE DBA;

USE DATABASE ANALYTICS_GAME;
CREATE SCHEMA IF NOT EXISTS BISHAL_TEST;
GRANT OWNERSHIP ON SCHEMA BISHAL_TEST TO ROLE BI_DBA;

CREATE SCHEMA IF NOT EXISTS BISHAL_DM;
GRANT OWNERSHIP ON SCHEMA BISHAL_DM TO ROLE BI_DBA;

