-- 6.2A Show score trends for one match (match_id 6). participation_id breaks
-- ties when events share a timestamp.
WITH event_trends AS (
  SELECT
    mp.participation_id,
    mp.match_id,
    m.match_label,
    mp.player_id,
    mp.joined_at AS event_timestamp,
    mp.score AS current_score,
    LAG(mp.score) OVER (
      PARTITION BY mp.match_id
      ORDER BY mp.joined_at, mp.participation_id
    ) AS previous_score,
    LEAD(mp.score) OVER (
      PARTITION BY mp.match_id
      ORDER BY mp.joined_at, mp.participation_id
    ) AS next_score
  FROM match_participants AS mp
  JOIN matches AS m ON m.match_id=mp.match_id
)
SELECT
  participation_id,
  match_id,
  match_label,
  player_id,
  event_timestamp,
  previous_score,
  current_score,
  next_score,
  current_score - previous_score AS score_delta
FROM event_trends
WHERE match_id=6
ORDER BY event_timestamp, participation_id;

-- 6.2B Track daily total score and its seven-event-day moving average for
-- 2023 Q4. The quarter target is 900 score points.
WITH daily_scores AS (
  SELECT
    joined_at::date AS event_date,
    SUM(score) AS daily_score
  FROM match_participants
  WHERE joined_at >= DATE '2023-10-01'
    AND joined_at < DATE '2024-01-01'
  GROUP BY joined_at::date
),
quarter_progress AS (
  SELECT
    event_date,
    daily_score,
    SUM(daily_score) OVER (
      ORDER BY event_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_score,
    AVG(daily_score) OVER (
      ORDER BY event_date
      ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_avg_7_event_days
  FROM daily_scores
)
SELECT
  event_date,
  daily_score,
  running_total_score,
  moving_avg_7_event_days,
  900::numeric AS quarter_target_score,
  ROUND(100 * running_total_score / 900, 2) AS target_percent,
  ROUND(900 - running_total_score, 2) AS score_remaining
FROM quarter_progress
ORDER BY event_date;

-- Tracks Q4 2023 daily score totals, their running sum, and a seven-row moving
-- average. The quarter target is 900 score points. The final running total is
-- about 857 or about 43 points short of the target.

-- This dataset has 37 days with events in Q4, so a 7-row frame may span more
-- than 7 calendar days because days with no events are absent. ROWS counts
-- physical rows. RANGE includes peers with equal ORDER BY values, so tied
-- values can share the same frame and result.

-- 6.2C Find long gaps between adjacent events for matches. Choose 60 days as a
-- threshold. The outer WHERE filters window results.
WITH event_gaps AS (
  SELECT
    mp.match_id,
    m.match_label,
    mp.participation_id AS current_participation_id,
    mp.joined_at AS current_event_at,
    LAG(mp.participation_id) OVER (
      PARTITION BY mp.match_id
      ORDER BY mp.joined_at, mp.participation_id
    ) AS previous_participation_id,
    LAG(mp.joined_at) OVER (
      PARTITION BY mp.match_id
      ORDER BY mp.joined_at, mp.participation_id
    ) AS previous_event_at,
    mp.joined_at - LAG(mp.joined_at) OVER (
      PARTITION BY mp.match_id
      ORDER BY mp.joined_at, mp.participation_id
    ) AS gap
  FROM match_participants AS mp
  JOIN matches AS m ON m.match_id=mp.match_id
)
SELECT
  match_id,
  match_label,
  previous_participation_id,
  previous_event_at,
  current_participation_id,
  current_event_at,
  gap
FROM event_gaps
WHERE gap > INTERVAL '60 days'
ORDER BY gap DESC;

-- The longest gap is for match 9 at 112 days, from 2023-01-05 to 2023-04-28.
