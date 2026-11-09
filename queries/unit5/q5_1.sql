-- 5.1.1 Find the date, label, and names of players in each match.
SELECT
  m.scheduled_on AS date,
  m.match_label AS match,
  p.player_name AS player
FROM match_participants mp
JOIN matches m USING (match_id)
JOIN players p USING (player_id)
ORDER BY match, player;

-- 5.1.2 Find the game mode and label of each match.
SELECT
  gm.mode_name AS mode,
  m.match_label AS match
FROM match_modes
JOIN matches m USING (match_id)
JOIN game_modes gm USING (mode_id)
ORDER BY mode, match;

-- 5.1.3 Find the players and who they were recruited by if anyone.
-- NOTE: The assignment description requests a self-join on the producer table
-- (matches), but there are no suitable columns to self-join in that table, so I
-- am using the actor table (players) instead.
SELECT
  p.player_name AS player,
  rp.player_name AS recruiter
FROM players p
LEFT JOIN players rp ON rp.player_id=p.recruited_by
ORDER by player;
