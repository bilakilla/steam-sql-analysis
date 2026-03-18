-- Create table with useless column
CREATE TABLE steam_raw(
    user_id INT,
    game TEXT,
    behaviour TEXT,
    playtime REAL,
    ignored INT
);

-- Import dataset into raw table
.mode csv
.import steam-200k.csv steam_raw

-- Create cleaned table
CREATE TABLE steam_data(
    user_id INT,
    game TEXT,
    behaviour TEXT,
    playtime REAL
);

-- Insert first 4 columns from steam_raw into steam_data (clean table)
INSERT INTO steam_data(
    user_id,
    game,
    behaviour,
    playtime)
SELECT user_id, game, behaviour, playtime FROM steam_raw;

DROP TABLE IF EXISTS steam_raw;