# Schema Definition

This file describes a schema to model an online gaming platform.

## Relations

The schema relations are as follows.

### Players

Describes an actor (the player) who is using the online gaming platform.

| Attribute | Domain  | PK? |
| --------- | ------- | --- |
| player_id | int     | yes |
| name      | varchar | no  |

### Matches

Describes a producer (the match) of events.

| Attribute     | Domain  | PK? |
| ------------- | ------- | --- |
| match_id      | int     | yes |
| name          | varchar | no  |
| activity_flag | boolean | no  |
| match_number  | int     | no  |

### Match Participants

Describes an event (a match and its participants). This junction table keeps track of which players are in which matches.

| Attribute | Domain    | PK? |
| --------- | --------- | --- |
| match_id  | int       | yes |
| player_id | int       | yes |
| timestamp | timestamp | no  |
| score     | int       | no  |

### Game Modes

A lookup table (catalog) defining the different possible game modes.

| Attribute    | Domain  | PK? |
| ------------ | ------- | --- |
| game_mode_id | int     | yes |
| name         | varchar | no  |

### Match Modes

A junction table connecting matches to game modes.

| Attribute    | Domain | PK? |
| ------------ | ------ | --- |
| match_id     | int    | yes |
| game_mode_id | int    | yes |
