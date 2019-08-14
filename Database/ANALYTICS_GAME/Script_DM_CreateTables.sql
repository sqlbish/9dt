USE ANALYTICS_GAME;
USE ROLE BI_DBA;
USE WAREHOUSE DT_SMALL;
USE SCHEMA BISHAL_DM;

/* ---------------------------------------------------------------------- */
/* Script generated with: DeZign for Databases V10.0.2                    */
/* Target DBMS:           PostgreSQL 9                                    */
/* Project file:          9DT_DataModel.dez                               */
/* Project name:          9DT Players and Games                                                */
/* Author:                Bishal Gupta                                               */
/* Script type:           Database creation script                        */
/* Created on:            2019-07-31 19:41                                */
/* ---------------------------------------------------------------------- */


/* ---------------------------------------------------------------------- */
/* Add tables                                                             */
/* ---------------------------------------------------------------------- */

/* ---------------------------------------------------------------------- */
/* Add table "DIM_PLAYER"                                                 */
/* ---------------------------------------------------------------------- */

CREATE TABLE IF NOT EXISTS DIM_PLAYER (
    DIMPLAYER_KEY INTEGER AUTOINCREMENT NOT NULL,
    PLAYER_ID CHARACTER VARYING(500),
    FIRST_NAME CHARACTER VARYING(40),
    LAST_NAME CHARACTER VARYING(40),
    EMAIL CHARACTER VARYING(40),
    NATIONALITY CHARACTER VARYING(5),
    CREATE_DATE TIMESTAMP WITH TIME ZONE DEFAULT CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP())  NOT NULL,
    CREATE_BY CHARACTER VARYING(250) DEFAULT CURRENT_USER()  NOT NULL,
    UPDATE_DATE TIMESTAMP WITH TIME ZONE DEFAULT CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP())  NOT NULL,
    UPDATE_BY CHARACTER VARYING(250) DEFAULT CURRENT_USER()  NOT NULL,
    CONSTRAINT PK_DIM_PLAYER PRIMARY KEY (DIMPLAYER_KEY)
);

/* ---------------------------------------------------------------------- */
/* Add table "DIM_GAME"                                                   */
/* ---------------------------------------------------------------------- */

CREATE TABLE IF NOT EXISTS DIM_GAME (
    DIMGAME_KEY INTEGER AUTOINCREMENT NOT NULL,
    GAME_ID CHARACTER VARYING(500),
    CREATE_DATE TIMESTAMP WITH TIME ZONE DEFAULT CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP())  NOT NULL,
    CREATE_BY CHARACTER VARYING(250) DEFAULT CURRENT_USER()  NOT NULL,
    UPDATE_DATE TIMESTAMP WITH TIME ZONE DEFAULT CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP())  NOT NULL,
    UPDATE_BY CHARACTER VARYING(250) DEFAULT CURRENT_USER()  NOT NULL,
    CONSTRAINT PK_DIM_GAME PRIMARY KEY (DIMGAME_KEY)
);

/* ---------------------------------------------------------------------- */
/* Add table "DIM_RESULT"                                                 */
/* ---------------------------------------------------------------------- */

CREATE TABLE IF NOT EXISTS DIM_RESULT (
    DIMRESULT_KEY INTEGER AUTOINCREMENT NOT NULL,
    RESULT CHARACTER VARYING(5),
    CREATE_DATE TIMESTAMP WITH TIME ZONE DEFAULT CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP())  NOT NULL,
    CREATE_BY CHARACTER VARYING(250) DEFAULT CURRENT_USER()  NOT NULL,
    UPDATE_DATE TIMESTAMP WITH TIME ZONE DEFAULT CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP())  NOT NULL,
    UPDATE_BY CHARACTER VARYING(250) DEFAULT CURRENT_USER()  NOT NULL,
    CONSTRAINT PK_DIM_RESULT PRIMARY KEY (DIMRESULT_KEY)
);

COMMENT ON COLUMN DIM_RESULT.RESULT IS 'Game Results for Example Win and Draw';

/* ---------------------------------------------------------------------- */
/* Add table "FACT_GAME"                                                  */
/* ---------------------------------------------------------------------- */

CREATE TABLE IF NOT EXISTS FACT_GAME (
    FACT_GAME_KEY INTEGER AUTOINCREMENT NOT NULL,
    DIMGAME_KEY INTEGER,
    DIMPLAYER_KEY INTEGER,
    MOVE_NUMBER INTEGER,
    COLUMN_NUMBER INTEGER,
    CREATE_DATE TIMESTAMP WITH TIME ZONE DEFAULT CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP())  NOT NULL,
    CREATE_BY CHARACTER VARYING(250) DEFAULT CURRENT_USER()  NOT NULL,
    UPDATE_DATE TIMESTAMP WITH TIME ZONE DEFAULT CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP())  NOT NULL,
    UPDATE_BY CHARACTER VARYING(250) DEFAULT CURRENT_USER()  NOT NULL,
    CONSTRAINT PK_FACT_GAME PRIMARY KEY (FACT_GAME_KEY)
);

/* ---------------------------------------------------------------------- */
/* Add table "FACT_RESULT"                                                */
/* ---------------------------------------------------------------------- */

CREATE TABLE IF NOT EXISTS FACT_RESULT (
    FACT_RESULT_KEY INTEGER AUTOINCREMENT NOT NULL,
    DIMGAME_KEY INTEGER,
    DIMRESULT_KEY INTEGER,
    CREATE_DATE TIMESTAMP WITH TIME ZONE DEFAULT CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP())  NOT NULL,
    CREATE_BY CHARACTER VARYING(250) DEFAULT CURRENT_USER()  NOT NULL,
    UPDATE_DATE TIMESTAMP WITH TIME ZONE DEFAULT CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP())  NOT NULL,
    UPDATE_BY CHARACTER VARYING(250) DEFAULT CURRENT_USER()  NOT NULL,
    CONSTRAINT PK_FACT_RESULT PRIMARY KEY (FACT_RESULT_KEY)
);

/* ---------------------------------------------------------------------- */
/* Add foreign key constraints                                            */
/* ---------------------------------------------------------------------- */

ALTER TABLE FACT_GAME ADD CONSTRAINT DIM_GAME_FACT_GAME 
    FOREIGN KEY (DIMGAME_KEY) REFERENCES DIM_GAME (DIMGAME_KEY);

ALTER TABLE FACT_GAME ADD CONSTRAINT DIM_PLAYER_FACT_GAME 
    FOREIGN KEY (DIMPLAYER_KEY) REFERENCES DIM_PLAYER (DIMPLAYER_KEY);

ALTER TABLE FACT_RESULT ADD CONSTRAINT DIM_GAME_FACT_RESULT 
    FOREIGN KEY (DIMGAME_KEY) REFERENCES DIM_GAME (DIMGAME_KEY);

ALTER TABLE FACT_RESULT ADD CONSTRAINT DIM_RESULT_FACT_RESULT 
    FOREIGN KEY (DIMRESULT_KEY) REFERENCES DIM_RESULT (DIMRESULT_KEY);
