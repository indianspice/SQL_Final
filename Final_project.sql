-- Sharon Morris
-- SQL Final Project

-- 1) create a new database called BuildingEnergy. The SQL script should be self-contained, such that if it runs again it will re-create the database.

DROP SCHEMA IF EXISTS BuildingEnergy;
CREATE SCHEMA BuildingEnergy;
USE BuildingEnergy;

-- 2) You should first create two tables, EnergyCategories and EnergyTypes.
-- Populate the EnergyCategories table with rows for Fossil and Renewable.
-- Populate the EnergyTypes table with rows for Electricity, Gas, Steam, Fuel Oil, Solar, and Wind.
-- In the EnergyTypes table, you should indicate that Electricity, Gas, Steam, and Fuel Oil are Fossil 
-- energy sources, while Solar and Wind are renewable energy sources.
-- When inserting data into the tables, be sure to use an INSERT statement and not the table import wizard.

DROP TABLE IF EXISTS EnergyCategories;
CREATE TABLE EnergyCategories
(
  EnergyCat_id int PRIMARY KEY,
  EnergyCat VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS EnergyTypes;
CREATE TABLE EnergyTypes
(
  EnergyType_id int PRIMARY KEY,
  EnergyType VARCHAR(100) NOT NULL,
  EnergyCat_id int references EnergyCategories(EnerCat_id)
);

INSERT INTO EnergyCategories (EnergyCat_id, EnergyCat) VALUES (1, 'Fossil');
INSERT INTO EnergyCategories (EnergyCat_id, EnergyCat) VALUES (2, 'Renewable');
INSERT INTO EnergyTypes (EnergyType_id, EnergyType, EnergyCat_id) VALUES (1, 'Electricity', 1);
INSERT INTO EnergyTypes (EnergyType_id, EnergyType, EnergyCat_id) VALUES (2, 'Gas', 1);
INSERT INTO EnergyTypes (EnergyType_id, EnergyType, EnergyCat_id) VALUES (3, 'Steam', 1);
INSERT INTO EnergyTypes (EnergyType_id, EnergyType, EnergyCat_id) VALUES (4, 'Fuel Oil', 1);
INSERT INTO EnergyTypes (EnergyType_id, EnergyType, EnergyCat_id) VALUES (5, 'Solar', 2);
INSERT INTO EnergyTypes (EnergyType_id, EnergyType, EnergyCat_id) VALUES (6, 'Wind', 2);

SELECT *
FROM EnergyTypes;

-- 3) Write a JOIN statement that shows the energy categories and associated energy types that you entered. 

SELECT b.EnergyCat AS 'EnergyCategory', a.EnergyType as 'EnergyType' 
FROM EnergyTypes a 
Left join EnergyCategories b on a.EnergyCat_id = b.EnergyCat_id
order by b.EnergyCat;

-- 4) You should add a table called Buildings. There should be a many-to-many relationship between Buildings 
-- and EnergyTypes. Here is the information that should be included about buildings in the database:
-- Empire State Building; Energy Types: Electricity, Gas, Steam
-- Chrysler Building; Energy Types: Electricity, Steam
-- Borough of Manhattan Community College; Energy Types: Electricity, Steam, Solar

DROP TABLE IF EXISTS Buildings;
CREATE TABLE Buildings
(
  Building_id int PRIMARY KEY,
  Building_name VARCHAR(100) NOT NULL
);

INSERT INTO Buildings (Building_id, Building_name) VALUES (1, 'Empire State Building');
INSERT INTO Buildings (Building_id, Building_name) VALUES (2, 'Chrysler Building');
INSERT INTO Buildings (Building_id, Building_name) VALUES (3, 'Borough of Manhattan Community College');

SELECT *
FROM Buildings;

DROP TABLE IF EXISTS Buildings_EnergyTypes;
CREATE TABLE Buildings_EnergyTypes
(
  Building_id int references Buildings(Building_id),
  EnergyType_id int references EnergyTypes(EnergyType_id)
);

INSERT INTO Buildings_EnergyTypes (Building_id, EnergyType_id) VALUES (1, 1);
INSERT INTO Buildings_EnergyTypes (Building_id, EnergyType_id) VALUES (1, 2);
INSERT INTO Buildings_EnergyTypes (Building_id, EnergyType_id) VALUES (1, 3);

INSERT INTO Buildings_EnergyTypes (Building_id, EnergyType_id) VALUES (2, 1);
INSERT INTO Buildings_EnergyTypes (Building_id, EnergyType_id) VALUES (2, 3);

INSERT INTO Buildings_EnergyTypes (Building_id, EnergyType_id) VALUES (3, 1);
INSERT INTO Buildings_EnergyTypes (Building_id, EnergyType_id) VALUES (3, 3);
INSERT INTO Buildings_EnergyTypes (Building_id, EnergyType_id) VALUES (3, 5);

SELECT *
FROM Buildings_EnergyTypes;

-- 5) Write a JOIN statement that shows the buildings and associated energy types for each building.

Select a.Building_name as 'Building', c.EnergyType as 'EnergyType' 
from Buildings a 
Left join Buildings_EnergyTypes b on a.Building_id = b.Building_id
Left join EnergyTypes c on b.EnergyType_id = c.EnergyType_id;

-- 6) Please add this information to the BuildingEnergy database, inserting rows as needed in various tables.
-- Building: Bronx Lion House; Energy Types: Geothermal
-- Brooklyn Childrens Museum: Energy Types: Electricity, Geothermal

INSERT INTO Buildings (Building_id, Building_name) VALUES (4, 'Bronx Lion House');
INSERT INTO Buildings (Building_id, Building_name) VALUES (5, 'Brooklyn Childrens Museum');
INSERT INTO EnergyTypes (EnergyType_id, EnergyType, EnergyCat_id) VALUES (7, 'Geothermal', 2);
INSERT INTO Buildings_EnergyTypes (Building_id, EnergyType_id) VALUES (4, 7);
INSERT INTO Buildings_EnergyTypes (Building_id, EnergyType_id) VALUES (5, 1);
INSERT INTO Buildings_EnergyTypes (Building_id, EnergyType_id) VALUES (5, 7);

-- 7) Write a SQL query that displays all of the buildings that use Renewable Energies.

Select d.Building_name as 'Building', b.EnergyType as 'Energy Type', a.EnergyCat as 'Energy Category' from EnergyCategories as a 
Left join EnergyTypes as b on a.EnergyCat_id = b.EnergyCat_id
Right Join Buildings_EnergyTypes as c on b.EnergyType_id = c.EnergyType_id 
Left Join Buildings as d on c.Building_id = d.Building_id
where a.EnergyCat = 'Renewable';

-- 8) Write a SQL query that shows the frequency with which energy types are used in various buildings.

Select c.EnergyType as 'EnergyType', count(*) as 'Frequency' 
from Buildings a 
Left join Buildings_EnergyTypes b on a.Building_id = b.Building_id
Left join EnergyTypes c on b.EnergyType_id = c.EnergyType_id
Group By c.EnergyType
Order By count(*) Desc;

