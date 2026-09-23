# EX603 Game Telemetry Database

by Jeff Gross

This repository contains the schema and queries for working with a PostgreSQL database that tracks players, matches, and other metrics during play of a online game.

## The Domain

This project defines and implements a model for tracking metrics of an online multi-player gaming platform. The various entities include:
* Players, which have names
* Matches, which have names, an activity flag (true when match is in progress, false when match completes), and a match number (whose use is TBD)
* Game modes, a lookup list of the different modes the gameplay may take

The relationship between these entities include a many-to-many relationship between matches and players where multiple players can be in a match and players can play multiple matches, and a many-to-many relationship between matches and game modes where matches can have multiple game modes.

The basic questions that must be answerable by the model include:
1. How many players are in the system?
2. How many matches are in the system?
3. How many players are in each match and who are they?
4. When did a player join a match and what is their current or final score?
5. What game modes is a match using?

More advanced questions include:
1. How many matches have been completed (activity flag is false)?
2. How many matches has each player played?
3. What is the average score of a player?
4. What are the top scores (leaderboard) within a match?
5. What are the top scores (leaderboard) across all matches?

## Schema

The schema consists of five tables:
1. `game_modes` (catalog role), a lookup table defining the different possible game modes. Each of the game modes has a non-null unique name to prevent confusion when configuring a match. This table has an ID as surrogate key for consistency and potentially performance.
2. `players` (actor role), describes a player who is using the online gaming platform. Each of the players has a non-null unique name to prevent confusion while playing a match. Because names are configured by platform users, they are restricted to alphanumeric characters and underscore. This table has an ID as surrogate key for performance.
3. `matches` (producer role), describes the match which is the producer of events. Matches have a non-null name that does not need to be unique, but becuase names are configured by platform users, they are restricted to alphanumeric characters and underscore. Matches have a boolean activity flag indicating if the match is in progress or not. Matches also have a match number to assist with filtering and sorting.
4. `match_modes` (junction role), a junction table connecting matches to game modes. Provides a many-to-many link between matches (producer) and game modes (catalog). Uses a composite primary key consisting of the match and game mode IDs which are also foreign keys.
5. `match_participants` (event role), a junction table connecting matches to player. Provides a many-to-many link between matches (producer) and players (actor). Captures the match events including a timestamp of the event and player score. Uses a composite primary key consisting of the match and player IDs which are also foreign keys.

### Entity Relationship Diagram

![ERD](schema/erd.png)

## Query Catalogue

_Per unit, a short table listing the queries and the business question each answers, linked to the .sql files._

## Technical Highlights

_Three to five things a reader should notice._

## What I would do Differently

_An honest paragraph. Critiquing your own work is a senior signal, not a weakness._

## Video Presentation

_Embed or link the video._

## How to Run it

_The commands to create the schema and execute a query. Assume the reader has a database and nothing else._

## History

| Week |   Date    | Changes                                  |
| ---- | --------- | ---------------------------------------- |
| 1    | 2026SEP09 | Project setup and initial README.        |
|      | 2026SEP11 | Basic model doc with minimal attributes. |
|      |           | Unit 1 analysis.                         |
| 2    | 2026SEP23 | Added DDL schema and Unit 2 analysis.    |
