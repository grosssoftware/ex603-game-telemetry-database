-- 4.2A Find number of participants and number of failures for each match.
SELECT
  match_id AS match,
  COUNT(*) AS count,
  SUM(
    CASE
      WHEN disconnect_reason = 'Network timeout' THEN 1
      WHEN disconnect_reason = 'Server restart' THEN 1
      WHEN disconnect_reason = 'Client crash' THEN 1
      ELSE 0
    END
  ) AS failures
FROM match_participants
GROUP BY match_id
ORDER BY match_id;

-- 4.2B Find subtotals and grand totals of number of participants and number of
-- failures for each region.
SELECT
  COALESCE(client_region, 'All regions') AS region,
  COUNT(*) AS count,
  SUM(
    CASE
      WHEN disconnect_reason = 'Network timeout' THEN 1
      WHEN disconnect_reason = 'Server restart' THEN 1
      WHEN disconnect_reason = 'Client crash' THEN 1
      ELSE 0
    END
  ) AS failures
FROM match_participants
GROUP BY ROLLUP(client_region);

-- 4.2C Find matches with a number of participants greater than average.
WITH cte (match, count) AS (
  SELECT match_id, COUNT(score)
  FROM match_participants
  GROUP BY match_id
),
cte_avg (average) AS (
  SELECT AVG(count)
  FROM cte
)
SELECT match, count
FROM cte
WHERE count > (SELECT average FROM cte_avg)
ORDER BY match;
