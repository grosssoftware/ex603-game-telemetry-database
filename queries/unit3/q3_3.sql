-- 3.3.1 Find names of players who had network timeouts (using subquery with WHERE IN).
-- Requirement: WHERE, IN
SELECT player_name
FROM players
WHERE player_id IN (
  SELECT player_id
  FROM match_participants
  WHERE disconnect_reason='Network timeout'
)
ORDER BY player_name;

-- 3.3.2 Find names of players who had network timeouts (using CTE).
-- Requirement: WITH
WITH cte AS (
  SELECT DISTINCT player_id
  FROM match_participants
  WHERE disconnect_reason='Network timeout'
)
SELECT player_name
FROM cte
JOIN players USING (player_id)
ORDER BY player_name;

-- 3.3.3 Find names of players who had network timeouts (set based approach).
-- Requirements: none
SELECT DISTINCT player_name
FROM players
JOIN match_participants USING (player_id)
WHERE disconnect_reason='Network timeout'
ORDER BY player_name;

-- DISTINCT is vital in the second and third queries to make sure duplicates are
-- removed.