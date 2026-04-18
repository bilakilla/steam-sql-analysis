# Steam SQL Data Analysis & Power BI Dashboard

## Project Overview
This project explores user acquisition, engagement, and behaviour, and overall summary metrics within a [dataset of 200k Steam user interactions](https://www.kaggle.com/datasets/tamber/steam-video-games) using SQL.

The goal is to build a structured analytics pipeline that uncovers:
- Which games drive purchases and monetisation  
- Which games drive engagement  
- How player behaviour varies across distinct user segments  

These insights are then visualised through an interactive Power BI dashboard.

**Dashboard Walkthrough:** [Watch on YouTube!](https://youtu.be/IeluTTADpdo) 

## Data Pipeline
1. Raw Steam data is extracted and cleaned using SQL
2. Analytical queries compute acquisition, engagement, and behavioural metrics
3. Results are aggregated into structured datasets
4. Outputs are exported as `.csv` files
5. Power BI uses these datasets for interactive visualisation

## Data Model & Dataset Design
The original data is split across several related tables (users, games, purchases, and activity). I used SQL to join these tables together and calculate all required metrics.

Instead of connecting Power BI directly to the raw data, I created two final, analysis-ready datasets:

`merged_queries_per_user.csv` → Contains user-level metrics (e.g. playtime, purchases, user segments) <br>
`merged_queries_per_game.csv` → Contains game-level metrics (e.g. popularity, total playtime, performance)

These datasets act as clean, pre-processed inputs for Power BI, making the dashboard simpler, faster, and easier to work with.

## Repository Structure

`/data        # Processed CSV outputs from SQL queries` <br>
`/gifs        # Dashboard previews (used in README)` <br>
`/powerbi     # Power BI (.pbix) dashboard files` <br>
`/queries     # SQL scripts for data extraction & transformation`

## SQL Metrics & Analysis

The project is structured around three analytical layers:

### 1. User Acquisition
**Focus:** How do users enter and become customers within the platform?

**Datasets:**

`avg_games_per_user.csv` → Average number of games owned per user <br>
`games_purchased_per_user.csv` → Purchase volume per user <br>
`total_purchasers.csv` → Total number of paying users

**Purpose:**

- Measure platform growth and monetisation
- Understand broad purchasing behaviour
- Identify conversion trends from users → customers

### 2. User Engagement
**Focus:** How actively do users interact with games?

**Datasets:**

`avg_playtime_per_user.csv` → Average engagement per user <br>
`playtime_distribution.csv` → Distribution of playtime (engagement histogram) <br>
`players_per_game.csv` → Number of players per game <br>
`most_engaging_games.csv` → Highest average playtime per user <br>
`most_played_games_by_players.csv` → Most popular games (by player count) <br>
`most_played_games_by_playtime.csv` → Most played games (by total time) <br>
`player_conversion_rate.csv` → % of customers who become players

**Purpose:**

- Evaluate depth vs breadth of engagement
- Compare purchases vs players
- Identify high-performing vs underperforming titles

### 3. User Behaviour
<b>Focus:</b> How do different types of users interact with the platform?

Users are segmented into behavioural personas based on purchase activity and playtime:

- **Casual Players** → Low purchases, low playtime
- **Game Collectors** → High purchases, low playtime
- **Hardcore Gamers** → High purchases, high playtime
- **Niche Players** → Low purchases, high playtime
- **Regular Users** → Moderate behaviour across both dimensions

**Purpose:**

- Identify distinct user segments
- Understand monetisation vs engagement trade-offs

### Key Analytical Insights
**1. Purchase Concentration**
- The top ~6 games account for ~80% of total purchases, indicating a highly concentrated market dominated by a small number of titles.

**2. Developer / Franchise Loyalty**
- A strong presence of Valve titles (e.g. Dota 2, Counter Strike) among top purchases suggests significant brand and franchise loyalty within the player base.

**3. Polarised Engagement Distribution**
- Player engagement is highly skewed, with a noticeable gap in mid-tier activity—users tend to be either lightly or heavily engaged.

**4. Engagement Dominated by Few Titles**
- A small number of games (notably Counter-Strike variants) drive a disproportionate share of total playtime and average engagement.

**5. Distinct User Segmentation Patterns**
- Users naturally cluster into distinct personas, from casual participants to deeply invested hardcore players.

**6. Divergence Between Spending & Engagement**
- Behavioural clusters highlight that high spending does not always correlate with high engagement (e.g., Game Collectors).

## Power BI Dashboard Pages

### 1. Summary
![](https://github.com/bilakilla/steam-sql-analysis/blob/main/gifs/steam_pbi_summary.gif) 
### 2. Acquisition
![](https://github.com/bilakilla/steam-sql-analysis/blob/main/gifs/steampbiacq.gif)
### 3. Engagement
![](https://github.com/bilakilla/steam-sql-analysis/blob/main/gifs/steampbiengagement.gif)
### 4. Behaviour
![](https://github.com/bilakilla/steam-sql-analysis/blob/main/gifs/steampbiuserpersona.gif)

## Skills Demonstrated

- SQL (joins, aggregations, analytical queries)  
- Data modelling & metric design  
- User segmentation & behavioural analysis  
- Data visualisation (Power BI)  
- End-to-end analytics workflow development 

## How to Use
1. Clone this repo:
  `git clone https://github.com/bilakilla/steam-sql-analysis.git`
2. Explore or modify SQL scripts in your preferred SQL environment.
3. Open the `.pbix` file in Power BI Desktop to interact with the dashboard.
