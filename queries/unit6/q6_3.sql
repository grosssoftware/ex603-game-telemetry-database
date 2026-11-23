-- 6.3A Find the top three players by score for each match.
WITH ranked_events AS (
  SELECT
    mp.participation_id,
    mp.match_id,
    m.match_label,
    mp.player_id,
    p.player_name,
    mp.joined_at AS event_timestamp,
    mp.score,
    RANK() OVER (
      PARTITION BY mp.match_id
      ORDER BY mp.score DESC
    ) AS score_rank,
    FIRST_VALUE(mp.score) OVER (
      PARTITION BY mp.match_id
      ORDER BY mp.score DESC, mp.participation_id
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS producer_top_score
  FROM match_participants AS mp
  JOIN matches AS m ON m.match_id=mp.match_id
  JOIN players AS p ON p.player_id=mp.player_id
)
SELECT
  participation_id,
  match_id,
  match_label,
  player_id,
  player_name,
  event_timestamp,
  score,
  score_rank,
  producer_top_score
FROM ranked_events
WHERE score_rank <= 3
ORDER BY match_id, score_rank, score DESC, participation_id;

-- RANK gives players with equal scores the same position. Using a filter of
-- rank <= 3 keeps all player tied at third place, even if that means more than
-- three rows for a match.

-- 6.3B Compare each calendar month's average player score with the prior month.
-- Generate a complete calendar series so LAG cannot skip empty months.
-- NOTE: After several attempts by hand, I was not getting the correct results.
-- I used AI (Codex) to help write this query. The query was reviewed and the
-- results looks correct.
WITH month_bounds AS (
  SELECT
    DATE_TRUNC('month', MIN(joined_at))::date AS first_month,
    DATE_TRUNC('month', MAX(joined_at))::date AS last_month
  FROM match_participants
),
calendar_months AS (
  SELECT generate_series(
    first_month,
    last_month,
    INTERVAL '1 month'
  )::date AS month_start
  FROM month_bounds
),
monthly_metrics AS (
  SELECT
    DATE_TRUNC('month', joined_at)::date AS month_start,
    COUNT(*) AS event_count,
    AVG(score) AS monthly_avg_score
  FROM match_participants
  GROUP BY DATE_TRUNC('month', joined_at)::date
),
complete_months AS (
  SELECT
    cm.month_start,
    COALESCE(mm.event_count, 0) AS event_count,
    mm.monthly_avg_score
  FROM calendar_months AS cm
  LEFT JOIN monthly_metrics AS mm USING (month_start)
),
monthly_lags AS (
  SELECT
    month_start,
    event_count,
    monthly_avg_score,
    LAG(month_start) OVER (ORDER BY month_start) AS previous_month_start,
    LAG(event_count) OVER (ORDER BY month_start) AS previous_month_event_count,
    LAG(monthly_avg_score) OVER (ORDER BY month_start) AS previous_month_avg_score
  FROM complete_months
)
SELECT
  month_start,
  event_count,
  event_count = 0 AS is_missing_month,
  previous_month_start,
  previous_month_event_count,
  CASE
    WHEN previous_month_start IS NULL THEN NULL
    ELSE previous_month_start = (month_start - INTERVAL '1 month')::date
  END AS previous_row_is_prior_calendar_month,
  monthly_avg_score,
  previous_month_avg_score,
  ROUND(
    100 * (monthly_avg_score - previous_month_avg_score)
      / NULLIF(previous_month_avg_score, 0),
    2
  ) AS avg_score_percent_change
FROM monthly_lags
ORDER BY month_start;
