/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(100),
    date_of_birth DATE,
    escape_attempts INT,
    neutered boolean,
    weight_kg DECIMAL
);

ALTER TABLE animals ADD species varchar(255);

CREATE TABLE owners (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    age INT NOT NULL
);

CREATE TABLE species (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

ALTER TABLE animals DROP COLUMN id;  

ALTER TABLE animals ADD COLUMN id SERIAL PRIMARY KEY;

ALTER TABLE animals DROP COLUMN species;

ALTER TABLE animals ADD COLUMN species_id INT,
  ADD CONSTRAINT fk_species
  FOREIGN KEY (species_id)
  REFERENCES species (id);

ALTER TABLE animals ADD COLUMN owner_id INT,
  ADD CONSTRAINT fk_owners
  FOREIGN KEY (owner_id)
  REFERENCES owners (id);