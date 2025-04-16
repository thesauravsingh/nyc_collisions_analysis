SELECT * FROM nyc_collisions LIMIT 10;

SELECT 
  borough, 
  COUNT(*) AS total_collisions
FROM nyc_collisions
WHERE borough IS NOT NULL
GROUP BY borough
ORDER BY total_collisions DESC;

SELECT 
  zip_code, 
  COUNT(*) AS total_collisions
FROM nyc_collisions
WHERE zip_code IS NOT NULL
GROUP BY zip_code
ORDER BY total_collisions DESC;

SELECT
  CASE 
    WHEN vehicle_type ILIKE '%sedan%' THEN 'sedan'
    WHEN vehicle_type ILIKE '%sport utility%' THEN 'suv'
    WHEN vehicle_type ILIKE '%station wagon%' THEN 'suv'
    WHEN vehicle_type ILIKE '%suv%' THEN 'suv'
    WHEN vehicle_type ILIKE '%taxi%' THEN 'taxi'
    WHEN vehicle_type ILIKE '%van%' THEN 'van'
    WHEN vehicle_type ILIKE '%bus%' THEN 'bus'
    WHEN vehicle_type ILIKE '%pickup%' OR vehicle_type ILIKE '%pick-up%' THEN 'pickup truck'
    WHEN vehicle_type ILIKE '%box truck%' THEN 'box truck'
    WHEN vehicle_type ILIKE '%truck%' THEN 'truck'
    WHEN vehicle_type ILIKE '%ambulance%' THEN 'ambulance'
    WHEN vehicle_type ILIKE '%bike%' OR vehicle_type ILIKE '%bicycle%' THEN 'bicycle'
    WHEN vehicle_type ILIKE '%motorcycle%' OR vehicle_type ILIKE '%motor bike%' THEN 'motorcycle'
    WHEN vehicle_type ILIKE '%fire%' THEN 'fire truck'
    WHEN vehicle_type ILIKE '%passenger%' THEN 'passenger vehicle'
    WHEN vehicle_type ILIKE '%unknown%' OR vehicle_type ILIKE 'unspecified' THEN 'unspecified'
    ELSE 'other'
  END AS cleaned_vehicle_type,
  COUNT(*) AS total_collisions
FROM (
  SELECT vehicle_type_code_1 AS vehicle_type FROM nyc_collisions
  UNION ALL
  SELECT vehicle_type_code_2 FROM nyc_collisions
  UNION ALL
  SELECT vehicle_type_code_3 FROM nyc_collisions
  UNION ALL
  SELECT vehicle_type_code_4 FROM nyc_collisions
  UNION ALL
  SELECT vehicle_type_code_5 FROM nyc_collisions
) AS all_vehicles
WHERE vehicle_type IS NOT NULL AND TRIM(vehicle_type) <> ''
GROUP BY cleaned_vehicle_type
ORDER BY total_collisions DESC;

SELECT 
  CONCAT_WS(' + ', vehicle_type_code_1, vehicle_type_code_2, vehicle_type_code_3, vehicle_type_code_4, vehicle_type_code_5) AS vehicle_combo,
  COUNT(*) AS total_collisions
FROM nyc_collisions
WHERE vehicle_type_code_1 IS NOT NULL AND vehicle_type_code_2 IS NOT NULL
GROUP BY vehicle_combo
ORDER BY total_collisions DESC
LIMIT 10;

SELECT cause, COUNT(*) AS total_collisions
FROM (
  SELECT contributing_factor_vehicle_1 AS cause FROM nyc_collisions
  UNION ALL
  SELECT contributing_factor_vehicle_2 FROM nyc_collisions
  UNION ALL
  SELECT contributing_factor_vehicle_3 FROM nyc_collisions
  UNION ALL
  SELECT contributing_factor_vehicle_4 FROM nyc_collisions
  UNION ALL
  SELECT contributing_factor_vehicle_5 FROM nyc_collisions
) AS all_factors
WHERE cause IS NOT NULL 
  AND TRIM(cause) <> '' 
  AND LOWER(cause) <> 'unspecified'
GROUP BY cause
ORDER BY total_collisions DESC
LIMIT 10;


SELECT 
  contributing_factor_vehicle_1 AS cause,
  SUM(number_of_persons_injured) AS total_injured,
  SUM(number_of_persons_killed) AS total_killed
