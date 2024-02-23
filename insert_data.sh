#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.




# This line clears all the data from both tables
echo $($PSQL "TRUNCATE TABLE games, teams;")




# Reading the file
# INSERTING WINNERS on TEAMS
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #Skips the first line (title)
  if [[ $YEAR != "year" ]]
  then
    # Checks if the winner is on the database
    # If the winner does not exist then its inserted
    WINNER_TEAM=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    
    if [[ -z $WINNER_TEAM ]]
    then
      echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
  fi
done




# Reading the file again
# INSERTING OPPONENTS on TEAMS
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #Skips the first line (title)
  if [[ $YEAR != "year" ]]
  then
    OPPONENT_TEAM=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    
    if [[ -z $OPPONENT_TEAM ]]
    then
      echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
  fi
done




# Reading the file again
# INSERTING GAMES
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Skips the first line (title)
  if [[ $YEAR != "year" ]]
  then

    # Recovering the teams ids
    CURRENT_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    CURRENT_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # Inserting the teams
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $CURRENT_WINNER, $CURRENT_OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done
