USE ODS_DEV;
USE ROLE BI_DBA;
USE SCHEMA BISHAL_TEST;
USE WAREHOUSE PINNACLES;

--Create S3 stage poiting to the AWS S3 bucket location
--This is where the game_data.csv file lives and is the starting point of this load
CREATE STAGE IF NOT EXISTS BISHAL_TEST.BISHAL_STAGE URL='s3://98point6' 
CREDENTIALS=(AWS_KEY_ID='AKIAI63D7ZTJCJC2XKRA' AWS_SECRET_KEY='<Get from AWS Portal>') 

--Create staging table in Snowflake Database to stage the game_data.csv data imported from the AWS s3 stage
CREATE TABLE IF NOT EXISTS BISHAL_TEST.DTG_STAGING (GAME_ID VARCHAR(500), PLAYER_ID VARCHAR(500), MOVE_NUMBER INT,COLUMN_NUMBER SMALLINT,RESULT VARCHAR(5));

--Clean up the previous session data
TRUNCATE TABLE BISHAL_TEST.DTG_STAGING

--Now import the game_data.csv using the copy into/S3 Load snowflake sqnosql command to import the data into the staging table
COPY INTO BISHAL_TEST.DTG_STAGING 
FROM @BISHAL_TEST.BISHAL_STAGE
PATTERN='(?i).*game_data.*.csv'
FILE_FORMAT= (
	TYPE=CSV
	SKIP_HEADER = 1
	COMPRESSION=AUTO,
	TRIM_SPACE=FALSE,
	ERROR_ON_COLUMN_COUNT_MISMATCH=FALSE,
	EMPTY_FIELD_AS_NULL=TRUE
)
ON_ERROR='skip_file'
PURGE=FALSE
TRUNCATECOLUMNS=FALSE
FORCE=FALSE;

--Create S3 stage poiting to the AWS S3 bucket location
--This is where the player data JSON will be staged after it is downloaded from the get api requests
CREATE OR REPLACE STAGE BISHAL_TEST.BISHAL_STAGE URL='s3://98point6' 
CREDENTIALS=(AWS_KEY_ID='AKIAI63D7ZTJCJC2XKRA' AWS_SECRET_KEY='<Get from AWS Portal>') 

--Create JSON file format to be used to import the player json file into a sql variant staging table
CREATE FILE FORMAT IF NOT EXISTS "ODS_DEV"."BISHAL_TEST".FORMAT_NDJSON TYPE = 'JSON' COMPRESSION = 'AUTO' ENABLE_OCTAL = FALSE ALLOW_DUPLICATE = FALSE STRIP_OUTER_ARRAY = FALSE STRIP_NULL_VALUES = FALSE IGNORE_UTF8_ERRORS = FALSE COMMENT = 'File format for importing Semi-Structured data into Snowfake';

--Create staging table in Snowflake Database to stage the player json data as variant type imporrted from the AWS s3 stage
CREATE TABLE IF NOT EXISTS BISHAL_TEST.PLAYER_PROFILE_JSON (JSON VARIANT);

--Clean up previous sessions data
TRUNCATE TABLE BISHAL_TEST.PLAYER_PROFILE_JSON;

--Now import the player JSON data using snowflake sqnosql parse json command to import the data into the staging table
INSERT INTO BISHAL_TEST.PLAYER_PROFILE_JSON
SELECT T.VALUE FROM @BISHAL_TEST.BISHAL_STAGE/player_profile.json (file_format => 'FORMAT_NDJSON') as S, table(flatten(S.$1,'')) T;

--Create a staging table to stage the flattened JSON player data
CREATE TABLE IF NOT EXISTS BISHAL_TEST.PLAYER_PROFILE_STAGING
(
  PLAYER_ID VARCHAR(500),
  FIRST_NAME VARCHAR(100),
  LAST_NAME VARCHAR(100),
  GENDER VARCHAR(10),
  DOB TIMESTAMP WITH TIME ZONE,
  EMAIL VARCHAR(100),
  PHONENUMBER VARCHAR(40),
  CELLNUMBER VARCHAR(40),
  NATIONALITY VARCHAR(5),
  REGISTERED_DATE TIMESTAMP WITH TIME ZONE,
  USERNAME VARCHAR(40)
  
);

--Clean up previous session data
TRUNCATE TABLE BISHAL_TEST.PLAYER_PROFILE_STAGING;

--Flatten/Parse the JSON data into structured data and import into the staging table
INSERT INTO BISHAL_TEST.PLAYER_PROFILE_STAGING
SELECT 
  JSON:id::int as Player_Id,
  JSON:data.name.first::varchar as First_Name,
  JSON:data.name.last::varchar as Last_Name,
  JSON:data.gender::varchar as Gender,
  JSON:data.dob::varchar as Dob,
  JSON:data.email::varchar as Email,
  JSON:data.phone::varchar as PhoneNumber,
  JSON:data.cell::varchar as CellNumber,
  JSON:data.nat::varchar as Nationality,
  JSON:data.registered::varchar as RegisteredDate,
  JSON:data.login.username::varchar as UserName
FROM BISHAL_TEST.PLAYER_PROFILE_JSON;