# Unit 2

## Foreign Key Constraints

The schema defines four foreign key constraints. Their use is the same as in Unit 1.

| Foreign Key Constraint Name     | ON DELETE | Reasoning                               |
| ------------------------------- | --------- | --------------------------------------- |
| fk_match_modes_match_id         | CASCADE   | delete games modes of deleted matches   |
| fk_match_modes_game_mode_id     | RESTRICT  | don't delete game modes used by matches |
| fk_match_participants_match_id  | RESTRICT  | don't delete matches with players in it |
| fk_match_participants_player_id | SET NULL  | keep player's stats if they are removed |

I chose ON DELETE behaviors on foreign key constraints to ease application programming by enforcing these rules in the schema:
1. I chose the RESTRICT behavior for the `match_participants` foreign key to the `match_id` primary key of the `matches` relation. This behavior makes it impossible to delete a match if there are players in it. I anticipate that once players are added to a match, the records will be maintained for historical purposes. A match can only be deleted if there are no players, indicating the game never started.
2. I chose the SET NULL behaior for the `match_participants` foreign key to the `player_id` primary key of the `players` relation. This behavior allows a player statistics to remain a part of the match even after the player has been deleted. This allows us to keep an accurate record of the number of players that played in a match even after a player's account is removed.
3. I chose the CASCADE behavior for the `match_modes` foreign key to the `match_id` primary key of the `matches` relation. If the match is deleted, I no longer need to store any game modes associated with the match. Since matches can only be deleted when there are no players in it, it is anticipated this would be used when deleting a match that was setup but never commenced.
4. I chose the RESTRICT behavior for the `match_modes` foreign key to the `game_mode_id` primary key of the `game_modes` relation. This behavior makes it impossible to remove a game mode from the lookup table if any matches have that mode.

## CHECK Constraints

The schema defines two CHECK constraints.

| CHECK Constraint Name | Expression               |
| --------------------- | ------------------------ |
| ck_players_name       | name ~ '^[a-zA-Z0-9_]+$' |

I chose the CHECK constraints to ease application programming by enforcing these rules in the schema:
1. The `players` table has a `name` column with a CHECK constraint that prevents characters other than alphanumerics and an underscore. Platform users enter the name and we want to prevent unwanted characters from appearing in the name which will be displayed during gameplay.
2. The `matches` table has a `name` column with a CHECK constraint that prevents characters other than alphanumerics and an underscore. Similarly to players' names, platform users enter the match name and we want to prevent unwanted characters from appearing in the name which will be displayed during gameplay.
