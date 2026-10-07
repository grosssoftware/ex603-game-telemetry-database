-- 3.1.1 Find top 10 matches with high player counts.
-- Requirement: ORDER BY, LIMIT
SELECT match_id, match_code, player_count
FROM matches
WHERE is_ranked = TRUE
AND player_count >= 8
ORDER BY player_count DESC
LIMIT 10;

-- 3.1.2 Find all possible match participation statuses.
-- Requirement: SELECT DISTINCT
SELECT DISTINCT participation_status
FROM match_participants;

-- 3.1.3a Filter match participants by score.
-- Requirement: SELECT, WHERE
SELECT match_id, player_id, score
FROM match_participants
WHERE score > 20.0
AND score < 100.0;

-- 3.1.3b Filter match participants by disconnect reason.
-- Requirement: SELECT, WHERE, IN
SELECT match_id, player_id, disconnect_reason
FROM match_participants
WHERE disconnect_reason
IN ('Client crash', 'Network timeout', 'Server restart');

-- 3.1.4 Query 1 Find matches with a specific code.
-- Requirement: SELECT, WHERE, LIKE
SELECT match_id, match_code
FROM matches
WHERE match_code
LIKE '%1005';

-- 3.1.4 Query 2 Find match participants and readable disconnect reason.
-- Requirement: SELECT, COALESCE
SELECT player_id, COALESCE(disconnect_reason, 'No reason provided') AS reason
FROM match_participants;

-- 3.1.5 Categorize match performance as high, medium, or low.
-- Requirement: CASE
SELECT
  player_id AS ID,
  CASE
    WHEN score > 50 THEN 'high'
    WHEN score > 25 THEN 'medium'
    ELSE 'low'
  END AS Performance
FROM match_participants;