FROM nyc_collisions
WHERE contributing_factor_vehicle_1 IS NOT NULL 
  AND TRIM(contributing_factor_vehicle_1) <> '' 
  AND LOWER(contributing_factor_vehicle_1) <> 'unspecified'
GROUP BY cause
ORDER BY total_injured DESC
LIMIT 10;

SELECT 
  borough,
  SUM(number_of_pedestrians_killed) AS pedestrians_killed,
  SUM(number_of_cyclist_killed) AS cyclists_killed,
  SUM(number_of_motorist_killed) AS motorists_killed
FROM nyc_collisions
WHERE borough IS NOT NULL
GROUP BY borough
ORDER BY pedestrians_killed DESC;

SELECT 'cyclist' AS victim_type, 'injured' AS outcome, SUM(number_of_cyclist_injured) AS total
FROM nyc_collisions
UNION ALL
SELECT 'cyclist', 'killed', SUM(number_of_cyclist_killed)
FROM nyc_collisions
UNION ALL
SELECT 'motorist', 'injured', SUM(number_of_motorist_injured)
FROM nyc_collisions
UNION ALL
SELECT 'motorist', 'killed', SUM(number_of_motorist_killed)
FROM nyc_collisions
UNION ALL
SELECT 'pedestrian', 'injured', SUM(number_of_pedestrians_injured)
FROM nyc_collisions
UNION ALL
SELECT 'pedestrian', 'killed', SUM(number_of_pedestrians_killed)
FROM nyc_collisions
ORDER BY victim_type, outcome;

SELECT 
  EXTRACT(YEAR FROM TO_DATE(crash_date, 'MM/DD/YYYY'))::int AS year,
  SUM(number_of_persons_injured + number_of_persons_killed) AS total_casualties
FROM nyc_collisions
WHERE crash_date IS NOT NULL
GROUP BY year
ORDER BY year;

SELECT 
  TO_CHAR(TO_DATE(crash_date, 'MM/DD/YYYY'), 'Day') AS day_of_week,
  COUNT(*) AS total_collisions
FROM nyc_collisions
WHERE crash_date IS NOT NULL
GROUP BY TO_CHAR(TO_DATE(crash_date, 'MM/DD/YYYY'), 'Day')
ORDER BY 
  CASE TRIM(TO_CHAR(TO_DATE(crash_date, 'MM/DD/YYYY'), 'Day'))
    WHEN 'Monday' THEN 1
    WHEN 'Tuesday' THEN 2
    WHEN 'Wednesday' THEN 3
    WHEN 'Thursday' THEN 4
    WHEN 'Friday' THEN 5
    WHEN 'Saturday' THEN 6
    WHEN 'Sunday' THEN 7
  END;

SELECT 
  EXTRACT(HOUR FROM TO_TIMESTAMP(crash_time, 'HH24:MI')) AS crash_hour,
  COUNT(*) AS total_collisions
FROM nyc_collisions
WHERE crash_time IS NOT NULL
GROUP BY crash_hour
ORDER BY crash_hour;

SELECT 
  EXTRACT(YEAR FROM TO_DATE(crash_date, 'MM/DD/YYYY'))::int AS year,
  COUNT(*) AS total_collisions
FROM nyc_collisions
WHERE crash_date IS NOT NULL
GROUP BY year
ORDER BY year;

SELECT 
  borough,
  SUM(number_of_pedestrians_injured + number_of_pedestrians_killed) AS pedestrian_casualties,
  SUM(number_of_cyclist_injured + number_of_cyclist_killed) AS cyclist_casualties,
  SUM(number_of_motorist_injured + number_of_motorist_killed) AS motorist_casualties
FROM nyc_collisions
WHERE borough IS NOT NULL
GROUP BY borough
ORDER BY borough;

SELECT 
  EXTRACT(YEAR FROM TO_DATE(crash_date, 'MM/DD/YYYY'))::int AS year,
  COUNT(*) AS total_collisions,
  SUM(number_of_persons_injured + number_of_persons_killed) AS total_casualties,
  ROUND(SUM(number_of_persons_injured + number_of_persons_killed)::decimal / COUNT(*) * 1000, 2) AS casualty_rate_per_1000
FROM nyc_collisions
WHERE crash_date IS NOT NULL
GROUP BY year
ORDER BY year;
