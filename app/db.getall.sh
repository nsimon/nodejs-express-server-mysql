#!/bin/bash

# Date ..... 05/07/2019
# Module ... db.getall.sh
# Desc ..... displays all rows in directors and movies

mysql --user=nsimon --password='cwb206' --table < allrows.sql | tee allrows.log

