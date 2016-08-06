/*
SQL Bridge Course Final - Building Energy
Author: Ken Howes
Date: August 7, 2016
*/

-- 1  Create a new database called BuildingEnergy

CREATE DATABASE IF NOT EXISTS building_energy;

-- 2. Create and populate two tables: EnergyCategories and EnergyTypes

-- Create Energy Category Table
DROP TABLE IF EXISTS energy_category;
CREATE TABLE energy_category
(
	energy_cat_id	int PRIMARY KEY,
	energy_category	varchar(20) NOT NULL
);

-- Populate Energy Category table
INSERT INTO energy_category (energy_cat_id, energy_category) VALUES ( 1, 'Fossil');
INSERT INTO energy_category (energy_cat_id, energy_category) VALUES ( 2, 'Renewable');

SELECT * FROM energy_category;

-- Create Energy Type Table
DROP TABLE IF EXISTS energy_type;
CREATE TABLE energy_type
(
	energy_type_id	int PRIMARY KEY,
    energy_type		varchar(20) NOT NULL,
    energy_cat_id	int NOT NULL REFERENCES energy_category
);

-- Populate Energy Type Table
INSERT INTO energy_type (energy_type_id, energy_type, energy_cat_id) VALUES ( 1, 'Electricity', 1);
INSERT INTO energy_type (energy_type_id, energy_type, energy_cat_id) VALUES ( 2, 'Gas', 1);
INSERT INTO energy_type (energy_type_id, energy_type, energy_cat_id) VALUES ( 3, 'Steam', 1);
INSERT INTO energy_type (energy_type_id, energy_type, energy_cat_id) VALUES ( 4, 'Fuel Oil', 1);
INSERT INTO energy_type (energy_type_id, energy_type, energy_cat_id) VALUES ( 5, 'Solar', 2);
INSERT INTO energy_type (energy_type_id, energy_type, energy_cat_id) VALUES ( 6, 'Wind', 2);

SELECT * FROM energy_type;

-- 3. Write a JOIN statement that shows the energy categories and associated energy types that you entered. 

SELECT c.energy_category, t.energy_type FROM energy_category c
LEFT JOIN energy_type t
on c.energy_cat_id = t.energy_cat_id
ORDER BY c.energy_category, t.energy_type;

-- 4. Add and populate a table called Buildings.  
--    There should be a many-to-many relationship between Buildings and EnergyTypes. 

-- Create Buildings Table
DROP TABLE IF EXISTS buildings;
CREATE TABLE buildings
(
	building_id		int PRIMARY KEY,
	building		varchar(40) NOT NULL
);

-- Populate Buildings table
INSERT INTO buildings (building_id, building) VALUES ( 1, 'Empire State Building');
INSERT INTO buildings (building_id, building) VALUES ( 2, 'Chrysler Building');
INSERT INTO buildings (building_id, building) VALUES ( 3, 'Borough of Manhattan Community College');

-- Create bridge table to enable many-to-many relationship between buildings table and energy_type table

DROP TABLE IF EXISTS building_energy;
CREATE TABLE building_energy
(
	building_id			int NOT NULL REFERENCES buildings(building_id),
    energy_type_id		int NOT NULL REFERENCES energy_type(energy_type_id),
    CONSTRAINT building_energy_id	PRIMARY KEY (building_id, energy_type_id)
);

-- Populate bridge table

INSERT INTO building_energy (building_id, energy_type_id) VALUES(1, 1);
INSERT INTO building_energy (building_id, energy_type_id) VALUES(1, 2);
INSERT INTO building_energy (building_id, energy_type_id) VALUES(1, 3);
INSERT INTO building_energy (building_id, energy_type_id) VALUES(2, 1);
INSERT INTO building_energy (building_id, energy_type_id) VALUES(2, 3);
INSERT INTO building_energy (building_id, energy_type_id) VALUES(3, 1);
INSERT INTO building_energy (building_id, energy_type_id) VALUES(3, 3);
INSERT INTO building_energy (building_id, energy_type_id) VALUES(3, 5);

-- 5. Write a JOIN statement that shows the buildings and associated energy types for each building.

SELECT b.building, t.energy_type
	FROM buildings b
		LEFT JOIN building_energy be ON b.building_id = be.building_id
		LEFT JOIN energy_type t ON be.energy_type_id = t.energy_type_id
ORDER BY b.building, t.energy_type;

-- 6. Add two more buildings to database

-- Add two new buildings to buildings table
INSERT INTO buildings (building_id, building) VALUES ( 4, 'Bronx Lion House');
INSERT INTO buildings (building_id, building) VALUES ( 5, 'Brooklyn Childrens Museum');

-- Add geothermal to energy_type table
INSERT INTO energy_type (energy_type_id, energy_type, energy_cat_id) VALUES ( 7, 'Geothermal', 2);

-- Add new combos to building_energy table
INSERT INTO building_energy (building_id, energy_type_id) VALUES(4, 7);
INSERT INTO building_energy (building_id, energy_type_id) VALUES(5, 1);
INSERT INTO building_energy (building_id, energy_type_id) VALUES(5, 7);

-- 7. Write a SQL query that displays all of the buildings that use Renewable Energies.

SELECT b.building, t.energy_type, c.energy_category
	FROM buildings b
		LEFT JOIN building_energy be ON b.building_id = be.building_id
		LEFT JOIN energy_type t ON be.energy_type_id = t.energy_type_id
        LEFT JOIN energy_category c ON c.energy_cat_id = t.energy_cat_id
WHERE c.energy_category = 'Renewable';

-- 8. Write a SQL query that shows the frequency with which energy types are used in various buildings

SELECT t.energy_type, Count(*) 
	FROM energy_type t
		JOIN building_energy be ON t.energy_type_id = be.energy_type_id
		JOIN buildings b ON be.building_id = b.building_id
GROUP BY t.energy_type
ORDER BY t.energy_type;
