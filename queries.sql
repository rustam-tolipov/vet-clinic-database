/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals where date_of_birth BETWEEN DATE '2016-01-01' AND '2019-01-01';
SELECT name FROM  animals WHERE neutered = 'yes' AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = 'yes';
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

BEGIN TRANSACTION;
 
  UPDATE animals SET species = 'unspecified';
 
ROLLBACK TRANSACTION;

BEGIN TRANSACTION;

  UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

  UPDATE animals SET species = 'pokemon' WHERE name NOT LIKE '%mon';

COMMIT TRANSACTION;

  SELECT * FROM animals;

BEGIN TRANSACTION;

  DELETE FROM animals ;

ROLLBACK TRANSACTION;

  SELECT * FROM animals;

BEGIN TRANSACTION;

  DELETE FROM animals WHERE date_of_birth > '2022-01-01';

  SAVEPOINT transaction;

  UPDATE animals SET weight_kg = weight_kg * -1;

ROLLBACK TRANSACTION TO SAVEPOINT transaction;

  UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;


COMMIT TRANSACTION;

-- How many animals are there?
SELECT COUNT(*) AS count_of_animals FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT(*) AS count_of_not_escapeds FROM animals WHERE escape_attempts > 1;

-- What is the average weight of animals?
SELECT ROUND(AVG(weight_kg)) AS AVG FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT MAX(sum),neutered FROM( SELECT SUM(escape_attempts),neutered FROM animals GROUP BY neutered ) as max GROUP BY neutered;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT name, ROUND(AVG(escape_attempts)) AS AVG FROM animals WHERE date_of_birth BETWEEN '01-01-1990' AND '01-01-2000' GROUP BY name;