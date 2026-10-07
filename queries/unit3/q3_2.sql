-- 3.2a Query 1: Find count of match participants that did not have a network
-- timeout (incorrectly using inequality on nullable column).
-- Requirement: WHERE
SELECT COUNT(*)
FROM match_participants
WHERE disconnect_reason != 'Network timeout';

-- Result: 22

-- 3.2a Query 2: Find count of match participants that did have a network
-- timeout.
-- Requirement: WHERE
SELECT COUNT(*)
FROM match_participants
WHERE disconnect_reason = 'Network timeout';

-- Result: 12

SELECT COUNT(*)
FROM match_participants;

-- Result: 200, noting that 22 + 12 does not equal 200

-- 3.2a Repaired query: Find count of match participants that did not have a
-- network timeout (correctly accounting for nulls)
-- Requirement: WHERE, COALESCE
SELECT COUNT(*)
FROM match_participants
WHERE COALESCE(disconnect_reason, 'No reason found') != 'Network timeout';

-- Result: 188, as expected

-- 3.2b Broken Query: Find disconnect reason for match and player
-- (incorrectly using alias in WHERE).
-- Requirement: WHERE
SELECT match_id, player_id, disconnect_reason AS reason
FROM match_participants
WHERE reason = 'Network timeout';

-- 3.2b Fixed Query 1: Find disconnect reason for match and player (repeating
-- expression in WHERE).
-- Requirement: WHERE
SELECT match_id, player_id, disconnect_reason AS reason
FROM match_participants
WHERE disconnect_reason = 'Network timeout';

-- 3.2b Fixed Query 2: Find participation status for match and player (using
-- CTE).
-- Requirement: WITH, WHERE
WITH cte (match_id, player_id, reason) AS (
  SELECT match_id, player_id, disconnect_reason
  FROM match_participants
)
SELECT match_id, player_id, reason
FROM cte
WHERE reason = 'Network timeout';
