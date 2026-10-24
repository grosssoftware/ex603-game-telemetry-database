# Unit 4

## Task 4.1

### Question 1

The query for question 1 finds metrics on the match scores including the number
of matches, and the total sum, average, minimum and maximum of the scores as
well as the number of distinct players. The first time the query was run, the
minimum score was 0. Inspecting the data further showed that a player's score
was recorded as 0 if they didn't finish the match. The query was adjusted to
ignore players' scores if they did not finish the match.

### Question 2

The query for question 2 finds the number of participants and the average score
for each match, sorted from most participants to least. This was achieved by
aggregate functions COUNT and AVG and using GROUP BY on the match ID. The
results showed and average score within a match ranged from about 17 to 29
compared to an average overall score of about 22.

### Question 3

The query for question 3 filters the query from question 2 to matches with at
least 10 players. The threshold of 10 was chosen because it's about half of the
maximum number of players in a match (19) and only two matches fell below it,
one of which had only 4 players and a high average score.

### Question 4

The query for question 3 finds the number of participants and average score for
each match and region, sorted by average score.

### Results

The final query produced summary data for leaders to judge performance while
managing their regions. However, the data is not specific enough as is. The
aggregation used in the queries hide who the participants actually are.

While inspecting the data further, it was discovered that some players appear to
be in a single match multiple times from different regions. This seems to be a
data-quality issue that would require more investigation.

## Task 4.2

### Part A

The query for part A finds the number of participants and number of failures for
each match. The number of failures is assumed to be those with a disconnect
reason of "Network timeout", "Server restart", or "Client crash". A player
quitting a match is not considered a failure.

### Part B

The query for part B finds the subtotals and grand total of number of
participants and number of failures for each region.  The subtotals are
identified by a region name in the region column while the grand total is
identified by "All regions" which replaces the NULL value that a ROLLUP would
produce.

The regional director reading the query results can use the data to determine
which regions are having the most failures (in this case, SA with more than
twice as many failures than most other regions). Looking at the grand total
alone would not help pinpoint where failures are most prevalent.

### Part C

The query for part C finds the matches with a number of participants greater
than the average number of participants per match.

## Reflection

Using conditional aggregation, several metrics can be computed in one pass
through the tables. This is accomplished by using a CASE statement inside an
aggregate function. For example, each WHEN clause of the CASE statement could
produce a 1 value for matching conditions, and the ELSE clause a 0 value for
non-matching conditions. Using the SUM aggregate function, the result will be a
count of the matching conditions. The alternative is running several queries,
filtering on each of the conditions and then counting which will result in
multiple passes through the table. Conditional aggregation results in
dramatically better performance. When looking at N distinct metrics, using
conditional aggregation would improve performance N-fold over passing through
the table for each metric.