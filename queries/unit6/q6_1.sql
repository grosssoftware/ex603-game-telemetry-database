-- 6.1.1 Query 1 Find each players's score with the average score for its
-- match. The window function keeps one result row per player.
SELECT
  mp.participation_id,
  mp.match_id,
  m.match_label,
  mp.player_id,
  mp.score,
  AVG(mp.score) OVER (PARTITION BY mp.match_id) AS avg_score
FROM match_participants AS mp
JOIN matches AS m ON m.match_id=mp.match_id
ORDER BY mp.match_id, mp.participation_id;

-- 6.1.1 Query 2 GROUP BY returns one row per match, not one row per player.
SELECT
  mp.match_id,
  m.match_label,
  COUNT(*) AS match_count,
  AVG(mp.score) AS avg_score
FROM match_participants AS mp
JOIN matches AS m ON m.match_id=mp.match_id
GROUP BY mp.match_id, m.match_label
ORDER BY mp.match_id;

-- The window query returns 200 rows. The GROUP BY query returns 13 rows (one
-- per match with events). GROUP BY loses event details such as
-- participation_id, player_id, and each event's score.

-- 6.1.2 Rank matches by event count. LEFT JOIN keeps producers with no events
-- in the leaderboard.
WITH match_event_counts AS (
  SELECT
    m.match_id,
    m.match_label,
    COUNT(mp.participation_id) AS event_count
  FROM matches AS m
  LEFT JOIN match_participants AS mp ON mp.match_id=m.match_id
  GROUP BY m.match_id, m.match_label
)
SELECT
  match_id,
  match_label,
  event_count,
  ROW_NUMBER() OVER (ORDER BY event_count DESC, match_id) AS row_number_rank,
  RANK() OVER (ORDER BY event_count DESC) AS rank_rank,
  DENSE_RANK() OVER (ORDER BY event_count DESC) AS dense_rank
FROM match_event_counts
ORDER BY event_count DESC, match_id;

-- 6.1.3 Split matches into four bands. The match_id tiebreaker makes the
-- assignment deterministic when matches have equal event counts.
WITH match_event_counts AS (
  SELECT
    m.match_id,
    m.match_label,
    COUNT(mp.participation_id) AS event_count
  FROM matches AS m
  LEFT JOIN match_participants AS mp ON mp.match_id=m.match_id
  GROUP BY m.match_id, m.match_label
)
SELECT
  match_id,
  match_label,
  event_count,
  NTILE(4) OVER (ORDER BY event_count DESC, match_id) AS event_count_band
FROM match_event_counts
ORDER BY event_count DESC, match_id;

-- With 15 matches, the bands contain 4, 4, 4, and 3. The two matches with 18
-- events straddle bands 1 and 2. Because NTILE divides rows evenly, event
-- counts are assigned to different bands.
