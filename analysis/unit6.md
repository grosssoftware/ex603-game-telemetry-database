# Unit 6

## Task 6.1

### Question 1
 
> _Write a question that needs each row shown next to its group’s average.
> Explain why the group average alone (GROUP BY) cannot answer it._

A question needed each row shown next to its group's average could be: What is
each player's score in a match compared to the match average (i.e. did they do
better or worse than average)? GROUP BY loses individual event details such as
the player's ID and score which cannot answer the question.

### Question 2

> _Ranking is never neutral: someone is being ordered, and tie handling decides
> who counts as equal. Name a platform feature that would use your ranking, and
> explain which of the three functions it should use and why._

A leaderboard showing high scores on the platform would require a ranking
feature. For a gaming platform, the RANK() function would be most appropriate
because players with the same high score would expect to have the same rank on
the leaderboard. DENSE_RANK() would not make sense as leaderboards use
traditional ranking where your rank is determined by the number of players ahead
of you.

## Task 6.2

### Question 1

> _What would a large delta tell someone about your platform, and what should
> they do about it?_

A large delta on the gaming platform could mean a wide range of player
experience, from rookies to experts, have joined the same match. This could
inform stakeholders to create a feature where matches are only open to players
of certain experience levels. 

### Question 2

> _Why does a running total answer a question that a plain SUM cannot?_

The running total or moving average show trends over time whereas the SUM is a
single overall metric that doesn't provide and correlation with time.

### Question 3

> _Why did you pick your moving-average window size? A different size tells a
> different story._

For the analysis over a one quarter (3 month) time period, about a week-sized
window just intuitively feels like the right amount of time for the moving
average. There are 13 weeks in a quarter.

### Question 4

> _What does a gap mean in your platform: a data quality problem, a real stop in
> activity, or a side effect of how events were recorded? Each needs a different
> response. Say which one yours is and how you know._

Because the platform tracks when participants joined a match and how they
disconnected, I assume the issue is a real stop in activity.

## Task 6.3

### Question 1

> _Name the feature in your platform that top-N would power. Explain why three
> is the right number, rather than one or ten._

The query could provide a leaderboard for each match that shows the top three
player scores. Competitions general have a 1st, 2nd, and 3rd place, so this
seems like the right number for the gaming platform.

### Question 2

> _What would a large month-over-month change mean in your domain, and what
> should someone do about it? A number nobody acts on is not a metric._

A large change in monthly average score could reflect a different mix of player
experience levels or match conditions. Or it could be an issue with game
balance. The drop in average score from February to March warrants checking
data and segmenting by mode, region, and ranked status before changing game
balance.

## Reflection

A typical question where using windows instead of GROUP BY would be "how does a
player's score in the match compare to the average match score?" Question 1 of
Task 6.1 explored this question and provided two queries that demonstrate the
difference between using the window function and GROUP BY. It showed that the
window function using OVER(PARTITION BY match_id) returns one row for each
player including their score as well as the computed average score for the
match. In contrast, GROUP BY returns only one row for each match with its
average player score. A single query using GROUP BY doesn't allow comparison of
individual players' scores from that match. Additionally, the window function
using OVER() can provide direct comparisons using mathematical operations to
produce tiers, deltas, or percent of average metrics which can be useful in
determining high and low performing players. The amount of detail gained with
the window function over GROUP BY in just a single query is beneficial
especially when the number of rows gets huge.
