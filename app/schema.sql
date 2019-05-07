-- Date ... 05/07/2019
-- Desc ... schema.sql


-- drop database (if exists): movieapp
SELECT '==== dropping database: movieapp' AS '';
DROP DATABASE IF EXISTS movieapp;


-- create database: movieapp
SELECT '==== creating database: movieapp' AS '';
CREATE DATABASE movieapp
  DEFAULT CHARACTER SET utf8
  DEFAULT COLLATE utf8_general_ci;


-- use as current db
USE movieapp;


-- create table: directors
SELECT '=== creating table: directors' AS '';
CREATE TABLE directors
(
  name        VARCHAR (64) UNIQUE PRIMARY KEY,
  description VARCHAR (512)
)
ENGINE = InnoDB;


-- create table: movies
SELECT '==== creating table: movies' AS '';
CREATE TABLE movies
(
  director_name VARCHAR (64),
  name          VARCHAR (64),
  description   VARCHAR (512),

  FOREIGN KEY (director_name) REFERENCES directors (name),
  INDEX (director_name)
)
ENGINE = InnoDB;


-- load directors
SELECT '==== loading directors:' AS '';
INSERT INTO directors VALUES ("McDonagh", "McDonagh is an Irish playwright, screenwriter, producer, and director. Born and brought up in London, the son of Irish parents.");
INSERT INTO directors VALUES ("Peele",    "He is best known for his film and television work in the comedy and horror genres.");
INSERT INTO directors VALUES ("Quentin",  "Tarantino is an American filmmaker and actor. His films are characterized by nonlinear storylines, satirical subject matter, an aestheticization of violence, extended scenes of dialogue, ensemble casts consisting of established and lesser-known performers, references to popular culture and a wide variety of other films, soundtracks primarily containing songs and score pieces from the 1960s to the 1980s, and features of neo-noir film.");
INSERT INTO directors VALUES ("Reitman",  "Jason Reitman is an American film director, screenwriter, and producer, best known for directing the films Thank You for Smoking (2005), Juno (2007), Up in the Air (2009), and Young Adult (2011). As of February 2, 2010, he has received one Grammy Award, one Golden Globe, and four Academy Award nominations, two of which are for Best Director. Reitman is a dual citizen of Canada and the United States.");
INSERT INTO directors VALUES ("Scorsese", "Scorsese is an American filmmaker and historian, whose career spans more than 50 years. His body of work addresses such themes as Italian and Sicilian-American identity, Roman Catholic concepts of guilt and redemption, faith, machismo, modern crime, and gang conflict. Many of his films are also known for their depiction of violence and liberal use of profanity.");

-- load movies
SELECT '==== loading movies:' AS '';

-- McDonagh
INSERT INTO movies VALUES ("McDonagh", "In_Bruges_2008", "Guilt-stricken after a job gone wrong, hitman Ray and his partner await orders from their ruthless boss in Bruges, Belgium, the last place in the world Ray wants to be.");
INSERT INTO movies VALUES ("McDonagh", "Seven_Psychopaths_2012", "A struggling screenwriter inadvertently becomes entangled in the Los Angeles criminal underworld after his oddball friends kidnap a gangsters beloved Shih Tzu.");
INSERT INTO movies VALUES ("McDonagh", "Six_Shooter_2004", "A black and bloody Irish comedy about a sad train journey where an older man, whose wife has died that morning, encounters a strange and possibly psychotic young oddball....");
INSERT INTO movies VALUES ("McDonagh", "The_Guard_2011", "An unorthodox Irish policeman with a confrontational personality is partnered with an up-tight F.B.I. agent to investigate an international drug-smuggling ring.");
INSERT INTO movies VALUES ("McDonagh", "Three_Billboards_Outside_Ebbing_Missouri_2017", "A mother personally challenges the local authorities to solve her daughters murder when they fail to catch the culprit.");

