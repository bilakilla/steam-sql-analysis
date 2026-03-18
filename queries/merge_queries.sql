.headers ON
.mode csv
 
-- Merge all queries to per-game granularity
 
-- Count how many users purchased each game
CREATE TEMP TABLE game_purchasers AS
SELECT game, COUNT(DISTINCT user_id) AS total_purchasers
FROM steam_data
WHERE behaviour = 'purchase'
GROUP BY game;
 
 -- Count how many users played each game
CREATE TEMP TABLE game_players AS
SELECT game, COUNT(DISTINCT user_id) AS total_players
FROM steam_data
WHERE behaviour = 'play'
GROUP BY game;
 
 -- Create table with total playtime and average playtime per player, per game
CREATE TEMP TABLE game_playtime AS
SELECT game,
    SUM(user_playtime) AS total_playtime,
    AVG(user_playtime) AS avg_playtime_per_player
FROM (
    SELECT user_id, game, SUM(playtime) AS user_playtime
    FROM steam_data
    WHERE behaviour = 'play'
    GROUP BY user_id, game
)
GROUP BY game;
 
-- Create table with users who both purchased + played per game
CREATE TEMP TABLE game_converted AS
SELECT game, COUNT(*) AS purchased_and_played
FROM (
    SELECT user_id, game
    FROM steam_data
    WHERE behaviour IN ('purchase', 'play')
    GROUP BY user_id, game
    HAVING COUNT(DISTINCT behaviour) = 2
)
GROUP BY game;
 
.once data/merged_queries_per_game.csv
 
SELECT
    p.game,
    p.total_purchasers,
    COALESCE(pl.total_players, 0) AS total_players,
    COALESCE(pt.total_playtime, 0) AS total_playtime,
    COALESCE(pt.avg_playtime_per_player, 0) AS avg_playtime_per_player,
    ROUND(
        100.0 * COALESCE(c.purchased_and_played, 0) / p.total_purchasers,
        2
    ) AS conversion_rate
FROM game_purchasers p
LEFT JOIN game_players   pl ON p.game = pl.game
LEFT JOIN game_playtime  pt ON p.game = pt.game
LEFT JOIN game_converted  c ON p.game = c.game
ORDER BY p.total_purchasers DESC;
 
DROP TABLE game_purchasers;
DROP TABLE game_players;
DROP TABLE game_playtime;
DROP TABLE game_converted;
 
-- Merge all queries to per-user granularity
 
-- Count how many games were purchased per user
CREATE TEMP TABLE user_purchases AS
SELECT user_id, COUNT(DISTINCT game) AS games_purchased
FROM steam_data
WHERE behaviour = 'purchase'
GROUP BY user_id;
 
 -- Count how many games were played per user
CREATE TEMP TABLE user_plays AS
SELECT user_id, COUNT(DISTINCT game) AS games_played
FROM steam_data
WHERE behaviour = 'play'
GROUP BY user_id;
 
-- Create table with total playtime and average playtime per game, per user
CREATE TEMP TABLE user_playtime AS
SELECT user_id,
    SUM(game_playtime) AS total_playtime,
    AVG(game_playtime) AS avg_playtime_per_game
FROM (
    SELECT user_id, game, SUM(playtime) AS game_playtime
    FROM steam_data
    WHERE behaviour = 'play'
    GROUP BY user_id, game
)
GROUP BY user_id;
 
.once data/merged_queries_per_user.csv
 
SELECT
    u.user_id,
    COALESCE(pur.games_purchased, 0) AS games_purchased,
    COALESCE(pl.games_played, 0) AS games_played,
    COALESCE(pt.total_playtime, 0) AS total_playtime,
    COALESCE(pt.avg_playtime_per_game, 0) AS avg_playtime_per_game
FROM (SELECT DISTINCT user_id FROM steam_data) u
LEFT JOIN user_purchases pur ON u.user_id = pur.user_id
LEFT JOIN user_plays      pl ON u.user_id = pl.user_id
LEFT JOIN user_playtime   pt ON u.user_id = pt.user_id
ORDER BY u.user_id;
 
DROP TABLE user_purchases;
DROP TABLE user_plays;
DROP TABLE user_playtime;