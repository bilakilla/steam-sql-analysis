.headers ON
.mode csv

-- Total number of purchasers?
.once data/total_purchasers.csv

SELECT COUNT(distinct user_id) AS total_purchasers
FROM steam_data
WHERE behaviour = 'purchase';

-- Which games were most purchased?
.once data/most_purchased_games.csv

SELECT game, COUNT(DISTINCT user_id) AS total_purchasers
FROM steam_data
WHERE behaviour = 'purchase'
GROUP BY game
ORDER BY total_purchasers DESC
LIMIT 10;

-- What is the average number of games purchased by a user?
.once data/avg_games_per_user.csv

SELECT AVG(purchased_games) AS avg_games_per_user
FROM (
    SELECT user_id, COUNT(DISTINCT game) as purchased_games
    FROM steam_data
    WHERE behaviour = 'purchase'
    GROUP BY user_id
    );

-- Which games had the most players?
.once data/most_played_games_by_players.csv

SELECT game, COUNT(DISTINCT user_id) AS total_players
FROM steam_data
WHERE behaviour = 'play'
GROUP BY game
ORDER BY total_players DESC
LIMIT 10;

-- How many games has each user purchased?
.once data/games_purchased_per_user.csv

SELECT purchased_games, COUNT(*) as number_of_users
FROM (
    SELECT user_id, COUNT(DISTINCT game) as purchased_games
    FROM steam_data
    WHERE behaviour = 'purchase'
    GROUP BY user_id
)
GROUP BY purchased_games
ORDER BY purchased_games ASC;

-- Which users purchased the most games in the dataset?
.once data/richest_users.csv

SELECT user_id, COUNT(DISTINCT game) as games_purchased
FROM steam_data
WHERE behaviour = 'purchase'
GROUP BY user_id
ORDER BY games_purchased DESC
LIMIT 10;