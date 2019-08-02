USE ODS_DEV;
USE ROLE BI_DBA;
USE SCHEMA BISHAL_DM;
USE WAREHOUSE PINNACLES;


--Query #1 Out of all the games, what is the percentile rank of each column used as the ?rst move in a game? 
--That is, when the ?rst player is choosing a column for their ?rst move, which column most frequently leads to that player winning the game? 
CREATE VIEW IF NOT EXISTS BISHAL_DM.VW_RankBy_WinningColumn_FirstMove
AS
SELECT  FG.COLUMN_NUMBER, 
        COUNT(*) as CntofFirstMove, 
        RANK() OVER (ORDER BY COUNT(*) DESC) AS Rank
        FROM BISHAL_DM.FACT_GAME FG
JOIN BISHAL_DM.FACT_RESULT FR
        ON FG.DIMGAME_KEY = FR.DIMGAME_KEY
JOIN BISHAL_DM.DIM_RESULT DR
        ON FR.DIMRESULT_KEY = DR.DIMRESULT_KEY
WHERE DR.RESULT = 'win'
        AND FG.MOVE_NUMBER = 1
GROUP BY FG.COLUMN_NUMBER
ORDER BY RANK;


--Query #2, How many games has each nationality participated in? \
CREATE VIEW IF NOT EXISTS BISHAL_DM.VW_Count_of_GamesPlayed_ByNationality
AS
SELECT 
        DP.NATIONALITY,
        COUNT(DISTINCT DG.GAME_ID) as CountofGamesParticipated
 FROM BISHAL_DM.FACT_GAME FG
 JOIN BISHAL_DM.DIM_GAME DG
        ON FG.DIMGAME_KEY = DG.DIMGAME_KEY
 JOIN BISHAL_DM.DIM_PLAYER DP
        ON FG.DIMPLAYER_KEY = DP.DIMPLAYER_KEY
 GROUP BY DP.NATIONALITY
 ORDER BY DP.NATIONALITY; 
 
 
 
 --Query #3.Marketing wants to send emails to players that have only played a single game. 
 --The email will be customized based on whether or not the player won, lost, or drew the game. Which players should receive an email, and with what customization? 
CREATE VIEW IF NOT EXISTS BISHAL_DM.VW_Players_Played_SingleGame
SELECT 
        DISTINCT
        PG.FIRST_NAME,
        PG.LAST_NAME,
        PG.EMAIL,
        IFNULL(DR.RESULT,'lost') as Game_Result

FROM 
        ( 
        SELECT  --Get the player info that have only played single game
                DP.DIMPLAYER_KEY,
                DP.PLAYER_ID, 
                DP.FIRST_NAME,
                DP.LAST_NAME,
                DP.EMAIL     
               FROM BISHAL_DM.DIM_PLAYER DP
        JOIN BISHAL_DM.FACT_GAME FG 
                ON DP.DIMPLAYER_KEY = FG.DIMPLAYER_KEY
        JOIN BISHAL_DM.DIM_GAME DG
                ON FG.DIMGAME_KEY = DG.DIMGAME_KEY   
        GROUP BY  
                DP.DIMPLAYER_KEY,
                DP.PLAYER_ID, 
                DP.FIRST_NAME,
                DP.LAST_NAME,
                DP.EMAIL
        HAVING COUNT(distinct DG.GAME_ID) = 1     
        )PG   
LEFT JOIN (SELECT * FROM BISHAL_DM.FACT_GAME FG1 --Get the GameKey/GameId row from the game fact table with max mover_number, this row tells the game result
                    WHERE MOVE_NUMBER =
                       ( SELECT MAX(MOVE_NUMBER) FROM  BISHAL_DM.FACT_GAME FG2
                          WHERE FG1.DIMGAME_KEY = FG2.DIMGAME_KEY)
                          AND FG1.DIMGAME_KEY) FG
ON PG.DIMPLAYER_KEY = FG.DIMPLAYER_KEY
LEFT JOIN BISHAL_DM.FACT_RESULT FR
ON FG.DIMGAME_KEY = FR.DIMGAME_KEY
LEFT JOIN BISHAL_DM.DIM_RESULT DR
ON FR.DIMRESULT_KEY = DR.DIMRESULT_KEY
ORDER BY PG.FIRST_NAME, PG.LAST_NAME;

 