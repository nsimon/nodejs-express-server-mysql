#!/bin/bash

# Date ... 04/23/2019
# Desc ... db.getall.sh

# Gets all documents in all collections

printf "db.getall.sh\n"
printf "\n"

printf "========================\n"
printf "db.getCollectionNames ()\n"
printf "========================\n"
printf "\n"
mongo movieapp --quiet --eval "db.getCollectionNames ()"
printf "\n"

printf "================\n"
printf "db.users.find ()\n"
printf "================\n"
printf "\n"
mongo movieapp --quiet --eval "db.users.find ()"
printf "\n"

printf "====================\n"
printf "db.directors.find ()\n"
printf "====================\n"
printf "\n"
mongo movieapp --quiet --eval "db.directors.find ()"
printf "\n"

printf "=================\n"
printf "db.movies.find ()\n"
printf "=================\n"
printf "\n"
mongo movieapp --quiet --eval "db.movies.find ()"
printf "\n"

