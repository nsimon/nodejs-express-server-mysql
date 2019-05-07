#!/bin/bash

# Module ... tester.sh
# Desc ..... Test script to run client cURL calls to the nodejs/express server.


get_all_directors ()
    {
    printf "=================\n"
    printf "Get all directors\n"
    printf "=================\n"
    printf "\n"
    curl --request GET http://localhost:8080/v1/directors.json
    printf "\n"
    printf "\n"
    }

get_one_director_and_their_movies ()
    {
    printf "=================================\n"
    printf "Get one director and their movies\n"
    printf "=================================\n"
    printf "\n"
    printf "curl: GET: /v1/directors/Quentin.json\n"
    printf "\n"
    curl --request GET http://localhost:8080/v1/directors/Quentin.json
    printf "\n"
    printf "\n"
    }

get_all_movies_by_a_director ()
    {
    printf "============================\n"
    printf "Get all movies by a director\n"
    printf "============================\n"
    printf "\n"
    printf "curl: GET: /v1/directors/Quentin/movies.json\n"
    printf "\n"
    curl --request GET http://localhost:8080/v1/directors/Quentin/movies.json
    printf "\n"
    printf "\n"
    }

get_one_movie_by_a_director ()
    {
    printf "===========================\n"
    printf "Get one movie by a director\n"
    printf "===========================\n"
    printf "\n"
    printf "curl: GET: /v1/directors/Quentin/movies/Pulp_Fiction_1994.json\n"
    printf "\n"
    curl --request GET http://localhost:8080/v1/directors/Quentin/movies/Pulp_Fiction_1994.json
    #curl --request GET http://localhost:8080/v1/directors/Quentin/movies/bogus_1994.json
    printf "\n"
    printf "\n"
    }

put_create_one_director ()
    {
    printf "=======================\n"
    printf "Creating a new director\n"
    printf "=======================\n"
    printf "\n"
    printf "/static/directors/ BEFORE:\n"
    ls -l $DIRECTOR_FOLDER 2>&1
    printf "\n"
    printf "curl: PUT: /v1/directors/Landis.json\n"
    printf "\n"
    JSON_OUT="{ \"_id\" : \"Landis\", \"name\" : \"Landis\", \"description\" : \"John Landis began his career in the mail room of 20th Century-Fox. A high-school dropout, 18-year-old Landis made his way to Yugoslavia to work as a production assistant on Kelly's Heroes (1970). Remaining in Europe, Landis found work as an actor, extra and stuntman in many of the Spanish/Italian "spaghetti" westerns.\" }"
    curl --request PUT \
         --header  "Content-Type: application/json" \
         --data "$JSON_OUT" \
         http://localhost:8080/v1/directors/Landis.json
    printf "\n"
    printf "\n"
    printf "/static/directors/ AFTER:\n"
    ls -l $DIRECTOR_FOLDER 2>&1
    printf "\n"
    }

put_create_movie_for_director ()
    {
    printf "=============================\n"
    printf "Creating movie for a director\n"
    printf "=============================\n"
    printf "\n"
    printf "/static/directors/Landis/ BEFORE:\n"
    ls -l $DIRECTOR_FOLDER/Landis/*.* 2>&1
    printf "\n"
    printf "curl: PUT: /v1/directors/Landis/movies.json\n"
    printf "\n"

    # (1) Add the movie fields to mongodb
    JSON_OUT="{ \"_id\" : \"Animal_House_1978\", \"name\" : \"Animal_House_1978\", \"directors_id\" : \"Landis\", \"description\" : \"At a 1962 college, Dean Vernon Wormer is determined to expel the entire Delta Tau Chi Fraternity, but those troublemakers have other plans for him.\" }"
    curl --request PUT \
         --header  "Content-Type: application/json" \
         --data "$JSON_OUT" \
         http://localhost:8080/v1/directors/Landis/movies.json
    printf "\n"
    printf "\n"

    # (2) Upload the poster
    curl --request PUT \
         --header "Expect:" \
         --form "moviejpg=@movies_to_upload/Landis/Animal_House_1978.jpg" \
         http://localhost:8080/v1/directors/Landis/movies.json
    printf "\n"

    printf "\n"
    printf "/static/directors/Landis/ AFTER:\n"
    ls -l $DIRECTOR_FOLDER/Landis/*.* 2>&1
    printf "\n"
    }

delete_director_and_their_movies ()
    {
    printf "===========================================\n"
    printf "Deleting a director and all of their movies\n"
    printf "===========================================\n"
    printf "\n"
    printf "/static/directors/Landis BEFORE:\n"
    ls -l $DIRECTOR_FOLDER/Landis/*.* 2>&1
    printf "\n"
    printf "curl: DELETE: /v1/directors/Landis.json\n"
    printf "\n"
    JSON_OUT="{ \"directorName\": \"Landis\" }"
    curl --request DELETE \
         --header 'Content-Type: application/json' \
         --data "$JSON_OUT" \
         http://localhost:8080/v1/directors/Landis.json
    printf "\n"
    printf "\n"
    printf "/static/directors/Landis AFTER:\n"
    ls -l $DIRECTOR_FOLDER 2>&1
    printf "\n"
    }

delete_one_movie ()
    {
    printf "==================\n"
    printf "Deleting one movie\n"
    printf "==================\n"
    printf "\n"
    printf "curl: DELETE: /v1/directors/Landis/movies.json\n"
    printf "\n"
    JSON_OUT="{ \"name\": \"Animal_House_1978\" }"
    curl --request DELETE \
         --header 'Content-Type: application/json' \
         --data "$JSON_OUT" \
         http://localhost:8080/v1/directors/Landis/movies.json
    printf "\n"
    printf "\n"
    }

###########
# main () #
###########

DIRECTOR_FOLDER=~/cwb206/week12/nodejs-express-server-mongodb/static/directors

main ()
    {
    printf "tester.sh.\n"
    printf "\n"

    #get_all_directors                   # mongo-ready
    #get_one_director_and_their_movies   # mongo-ready
    #get_all_movies_by_a_director        # mongo-ready
    #get_one_movie_by_a_director         # mongo-ready

    #put_create_one_director             # mongo-ready   // Landis
    #put_create_movie_for_director       # mongo-ready   // Landis/Animal_House_1978

    #delete_director_and_their_movies
    delete_one_movie

    printf "====\n"
    printf "Done\n"
    printf "====\n"
    printf "\n"
    }

main

