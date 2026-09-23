-- =================================================================
-- EX 603 Assignment 2 — schema.sql
-- Theme: Game Telemetry Database
-- Author: Jeff Gross
-- Target: PostgreSQL 14+
-- =================================================================

-- Reset. Reverse creation order, so no dependency blocks a drop.
DROP TABLE IF EXISTS match_participants CASCADE;
DROP TABLE IF EXISTS match_modes CASCADE;
DROP TABLE IF EXISTS matches CASCADE;
DROP TABLE IF EXISTS players CASCADE;
DROP TABLE IF EXISTS game_modes CASCADE;

-- Create tables in order from most to least independent.

-- 1. game_modes -- A lookup table (catalog) defining the different possible
-- game modes. Used by match_modes, but does not depend on any itself.
CREATE TABLE game_modes (
    game_mode_id INT GENERATED ALWAYS AS IDENTITY, -- surrogate key for consistency and performance
    name VARCHAR(32) NOT NULL,
    CONSTRAINT pk_game_modes PRIMARY KEY (game_mode_id),
    CONSTRAINT uk_game_modes_name UNIQUE (name)
);

-- 2. players -- Describes an actor (the player) who is using the online gaming
-- platform. Used by match_participants, but does not depend on any other
-- tables.
CREATE TABLE players (
    player_id INT GENERATED ALWAYS AS IDENTITY, -- surrogate key for performance
    name VARCHAR(32) NOT NULL,
    CONSTRAINT pk_players PRIMARY KEY (player_id),
    CONSTRAINT uk_players_name UNIQUE (name),
    CONSTRAINT ck_players_name CHECK (name ~ '^[a-zA-Z0-9_]+$')
);

-- 3. matches -- Describes a producer (the match) of events. Used by
-- match_participants and match_modes, but does not depend on any other tables.
CREATE TABLE matches (
    match_id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(32) NOT NULL,
    activity_flag BOOLEAN NOT NULL,
    match_number INT NOT NULL, -- Use of this attribute is TBD, but will be used for filtering later
    CONSTRAINT pk_matches PRIMARY KEY (match_id),
    CONSTRAINT ck_matches_name CHECK (name ~ '^[a-zA-Z0-9_]+$')
);

-- 4. match_modes -- A junction table connecting matches to game modes. Depends
-- on both matches and game_modes.
CREATE TABLE match_modes (
    match_id INT,
    game_mode_id INT,
    CONSTRAINT pk_match_modes PRIMARY KEY (match_id, game_mode_id),
    CONSTRAINT fk_match_modes_match_id
        FOREIGN KEY (match_id) REFERENCES matches (match_id) ON DELETE CASCADE,
    CONSTRAINT fk_match_modes_game_mode_id
        FOREIGN KEY (game_mode_id) REFERENCES game_modes (game_mode_id) ON DELETE RESTRICT
);

-- 5. match_participants -- Describes an event (a match and its participants).
-- Depends on both matches and players.
CREATE TABLE match_participants (
    match_id INT,
    player_id INT,
    timestamp TIMESTAMP NOT NULL,
    score INT NOT NULL,
    CONSTRAINT pk_match_participants PRIMARY KEY (match_id, player_id),
    CONSTRAINT fk_match_participants_match_id
        FOREIGN KEY (match_id) REFERENCES matches (match_id) ON DELETE RESTRICT,
    CONSTRAINT fk_match_participants_player_id
        FOREIGN KEY (player_id) REFERENCES players (player_id) ON DELETE SET NULL
);
