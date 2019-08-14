/********************
**Create Database in Snowflake if not exists
*********************/

CREATE DATABASE IF NOT EXISTS ANALYTICS_GAME;

GRANT USAGE ON DATABASE ANALYTICS_GAME TO ROLE ROLE BI_DBA;