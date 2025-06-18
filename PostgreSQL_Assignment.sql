-- Active: 1747579130667@@localhost@5432@conservation_db@public

-- -- Create the rangers table

CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL
);

-- Create the species table
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) CHECK (
        conservation_status = 'Endangered'
        OR conservation_status = 'Vulnerable'
    )
);

-- Create the sightings table
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT REFERENCES species (species_id),
    ranger_id INT REFERENCES rangers (ranger_id),
    location VARCHAR(100) NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    notes TEXT
);

-- Insert data into rangers
INSERT INTO
    rangers (name, region)
VALUES (
        'Alice Green',
        'Northern Hills'
    ),
    ('Bob White', 'River Delta'),
    (
        'Carol King',
        'Mountain Range'
    );

-- Insert data into species
INSERT INTO
    species (
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        'Snow Leopard',
        'Panthera uncia',
        '1775-01-01',
        'Endangered'
    ),
    (
        'Bengal Tiger',
        'Panthera tigris tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        'Red Panda',
        'Ailurus fulgens',
        '1825-01-01',
        'Vulnerable'
    ),
    (
        'Asiatic Elephant',
        'Elephas maximus indicus',
        '1758-01-01',
        'Endangered'
    );

-- Insert data into sightings
INSERT INTO
    sightings (
        species_id,
        ranger_id,
        location,
        sighting_time,
        notes
    )
VALUES (
        1,
        1,
        'Peak Ridge',
        '2024-05-10 07:45:00',
        'Camera trap image captured'
    ),
    (
        2,
        2,
        'Bankwood Area',
        '2024-05-12 16:20:00',
        'Juvenile seen'
    ),
    (
        3,
        3,
        'Bamboo Grove East',
        '2024-05-15 09:10:00',
        'Feeding observed'
    ),
    (
        1,
        2,
        'Snowfall Pass',
        '2024-05-18 18:30:00',
        NULL
    );

-- View all data in output
SELECT * FROM rangers

SELECT * FROM species

SELECT * FROM sightings

-- Problem 1
-- Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'

INSERT INTO
    rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains')

-- Problem 2
-- Count unique species ever sighted.

SELECT count(DISTINCT species_id) AS unique_species_count
FROM sightings

-- Problem 3
-- Find all sightings where the location includes "Pass".

SELECT * FROM sightings WHERE location LIKE '%Pass%'

-- Problem 4
-- List each ranger's name and their total number of sightings.

SELECT name, count(species_id)
FROM rangers
    JOIN sightings ON rangers.ranger_id = sightings.ranger_id
GROUP BY
    name

-- Problem 5
-- List species that have never been sighted.

SELECT common_name
FROM species
    LEFT JOIN sightings ON species.species_id = sightings.species_id
WHERE
    sighting_id IS NULL

-- Problem 6
-- Show the most recent 2 sightings.

SELECT common_name, sighting_time, name
FROM
    rangers
    JOIN sightings ON rangers.ranger_id = sightings.ranger_id
    JOIN species ON sightings.species_id = species.species_id
ORDER BY sighting_time DESC
LIMIT 2

-- *** Step Notes
-- I have to update the conservation_status's check constraint by adding 'Historic' because i've set only 'Endangered' and 'Vulnerable' in check constraint. I could do drop the whole table and re-create by adding 'Historic' but i think it would be bad practice. so I decide to update the constraint.

-- for knowing the name of the constraint.
SELECT conname
FROM pg_constraint
WHERE
    conrelid = 'species'::regclass
    AND contype = 'c';
-- Its returned me "species_conservation_status_check"

-- Droping the previous constraint.
ALTER TABLE species
DROP CONSTRAINT species_conservation_status_check;

-- Adding the constraint with "Historic"
ALTER TABLE species
ADD CONSTRAINT species_conservation_status_check CHECK (
    conservation_status = 'Endangered'
    OR conservation_status = 'Vulnerable'
    OR conservation_status = 'Historic'
)

-- Problem 7
-- Update all species discovered before year 1800 to have status 'Historic'.

UPDATE species
SET
    conservation_status = 'Historic'
WHERE
    extract(
        YEAR
        FROM discovery_date
    ) < 1800

-- problem 8
-- Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.

SELECT
    sighting_id,
    CASE
        WHEN sighting_time::time < TIME '12:00:00' THEN 'Morning'
        WHEN sighting_time::time >= TIME '12:00:00'
        AND sighting_time::time <= TIME '17:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS day_of_time
FROM sightings

-- Problem 9
-- DELETE rangers who have never sighted ANY species

DELETE FROM rangers
WHERE
    ranger_id IN (
        SELECT ranger_id
        FROM rangers
            LEFT JOIN sightings USING (ranger_id)
        WHERE
            species_id IS NULL
    )