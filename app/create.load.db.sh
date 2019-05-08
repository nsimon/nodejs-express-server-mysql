#!/bin/bash

# Date ..... 05/07/2019
# Module ... create.load.db.sh
# Desc ..... wrapper to run mysql with 'schema.sql'
#            creates log file

printf "create.load.db.sh\n"
printf "\n"

mysql --user=nsimon --password='cwb206' --table < schema.sql | tee create.load.db.log

printf "\n"
printf "database loaded: movieapp\n"
printf "\n"

