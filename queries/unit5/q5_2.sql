-- 5.2A Find unique matches using LEFT JOIN.
SELECT DISTINCT
  m.match_id AS match_id
FROM matches m
LEFT JOIN match_participants mp USING (match_id)
ORDER BY match_id;

-- 5.2A Find unique matches with participants using INNER JOIN.
SELECT DISTINCT
  m.match_id AS match_id
FROM matches m
JOIN match_participants mp USING (match_id)
ORDER BY match_id;

-- 5.2A Find matches without participants.
SELECT
  m.match_id AS match_id
FROM matches m
LEFT JOIN match_participants mp USING (match_id)
WHERE mp.match_id IS NULL
ORDER BY match_id;

-- 5.2B Find unique matches using RIGHT JOIN.
SELECT DISTINCT
  m.match_id AS match_id
FROM match_participants mp
RIGHT JOIN matches m USING (match_id)
ORDER BY match_id;

-- 5.2B Find matches using FULL OUTER JOIN.
SELECT DISTINCT
  m.match_id AS match_id
FROM matches m
FULL OUTER JOIN match_participants mp USING (match_id)
ORDER BY match_id;

-- 5.2C Find matches without participants using NOT EXISTS.
SELECT
  m.match_id AS match_id
FROM matches m
WHERE NOT EXISTS (
  SELECT 1
  FROM match_participants mp
  WHERE mp.match_id = m.match_id
)
ORDER BY match_id;

-- 5.2C Find matches without participants using EXCEPT.
SELECT
  m.match_id AS match_id
FROM matches m
EXCEPT
SELECT
  mp.match_id AS match_id
FROM match_participants mp
ORDER BY match_id;
