#!/bin/bash

# Date ... 04/23/2019
# Desc ... create.load.db.sh

# Standalone script to "drop, create, then load" the movieapp database:
#   . drop db (if exists)
#   . create db
#   . load directors
#   . load movies

# mongodb database schema:
#
# database: movieapp
#
# collection: directors
#   { "_id" : "Peele",
#     "name" : "Peele",
#     "description" : "He is best known for his film and television work in the comedy and horror genres." }
#   
# collection: movies
#   { "_id" : "Get_Out_2017",
#     "directors_id" : "Peele",
#     "name" : "Get_Out_2017",
#     "description" : "A young African-American visits his white girlfriends parents for the weekend, where his simmering uneasiness about their reception of him eventually reaches a boiling point." }

printf "create.load.db.sh\n"
printf "\n"

printf "==================\n"
printf "db.dropDatabase ()\n"
printf "==================\n"
printf "\n"
mongo movieapp --quiet --eval 'db.dropDatabase ()'
printf "\n"

################################################################################
# collection: users                                                            #
################################################################################

printf "================\n"
printf "db.users.save ()\n"
printf "================\n"
printf "\n"

mongo movieapp --quiet --eval 'db.users.save
  ({ "_id" : "nsimon", "username" : "nsimon" })'

printf "\n"

################################################################################
# collection: directors                                                        #
################################################################################

printf "====================\n"
printf "db.directors.save ()\n"
printf "====================\n"
printf "\n"

mongo movieapp --quiet --eval 'db.directors.save
  ({ "_id" : "McDonagh", "name" : "McDonagh",
     "description" : "McDonagh is an Irish playwright, screenwriter, producer, and director. Born and brought up in London, the son of Irish parents." })'

mongo movieapp --quiet --eval 'db.directors.save
  ({ "_id" : "Peele",    "name" : "Peele",
     "description" : "He is best known for his film and television work in the comedy and horror genres." })'

mongo movieapp --quiet --eval 'db.directors.save
  ({ "_id" : "Quentin",  "name" : "Quentin", 
     "description" : "Tarantino is an American filmmaker and actor. His films are characterized by nonlinear storylines, satirical subject matter, an aestheticization of violence, extended scenes of dialogue, ensemble casts consisting of established and lesser-known performers, references to popular culture and a wide variety of other films, soundtracks primarily containing songs and score pieces from the 1960s to the 1980s, and features of neo-noir film." })'

mongo movieapp --quiet --eval 'db.directors.save
  ({ "_id" : "Reitman",  "name" : "Reitman",
     "description" : "Jason Reitman is an American film director, screenwriter, and producer, best known for directing the films Thank You for Smoking (2005), Juno (2007), Up in the Air (2009), and Young Adult (2011). As of February 2, 2010, he has received one Grammy Award, one Golden Globe, and four Academy Award nominations, two of which are for Best Director. Reitman is a dual citizen of Canada and the United States." })'

mongo movieapp --quiet --eval 'db.directors.save
  ({ "_id" : "Scorsese", "name" : "Scorsese",
     "description" : "Scorsese is an American filmmaker and historian, whose career spans more than 50 years. His body of work addresses such themes as Italian and Sicilian-American identity, Roman Catholic concepts of guilt and redemption, faith, machismo, modern crime, and gang conflict. Many of his films are also known for their depiction of violence and liberal use of profanity." })'

printf "\n"

################################################################################
# collection: movies                                                           #
################################################################################

printf "=================\n"
printf "db.movies.save ()\n"
printf "=================\n"
printf "\n"

############
# McDonagh #
############

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "In_Bruges_2008", "name" : "In_Bruges_2008", "directors_id" : "McDonagh",
     "description" : "Guilt-stricken after a job gone wrong, hitman Ray and his partner await orders from their ruthless boss in Bruges, Belgium, the last place in the world Ray wants to be." })'

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "Seven_Psychopaths_2012", "name" : "Seven_Psychopaths_2012", "directors_id" : "McDonagh",
     "description" : "A struggling screenwriter inadvertently becomes entangled in the Los Angeles criminal underworld after his oddball friends kidnap a gangsters beloved Shih Tzu." })'

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "Six_Shooter_2004", "name" : "Six_Shooter_2004", "directors_id" : "McDonagh",
     "description" : "A black and bloody Irish comedy about a sad train journey where an older man, whose wife has died that morning, encounters a strange and possibly psychotic young oddball...." })'

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "The_Guard_2011", "name" : "The_Guard_2011", "directors_id" : "McDonagh",
     "description" : "An unorthodox Irish policeman with a confrontational personality is partnered with an up-tight F.B.I. agent to investigate an international drug-smuggling ring." })'

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "Three_Billboards_Outside_Ebbing_Missouri_2017", "name" : "Three_Billboards_Outside_Ebbing_Missouri_2017", "directors_id" : "McDonagh",
     "description" : "A mother personally challenges the local authorities to solve her daughters murder when they fail to catch the culprit." })'

