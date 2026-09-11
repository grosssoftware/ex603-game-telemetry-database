# Unit 1

## Modelling Justification

Choosing primary keys for the model was straightforward. Primary keys must be unique. For the `players` relation, I chose a simple integer identifier named `player_id`. The only other attribute for a player at this time is `name` which does not need to be unique so could not be used as a primary key. Similarly, for the `matches` relation, I also chose an integer identifier named `match_id`. Again, the other attributes defined for a match are not unique so could not be used as a primary key. For the `game_modes` relation I also chose an integer identifier named `game_id` as primary key. In this case, the game mode names should be unique, so the theoretically the name could have been a primary key, but I created the explicit identifier for consisentecy sake. This also allows us to modify the names later with no special ON UPDATE rules.

I chose ON DELETE behaviors on foreign key constraints to ease application programming by enforcing these rules in the schema. There are four specific behaviors:
1. I chose the RESTRICT behavior for the `match_participants` foreign key to the `match_id` primary key of the `matches` relation. This behavior makes it impossible to delete a match if there are players in it. I anticipate that once players are added to a match, the records will be maintained for historical purposes. A match can only be deleted if there are no players, indicating the game never started.
2. I chose the SET NULL behaior for the `match_participants` foreign key to the `player_id` primary key of the `players` relation. This behavior allows a player statistics to remain a part of the match even after the player has been deleted. This allows us to keep an accurate record of the number of players that played in a match even after a player's account is removed.
3. I chose the CASCADE behavior for the `match_modes` foreign key to the `match_id` primary key of the `matches` relation. If the match is deleted, I no longer need to store any game modes associated with the match. Since matches can only be deleted when there are no players in it, it is anticipated this would be used when deleting a match that was setup but never commenced.
4. I chose the RESTRICT behavior for the `match_modes` foreign key to the `game_mode_id` primary key of the `game_modes` relation. This behavior makes it impossible to remove a game mode from the lookup table if any matches have that mode.

## Reflection

Many of the decisions in the current design reflect the starting point that was given by the choice of theme and the specified roles for this exercise. There are at least two items that could easily be implemented in other ways.

First, the choice of ON DELETE behaviors was made to ease application programming by preventing the deletion of, or automatically deleting, relations by using RESTRICT, CASCADE and SET NULL behaviors. The justifications for these decisions is discussed in the previous section. When CASCADE and SET NULL are used, I reduce the number of database writes the application must make to delete or modify related data. When RESTRICT is used, I reduce the number of reads the application must make to check if a delete is allowed.

 Second, the use of the `match_modes` relation as a junction table provides a many-to-many relationship that seems odd. My experience with online gaming is usually there would be only one game mode selected. Maybe in a future unit the cardinality of this relation will be changed.