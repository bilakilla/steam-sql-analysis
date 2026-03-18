.headers ON
.mode csv

-- Total number of players?
.once data/total_players.csv

SELECT COUNT(distinct user_id) AS total_players
FROM steam_data
WHERE behaviour = 'play';

-- What is the average playtime per user?
.once data/avg_playtime_per_user.csv

SELECT game, AVG(total_playtime) AS avg_playtime
FROM (
    SELECT 
        user_id,
        game,
        SUM(playtime) AS total_playtime
    FROM steam_data
    WHERE behaviour = 'play'
    GROUP BY user_id, game
)
GROUP BY game
ORDER BY avg_playtime DESC;

-- What is the playtime distribution across all users?
.once data/playtime_distribution.csv

SELECT total_playtime, COUNT(*) AS number_of_users
FROM (
    SELECT user_id, SUM(playtime) AS total_playtime
    FROM steam_data
    WHERE behaviour = 'play'
    GROUP BY user_id
)
GROUP BY total_playtime
ORDER BY total_playtime;

-- What are the top played games (by total playtime)?
.once data/most_played_games_by_playtime.csv

SELECT game, SUM(playtime) AS total_playtime
FROM steam_data
WHERE behaviour = 'play'
GROUP BY game
ORDER BY total_playtime DESC
LIMIT 10;

-- What are the most engaging games, with longest average playtime per user?
.once data/most_engaging_games.csv

SELECT game, AVG(user_total_playtime) AS avg_playtime
FROM (
    SELECT 
        user_id,
        game,
        SUM(playtime) AS user_total_playtime
    FROM steam_data
    WHERE behaviour = 'play'
    GROUP BY user_id, game
)
GROUP BY game
ORDER BY avg_playtime DESC
LIMIT 10;

-- Which games have the most players?
.once data/players_per_game.csv

SELECT game, COUNT(DISTINCT user_id) AS total_players
FROM steam_data
WHERE behaviour = 'play'
GROUP BY game
ORDER BY total_players DESC
LIMIT 10;

-- What is the player conversion rate?
.once data/player_conversion_rate.csv

SELECT 
    p.game, --p. is a table alias for purchasers
    p.total_purchasers,
    pp.purchased_and_played, -- pp. is a table alias for purchasers + players
    ROUND(
        100.0 * pp.purchased_and_played / p.total_purchasers, -- conversion rate
        2
    ) AS conversion_rate
FROM 
    -- users who purchased
    (
        SELECT 
            game,
            COUNT(DISTINCT user_id) AS total_purchasers
        FROM steam_data
        WHERE behaviour = 'purchase'
        GROUP BY game
    ) p
JOIN 
    -- users who purchased AND played
    (
        SELECT 
            game,
            COUNT(*) AS purchased_and_played
        FROM (
            SELECT user_id, game
            FROM steam_data
            WHERE behaviour IN ('purchase', 'play')
            GROUP BY user_id, game
            HAVING COUNT(DISTINCT behaviour) = 2
        )
        GROUP BY game
    ) pp
ON p.game = pp.game
ORDER BY conversion_rate DESC;

-- Which games were most overhyped (i.e. purchased but not played)?
.once data/overhyped_games.csv

SELECT p.game,
    COUNT(DISTINCT p.user_id) AS purchasers,
    COUNT(DISTINCT pl.user_id) AS players
FROM steam_data p
LEFT JOIN steam_data pl
    ON p.user_id = pl.user_id
    AND p.game = pl.game
    AND pl.behaviour = 'play'
WHERE p.behaviour = 'purchase' AND pl.user_id IS NULL
GROUP BY p.game
ORDER BY purchasers DESC
LIMIT 10;