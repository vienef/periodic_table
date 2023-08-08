#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  if [[ $1 =~ [0-9]+ ]]
  then
    SELECTED_ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1;")
  elif [[ $1 =~ [a-zA-Z]{3,} ]]
  then
    SELECTED_ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$1';")
  elif [[ $1 =~ [a-zA-Z]{1,2} ]]
  then
    SELECTED_ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1';")
  fi

  if [[ -z $SELECTED_ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    FORMATTED_SELECTED_ELEMENT=$(echo $SELECTED_ELEMENT | sed -E 's/\|/ /g' | sed -E 's/(.+) (.+) (.+) (.+) (.+) (.+) (.+)/The element with atomic number \1 is \3 \(\2\)\. It\x27s a \7\, with a mass of \4 amu\. \3 has a melting point of \5 celsius and a boiling point of \6 celsius\./')
    echo $FORMATTED_SELECTED_ELEMENT
  fi
fi
