#!/bin/bash
echo -e "\n~~ Number guessing game ~~\n"
#globales variables
PSQL="psql -X --username=freecodecamp --dbname=number_guess -t --no-align -c"
SECRET=$(( $RANDOM % 100 + 1))

# READ USER NAME
echo -e "\nEnter your username:"
read USER_NAME
echo $SECRET

#MAIN FUNCTION
MAIN(){
  SEARCH_USER_ID $USER_NAME
  GAME
}

SEARCH_USER_ID(){
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$1'")
  if [[ -z $USER_ID ]]
  then
    echo -e "\nWelcome, $1! It looks like this is your first time here."
    INSERT_USER_RESULT=$($PSQL "INSERT INTO users(name) VALUES ('$1')")
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$1'")
  else
    BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id=$USER_ID")
    GUESSES=$($PSQL "SELECT COUNT(*) AS guess_total FROM games WHERE user_id=$USER_ID")
    echo "Welcome back, $1! You have played $GUESSES games, and your best game took $BEST_GAME guesses."
  fi
}

GAME() {
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USER_NAME'")
  echo -e "\nGuess the secret number between 1 and 1000:"
  read GUESS
  NUMBER_OF_GUESSES=0
  while true 
  do
    NUMBER_OF_GUESSES=$(( $NUMBER_OF_GUESSES + 1 ))
    if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
      echo -e "\nThat is not an integer, guess again:"
      read GUESS
    elif [[ $GUESS > $SECRET ]]
    then
      echo -e "\nIt's higher than that, guess again:"
      read GUESS
    elif [[ $GUESS < $SECRET ]]
    then
      echo -e "\nIt's lower than that, guess again:"
      read GUESS
    else
      echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET. Nice job!"
      INSERT_GUESSES_RESULT=$($PSQL "INSERT INTO games(guesses, user_id) VALUES($NUMBER_OF_GUESSES, $USER_ID)")
      break;
    fi
  done
}


MAIN