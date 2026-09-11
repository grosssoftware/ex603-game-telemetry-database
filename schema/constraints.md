# Constraints

This file describes the constraints between relations in a schema to model an online gaming platform.

## Match Participants

The `match_participants` relation keeps track of which players are in which matches. The foreign keys (FK) used for referential integrity are:

1. A FK to the `match_id` primary key (PK) of the `matches` relation. The ON DELETE behavior is RESTRICT. We do not allow deleting a match if there any players in it.
2. A FK to the `player_id` PK of the `players` relation. The ON DELETE behavior is CASCADE. If a player is deleted, we remove it from the match by also deleting their entry in `match_participants`.

## Match Modes

The `match_modes` relation keeps track of which game modes a match is using. The FK used for referential integrity are:

1. A FK to the `match_id` PK of the `matches` relation. The ON DELETE behavior is CASCADE. If the match is deleted, we no longer need to store any associated game modes.
2. A FK to the `game_mode_id` PK of the `game_modes` relation. The ON DELETE behavior is RESTRICT. We do not allow removing a game mode from the lookup table if any matches have are using it.