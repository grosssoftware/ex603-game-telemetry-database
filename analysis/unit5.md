# Unit 5

## Task 5.1

### Question 1

> _What feature or report on your platform could use the three-table join from
> Question 1? What information would it display?_

The first query finds the date, label, and names of players in each match. This
query would be useful to create a "match participation" report which lists all
matches, when each was scheduled and the names of the players that participated
in them.

### Question 2
> _Why is the junction table important for answering Question 2? What would make
> this analysis more difficult without it?_

The second query finds the game mode and label of each match using the
"match_modes" junction table. The game_modes table is only an enumeration of all
possible modes. The matches table is the list of each match. The junction table
is vital because it links the game modes with matches in a many-to-many
relationship which could not be accomplished with another column in the matches
table.

## Task 5.2

### Part A

The LEFT JOIN returned more results (15) than the INNER JOIN (13). This is
because there were two matches that didn't have any participants. The INNER JOIN
excludes them because it has nothing to match against. The LEFT JOIN includes
them because it matches against NULL.

### Part B

The FULL OUTER JOIN returned the same results as the LEFT JOIN in this case.
That is because every match_id from the match_participants table was also in the
matches table, but not every match_id in the matches table was in the
match_participants table. However, had there been match_ids in the
match_participants table that were NOT in the matches table, the FULL OUTER JOIN
would have also included those resulting in a larger set than a LEFT, RIGHT, or
INNER JOIN would provide.

### Part C

The queries using NOT EXISTS and EXCEPT both return the same two matches -- the
same ones that were excluded by the INNER JOIN. The NOT EXISTS version of the
query checks if the match_id from the matches table is found in the
match_participants table and if not, returns that row in the result set. The
EXCEPT version of the query uses set difference to remove the set of match_ids
from the match_participants table from the set of match_ids from the matches
table.

### Question 1

> _Which producers were excluded by the inner join? Report their identifiers._

Match ID 14 and 15 were the producers excluded by the inner join.

### Question 2

> _What does it mean when a producer has no events? What are some possible
> explanations?_

Matches are the producers in this scenarios. If a match has no events it could
mean the match has not yet taken place, the match was cancelled, or the match
has started and no players have joined.

### Question 3

> _How could a report based only on an inner join give leadership an incomplete
> picture of the platform?_

The INNER JOIN does not include the producers (matches in this case) without
events (matches with participants). The excluded matches may or may not be
meaningful in counts depending on what leadership is looking for.

### Question 4

> _Why might leadership want to identify producers who have never been active?_

Knowing which or how many matches without participants exist in the system might
illuminate a problem where matches are being scheduled but not played, or the
matches may have been interrupted for some reason.

### Question 5

> _What action could leadership take based on these findings?_

If certain matches did not have any participants, leadership might determine
that the types of matches or the time at which they are scheduled are not
attracting players and no long offer similar matches. Further investigation
would be required to understand why the matches have not participants before any
decisions could be made.

## Task 5.3

### Part A

The smallest tables in the database are game_modes and players. game_modes has 5
rows and players has 30. The cartesian product found using CROSS JOIN returns
the expected product of 150 rows.

A CROSS JOIN is useful when a full matrix of results is required, for example
monthly sales figures against products for sale including the months where no
products were sold. Using a CROSS JOIN might be an error when one or both of the
tables involved is very large which could have performance limitations.

### Part B

The execution plan for the three-table join of 5.1 is:
```
Sort  (cost=35.98..36.48 rows=200 width=520)
"  Sort Key: m.match_label, p.player_name"
  ->  Hash Join  (cost=12.40..28.34 rows=200 width=520)
        Hash Cond: (mp.player_id = p.player_id)
        ->  Nested Loop  (cost=0.15..15.54 rows=200 width=266)
              ->  Seq Scan on match_participants mp  (cost=0.00..5.00 rows=200 width=8)
              ->  Memoize  (cost=0.15..0.41 rows=1 width=266)
                    Cache Key: mp.match_id
                    Cache Mode: logical
                    ->  Index Scan using matches_pkey on matches m  (cost=0.14..0.40 rows=1 width=266)
                          Index Cond: (match_id = mp.match_id)
        ->  Hash  (cost=11.00..11.00 rows=100 width=262)
              ->  Seq Scan on players p  (cost=0.00..11.00 rows=100 width=262)
```
The JOIN from match_participants to players is a Hash Join and the JOIN to
matches is a Nested Loop. The Hash Join was joining the largest table where an
index was not already available and the Nested Loop was over the smaller matches
table of only 15 rows. The Nested Loop will start to become inefficient as the
number of rows in the matches table grows.

### Question 1

> _Give an example of when a Cartesian product could be useful on your platform,
> or explain why you would not need one._

CROSS JOIN is useful to combine every possible combination of rows, one from
each table in the join. In the game telemetrics platform, I cannot think of a
good use of this type of join.

### Question 2

> _Which join algorithms did PostgreSQL choose for your query?_

PostgreSQL chose the Hash Join and Nested Loop.

### Question 3

> _What information in the execution plan helps explain those choices?_

The execution plan calculates a cost based on the number of rows and width of
the rows. Presumably it chooses the lowest cost algorithm to implement the join.

### Question 4

> _Why is it useful to understand the selected join algorithms?_

Knowing which join algorithms are used helps to predict potential performance
bottlenecks as the amount of data stored in the database grows. This may
influence when and where to use indexes or different key types.

### Question 5

> _What changes to the data or database might make another join algorithm more
> appropriate?_

Using a different key (e.g. an integer vs. a UUID) or adding an index to a table
might change the algorithm that PostgreSQL decides to use. Likewise adding more
data rows could have a similar effect.

## Reflection

There are several factors that influence PostgreSQL's choice of algorithm. Among those are table size, availability of indexes, and number of matching records. A smaller table could easily be handled by a nested loop and even more efficiently if the larger of the two tables has an index. If neither of the tables is small and no indexes are available, the nested loop would struggle to perform. In those situations, the hash join can provide better performance by first building a hash table of the join column values of the smaller table, then matching that with hashed values of the outer table as it is scanned row by row. Tables that are already sorted would be good candidates for a merge join. As discussed previously, using a different key or providing more indexes to a table might change the join algorithm as would increasing the number of rows in the table.