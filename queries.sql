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

-- add "join table" for visits

-- Who was the last animal seen by William Tatcher?
SELECT a.name FROM animals AS a INNER JOIN visits AS j ON j.animals_id = a.id INNER JOIN vets AS v ON j.vets_id = v.id WHERE j.vets_id =1 AND j.date_of_visit = (SELECT MAX(date_of_visit) FROM visits WHERE vets_id = 1);

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(j.animals_id) FROM visits AS j LEFT JOIN vets AS v ON v.id = j.vets_id WHERE v.id = 3;

-- List all vets and their specialties, including vets with no specialties.
SELECT v.name, s.name FROM vets AS v FULL JOIN specialization AS j ON j.vets_id = v.id FULL JOIN species AS s ON s.id = j.species_id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name FROM animals AS a INNER JOIN visits AS j On j.animals_id = a.id INNER JOIN vets AS v ON v.id = j.vets_id WHERE j.vets_id = 3 AND j.date_of_visit BETWEEN '04-01-2020' AND '08-30-2020';

-- What animal has the most visits to vets
SELECT COUNT(j.animals_id) AS number_of_visits, a.name FROM visits AS j FULL JOIN animals AS a ON a.id = j.animals_id GROUP BY a.name;

-- Who was Maisy Smith's first visit?
SELECT a.name, a.id FROM animals AS a INNER JOIN visits AS j ON j.animals_id = a.id INNER JOIN vets AS v ON j.vets_id = v.id WHERE j.vets_id =2 AND j.date_of_visit = (SELECT MIN(date_of_visit) FROM visits WHERE vets_id = 2);

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT a.name AS animal_name, a.date_of_birth AS pet_dob, a.escape_attempts AS escapeAttempts, a.weight_kg AS weight, a.neutered AS neutered, v.name AS vet_name, v.age AS vet_age, v.date_of_graduation AS vets_graduation_date, j.date_of_visit AS vet_visit_date FROM visits AS j FULL JOIN animals AS a ON a.id = j.animals_id FULL JOIN vets AS v ON v.id = j.vets_id ORDER BY vet_visit_date DESC;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(j.animals_id) FROM visits AS j INNER JOIN vets AS v ON v.id = j.vets_id WHERE v.id NOT IN (SELECT vets_id FROM specialization);

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT COUNT(a.species_id) AS sv, s.name FROM animals AS a JOIN species AS s ON s.id = a.species_id INNER JOIN visits AS j ON j.animals_id = a.id INNER JOIN vets AS v ON v.id = j.vets_id WHERE v.id = 3 GROUP BY s.name ORDER by sv DESC LIMIT 1;
