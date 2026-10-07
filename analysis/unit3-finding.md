Two to three paragraphs addressed to the team that owns the dashboard, in /analysis/unit3-finding.md.

State what the dashboard reported, what the data actually shows, where the error came from, and what should happen to the frozen payout. Write for a reader who does not write SQL: no queries, and no jargon they would not already know.

# Findings Regarding Dashboard Queries

This report documents the findings during investigation of the dashboard metrics
in question.

## The reported dashboard metrics

For the game telemetrics captured on the platform, the dashboard indicated that
many participants had network timeouts during match play. Specifically, the
dashboard showed that network timeouts affected 12 of 34 match participants.
This is an alarming rate of 35%.

## What the data shows

The data does not support the reported rate. In fact, the data shows that while
12 players were affected, there was a total 200 participants. And of those
affected, only 8 unique players were affected in ranked matches. This is only a 4%
rate.

## Where the error came from

It's believed the error came from a database query that neglected to account for
all match results because of the way the data is stored when participants
disconnect. No reason for disconnect is stored when a game ends normally.
Certain queries will fail to count matches with a missing reason.

## What to do about the frozen payouts

Payouts should be made to all games that ended normally and further
investigation made into the platform as to why there are network timeouts.