-- Peele 
INSERT INTO movies VALUES ("Peele", "Get_Out_2017", "A young African-American visits his white girlfriends parents for the weekend, where his simmering uneasiness about their reception of him eventually reaches a boiling point.");
INSERT INTO movies VALUES ("Peele", "Us_2019", "A serene beach vacation turns to chaos when their doppelgangers appear and begin to terrorize them.");

-- Quentin
INSERT INTO movies VALUES ("Quentin", "Jackie_Brown_1997", "A middle-aged woman finds herself in the middle of a huge conflict that will either make her a profit or cost her life.");
INSERT INTO movies VALUES ("Quentin", "Kill_Bill_V1_2003", "After awakening from a four-year coma, a former assassin wreaks vengeance on the team of assassins who betrayed her.");
INSERT INTO movies VALUES ("Quentin", "Kill_Bill_V2_2004", "The Bride continues her quest of vengeance against her former boss and lover Bill, the reclusive bouncer Budd, and the treacherous, one-eyed Elle.");
INSERT INTO movies VALUES ("Quentin", "Pulp_Fiction_1994", "The lives of two mob hitmen, a boxer, a gangsters wife, and a pair of diner bandits intertwine in four tales of violence and redemption.");
INSERT INTO movies VALUES ("Quentin", "Reservoir_Dogs_1992", "When a simple jewelry heist goes horribly wrong, the surviving criminals begin to suspect that one of them is a police informant.");

-- Reitman
INSERT INTO movies VALUES ("Reitman", "Juno_2007", "Faced with an unplanned pregnancy, an offbeat young woman makes an unusual decision regarding her unborn child.");
INSERT INTO movies VALUES ("Reitman", "Thank_You_For_Smoking_2005", "Satirical comedy follows the machinations of Big Tobaccos chief spokesman, Nick Naylor, who spins on behalf of cigarettes while trying to remain a role model for his twelve-year-old son.");
INSERT INTO movies VALUES ("Reitman", "Up_in_the_Air_2009", "Ryan Bingham enjoys living out of a suitcase for his job, travelling around the country firing people, but finds that lifestyle threatened by the presence of a potential love interest, and a new hire.");

-- Scorsese
INSERT INTO movies VALUES ("Scorsese", "Casino_1995", "A tale of greed, deception, money, power, and murder occur between two best friends: a mafia enforcer and a casino executive, compete against each other over a gambling empire, and over a fast living and fast loving socialite.");
INSERT INTO movies VALUES ("Scorsese", "Goodfellas_1990", "The story of Henry Hill and his life in the mob, covering his relationship with his wife Karen Hill and his mob partners Jimmy Conway and Tommy DeVito in the Italian-American crime syndicate.");
INSERT INTO movies VALUES ("Scorsese", "Kundun_1997", "From childhood to adulthood, Tibets fourteenth Dalai Lama deals with Chinese oppression and other problems.");
INSERT INTO movies VALUES ("Scorsese", "Mean_Streets_1973", "A small-time hood aspires to work his way up the ranks of a local mob.");
INSERT INTO movies VALUES ("Scorsese", "Raging_Bull_1980", "The life of boxer Jake LaMotta, as the violence and temper that leads him to the top in the ring destroys his life outside of it.");
INSERT INTO movies VALUES ("Scorsese", "Taxi_Driver_1976", "A mentally unstable veteran works as a nighttime taxi driver in New York City, where the perceived decadence and sleaze fuels his urge for violent action by attempting to liberate a presidential campaign worker and an underage prostitute.");
INSERT INTO movies VALUES ("Scorsese", "The_Color_of_Money_1986", "Fast Eddie Felson teaches a cocky but immensely talented protege the ropes of pool hustling, which in turn inspires him to make an unlikely comeback.");

-- display database metadata
SHOW DATABASES;
SHOW TABLES;
DESCRIBE directors;
DESCRIBE movies;

-- display database data
SELECT * FROM directors;
SELECT * FROM movies;

