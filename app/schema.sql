-- Date ... 05/07/2019
-- Desc ... schema.sql


-- 1. drop database (if exists): movieapp
SELECT '==== dropping database: movieapp' AS '';
DROP DATABASE IF EXISTS movieapp;


-- 2. create database: movieapp
SELECT '==== creating database: movieapp' AS '';
CREATE DATABASE movieapp
  DEFAULT CHARACTER SET utf8
  DEFAULT COLLATE utf8_general_ci;


-- 3. use as current db
USE movieapp;


-- 4. create table: directors
SELECT '=== creating table: directors' AS '';
CREATE TABLE directors
(
  name        VARCHAR (64) UNIQUE PRIMARY KEY,
  description VARCHAR (512)
)
ENGINE = InnoDB;


-- 5. create table: movies
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


-- display database metadata and data
SHOW DATABASES;

SHOW TABLES;

DESCRIBE directors;

DESCRIBE movies;

SELECT * FROM directors;

SELECT * FROM movies;

