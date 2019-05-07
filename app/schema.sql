-- Date ... 05/07/2019
-- Desc ... schema.sql


-- 1. drop database (if exists): movieapp
SELECT 'Dropping database: movieapp' AS '';
DROP DATABASE IF EXISTS movieapp;


-- 2. create database: movieapp
SELECT 'Creating database: movieapp' AS '';
CREATE DATABASE movieapp
  DEFAULT CHARACTER SET utf8
  DEFAULT COLLATE utf8_general_ci;


-- 3. use as current db
USE movieapp;


-- 4. create table: directors
SELECT 'Creating table: directors' AS '';
CREATE TABLE directors
(
  name        VARCHAR (64) UNIQUE PRIMARY KEY,
  description VARCHAR (512)
)
ENGINE = InnoDB;


-- 5. create table: movies
SELECT 'Creating table: movies' AS '';
CREATE TABLE movies
(
  director_name VARCHAR (64),
  name          VARCHAR (64),
  description   VARCHAR (512),

  FOREIGN KEY (director_name) REFERENCES directors (name),
  INDEX (director_name)
)
ENGINE = InnoDB;

SELECT '==== databases:' AS '';
SHOW DATABASES;

SELECT '==== tables:' AS '';
SHOW TABLES;

SELECT '==== directors: table description:' AS '';
DESCRIBE directors;

SELECT '==== movies: table description:' AS '';
DESCRIBE movies;

SELECT '==== directors: all rows:' AS '';
SELECT * FROM directors;

SELECT '==== movies: all rows:' AS '';
SELECT * FROM movies;

