-- 5.3A CROSS JOIN two small tables.
SELECT
  gm.mode_name AS mode,
  p.player_name as player
FROM game_modes gm
CROSS JOIN players p;

-- 5.3A Count rows in game_modes.
SELECT
  COUNT(*) AS num_modes
FROM game_modes;

-- 5.3A Count rows in players.
SELECT
  COUNT(*) AS num_players
FROM players;

-- 5.3A Count rows in cartesian product of games_modes and players.
SELECT
  COUNT(*)
FROM game_modes gm
CROSS JOIN players p;

-- 5.3B Use EXPLAIN to examine query execution plan.
EXPLAIN
SELECT
  m.scheduled_on AS date,
  m.match_label AS match,
  p.player_name AS player
FROM match_participants mp
JOIN matches m USING (match_id)
JOIN players p USING (player_id)
ORDER BY match, player;