#########
# Peele #
#########

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "Get_Out_2017", "name" : "Get_Out_2017", "directors_id" : "Peele",
     "description" : "A young African-American visits his white girlfriends parents for the weekend, where his simmering uneasiness about their reception of him eventually reaches a boiling point." })'

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "Us_2019", "name" : "Us_2019", "directors_id" : "Peele",
     "description" : "A serene beach vacation turns to chaos when their doppelgangers appear and begin to terrorize them." })'

###########
# Quentin #
###########

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "Jackie_Brown_1997", "name" : "Jackie_Brown_1997", "directors_id" : "Quentin",
     "description" : "A middle-aged woman finds herself in the middle of a huge conflict that will either make her a profit or cost her life." })'

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "Kill_Bill_V1_2003", "name" : "Kill_Bill_V1_2003", "directors_id" : "Quentin",
     "description" : "After awakening from a four-year coma, a former assassin wreaks vengeance on the team of assassins who betrayed her." })'

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "Kill_Bill_V2_2004", "name" : "Kill_Bill_V2_2004", "directors_id" : "Quentin",
     "description" : "The Bride continues her quest of vengeance against her former boss and lover Bill, the reclusive bouncer Budd, and the treacherous, one-eyed Elle." })'

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "Pulp_Fiction_1994", "name" : "Pulp_Fiction_1994", "directors_id" : "Quentin",
     "description" : "The lives of two mob hitmen, a boxer, a gangsters wife, and a pair of diner bandits intertwine in four tales of violence and redemption." })'

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "Reservoir_Dogs_1992", "name" : "Reservoir_Dogs_1992", "directors_id" : "Quentin",
     "description" : "When a simple jewelry heist goes horribly wrong, the surviving criminals begin to suspect that one of them is a police informant." })'

###########
# Reitman #
###########

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "Juno_2007", "name" : "Juno_2007", "directors_id" : "Reitman",
     "description" : "Faced with an unplanned pregnancy, an offbeat young woman makes an unusual decision regarding her unborn child." })'

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "Thank_You_For_Smoking_2005", "name" : "Thank_You_For_Smoking_2005", "directors_id" : "Reitman",
     "description" : "Satirical comedy follows the machinations of Big Tobaccos chief spokesman, Nick Naylor, who spins on behalf of cigarettes while trying to remain a role model for his twelve-year-old son." })'

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "Up_in_the_Air_2009", "name" : "Up_in_the_Air_2009", "directors_id" : "Reitman",
     "description" : "Ryan Bingham enjoys living out of a suitcase for his job, travelling around the country firing people, but finds that lifestyle threatened by the presence of a potential love interest, and a new hire." })'

############
# Scorsese #
############

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "Casino_1995", "name" : "Casino_1995", "directors_id" : "Scorsese",
     "description" : "A tale of greed, deception, money, power, and murder occur between two best friends: a mafia enforcer and a casino executive, compete against each other over a gambling empire, and over a fast living and fast loving socialite." })'

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "Goodfellas_1990", "name" : "Goodfellas_1990", "directors_id" : "Scorsese",
     "description" : "The story of Henry Hill and his life in the mob, covering his relationship with his wife Karen Hill and his mob partners Jimmy Conway and Tommy DeVito in the Italian-American crime syndicate." })'

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "Kundun_1997", "name" : "Kundun_1997", "directors_id" : "Scorsese",
     "description" : "From childhood to adulthood, Tibets fourteenth Dalai Lama deals with Chinese oppression and other problems." })'

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "Mean_Streets_1973", "name" : "Mean_Streets_1973", "directors_id" : "Scorsese",
     "description" : "A small-time hood aspires to work his way up the ranks of a local mob." })'

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "Raging_Bull_1980", "name" : "Raging_Bull_1980", "directors_id" : "Scorsese",
     "description" : "The life of boxer Jake LaMotta, as the violence and temper that leads him to the top in the ring destroys his life outside of it." })'

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "Taxi_Driver_1976", "name" : "Taxi_Driver_1976", "directors_id" : "Scorsese",
     "description" : "A mentally unstable veteran works as a nighttime taxi driver in New York City, where the perceived decadence and sleaze fuels his urge for violent action by attempting to liberate a presidential campaign worker and an underage prostitute." })'

mongo movieapp --quiet --eval 'db.movies.save
  ({ "_id" : "The_Color_of_Money_1986", "name" : "The_Color_of_Money_1986", "directors_id" : "Scorsese",
     "description" : "Fast Eddie Felson teaches a cocky but immensely talented protege the ropes of pool hustling, which in turn inspires him to make an unlikely comeback." })'

printf "\n"

################################################################################
# display results                                                              #
################################################################################

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


