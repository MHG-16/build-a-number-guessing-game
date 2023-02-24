#!/bin/bash

echo -e "\n~~ Number guessing game ~~\n"
MAIN(){
  echo -e "\nEnter your username:"
  read USER_NAME
  SEARCH_USER $USER_NAME
}

SEARCH_USER(){
  echo $1
}

MAIN