#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # get winner team id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams where name='$WINNER'")
    # if not found
    if [[ -z $WINNER_ID ]]
    then
      # insert team name
      INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
      if [[ $INSERT_TEAM_RESULT = "INSERT 0 1" ]]
      then
        echo Insert into teams, $WINNER
      fi
      # get new winner team id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams where name='$WINNER'")
    fi

    # get opponent team id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams where name='$OPPONENT'")
    # if not found
    if [[ -z $OPPONENT_ID ]]
    then
      # insert team name
      INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
      if [[ $INSERT_TEAM_RESULT = "INSERT 0 1" ]]
      then
        echo Insert into teams, $OPPONENT
      fi
      # get new team name
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams where name='$OPPONENT'")
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # get winner team id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams where name='$WINNER'")
    # get opponent team id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams where name='$OPPONENT'")
    # insert into games
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME_RESULT = "INSERT 0 1" ]]
    then
      echo Insert into games, $YEAR $ROUND $WINNER_ID $OPPONENT_ID $WINNER_GOALS $OPPONENT_GOALS
    fi
  fi
done