/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals where date_of_birth BETWEEN DATE '2016-01-01' AND '2019-01-01';
SELECT name FROM  animals WHERE neutered = 'yes' AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = 'yes';
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

  SELECT * FROM animals;

BEGIN TRANSACTION;
 
  UPDATE animals SET species = 'unspecified';

  SELECT * FROM animals;
 
ROLLBACK TRANSACTION;

  SELECT * FROM animals;

BEGIN TRANSACTION;

  UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

  UPDATE animals SET species = 'pokemon' WHERE name NOT LIKE '%mon';

COMMIT TRANSACTION;

  SELECT * FROM animals;

BEGIN TRANSACTION;

  DELETE FROM animals ;

  SELECT * FROM animals;

ROLLBACK TRANSACTION;

  SELECT * FROM animals;

BEGIN TRANSACTION;

  DELETE FROM animals WHERE date_of_birth > '2022-01-01';

  SAVEPOINT transaction;

  UPDATE animals SET weight_kg = weight_kg * -1;

  SELECT * FROM animals;

ROLLBACK TRANSACTION TO SAVEPOINT transaction;

  SELECT * FROM animals;

  UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;

  SELECT * FROM animals;

COMMIT TRANSACTION;

-- How many animals are there?
SELECT COUNT(*) AS count_of_animals FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT(*) AS count_of_not_escapeds FROM animals WHERE escape_attempts < 1;

-- What is the average weight of animals?
SELECT ROUND(AVG(weight_kg)) AS AVG FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT MAX(sum),neutered FROM( SELECT SUM(escape_attempts),neutered FROM animals GROUP BY neutered ) as max GROUP BY neutered;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, ROUND(AVG(escape_attempts)) AS AVG FROM animals WHERE date_of_birth BETWEEN '01-01-1990' AND '01-01-2000' GROUP BY species;

-- query multiple tables

-- What animals belong to Melody Pond?
SELECT animals.name, owners.full_name FROM animals JOIN owners ON animals.owner_id = owners.id WHERE full_name='Melody';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT animals.name AS animal_name, species.name AS species_type FROM animals JOIN species ON animals.species_id=species.id WHERE species.name='Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT full_name, animals.name FROM owners LEFT JOIN animals ON animals.owner_id = owners.id;

-- How many animals are there per species?
SELECT count(animals) FROM animals JOIN species ON animals.species_id = species.id;

-- List all Digimon owned by Jennifer Orwell.
SELECT animals.name FROM animals JOIN owners ON animals.owner_id=owners.id WHERE owners.full_name = 'Jennifer Orwell';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT species.name, count(animals) FROM animals JOIN species ON animals.species_id = species.id GROUP BY species.name;

-- Who owns the most animals?
SELECT owners.full_name , COUNT(animals.name) AS total_animals FROM owners JOIN animals ON animals.owner_id = owners.id GROUP BY owners.full_name ORDER BY total_animals DESC LIMIT 1;


