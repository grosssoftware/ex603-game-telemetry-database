-- 4.1.1 Find metrics on match scores including count, total, average, minimum
-- and maximum, and number of distinct players. Don't include scores where the
-- player didn't finish because their recorded score will be 0 affecting the
-- average.
SELECT
  COUNT(score) AS count,
  SUM(score) AS total,
  AVG(score) AS average,
  MIN(score) AS minimum,
  MAX(score) AS maximum,
  COUNT(DISTINCT player_id) AS "unique players"
FROM match_participants
WHERE disconnect_reason IS NULL;

-- 4.1.2 Find number of participants and average score for each match, sorted
-- from most participants to least.
SELECT
  match_id AS match,
  COUNT(score) AS count,
  AVG(score) AS average
FROM match_participants
WHERE disconnect_reason IS NULL
GROUP BY match_id
ORDER BY COUNT(score) DESC;

-- 4.1.3 Filter last query to matches with at least 10 players.
SELECT
  match_id AS match,
  COUNT(score) AS count,
  AVG(score) AS average
FROM match_participants
WHERE disconnect_reason IS NULL
GROUP BY match_id
HAVING COUNT(score) >= 10
ORDER BY COUNT(score) DESC;

-- 4.1.4 Find number of participants and average score for each match and
-- region.
SELECT
  match_id AS match,
  client_region AS region,
  COUNT(score) AS count,
  AVG(score) AS average
FROM match_participants
WHERE disconnect_reason IS NULL
GROUP BY match_id, client_region
ORDER BY match_id, AVG(score) DESC;
