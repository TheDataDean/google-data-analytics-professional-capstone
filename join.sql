--Join all 12 months into a table with results to be saved as table 'full_year'
--Create new column for month of year

WITH j AS (
SELECT
  ride_id,
  rideable_type,
  started_at,
  EXTRACT(month FROM started_at) AS month,
  ended_at,
  ride_length,
  day_of_week,
  member_casual,
  start_station_name,
  end_station_name,
  start_lat,
  start_lng,
  end_lat,
  end_lng
FROM `deanscapstone.cyclistic.jan`
UNION DISTINCT
SELECT
  ride_id,
  rideable_type,
  started_at,
  EXTRACT(month FROM started_at) AS month,
  ended_at,
  ride_length,
  day_of_week,
  member_casual,
  start_station_name,
  end_station_name,
  start_lat,
  start_lng,
  end_lat,
  end_lng
FROM `deanscapstone.cyclistic.feb`
UNION DISTINCT
SELECT
  ride_id,
  rideable_type,
  started_at,
  EXTRACT(month FROM started_at) AS month,
  ended_at,
  ride_length,
  day_of_week,
  member_casual,
  start_station_name,
  end_station_name,
  start_lat,
  start_lng,
  end_lat,
  end_lng
FROM `deanscapstone.cyclistic.mar`
UNION DISTINCT
SELECT
  ride_id,
  rideable_type,
  started_at,
  EXTRACT(month FROM started_at) AS month,
  ended_at,
  ride_length,
  day_of_week,
  member_casual,
  start_station_name,
  end_station_name,
  start_lat,
  start_lng,
  end_lat,
  end_lng
FROM `deanscapstone.cyclistic.apr`
UNION DISTINCT
SELECT
  ride_id,
  rideable_type,
  started_at,
  EXTRACT(month FROM started_at) AS month,
  ended_at,
  ride_length,
  day_of_week,
  member_casual,
  start_station_name,
  end_station_name,
  start_lat,
  start_lng,
  end_lat,
  end_lng
FROM `deanscapstone.cyclistic.may`
UNION DISTINCT
SELECT
  ride_id,
  rideable_type,
  started_at,
  EXTRACT(month FROM started_at) AS month,
  ended_at,
  ride_length,
  day_of_week,
  member_casual,
  start_station_name,
  end_station_name,
  start_lat,
  start_lng,
  end_lat,
  end_lng
FROM `deanscapstone.cyclistic.jun`
UNION DISTINCT
SELECT
  ride_id,
  rideable_type,
  started_at,
  EXTRACT(month FROM started_at) AS month,
  ended_at,
  ride_length,
  day_of_week,
  member_casual,
  start_station_name,
  end_station_name,
  start_lat,
  start_lng,
  end_lat,
  end_lng
FROM `deanscapstone.cyclistic.jul`
UNION DISTINCT
SELECT
  ride_id,
  rideable_type,
  started_at,
  EXTRACT(month FROM started_at) AS month,
  ended_at,
  ride_length,
  day_of_week,
  member_casual,
  start_station_name,
  end_station_name,
  start_lat,
  start_lng,
  end_lat,
  end_lng
FROM `deanscapstone.cyclistic.aug`
UNION DISTINCT
SELECT
  ride_id,
  rideable_type,
  started_at,
  EXTRACT(month FROM started_at) AS month,
  ended_at,
  ride_length,
  day_of_week,
  member_casual,
  start_station_name,
  end_station_name,
  start_lat,
  start_lng,
  end_lat,
  end_lng
FROM `deanscapstone.cyclistic.sep`
UNION DISTINCT
SELECT
  ride_id,
  rideable_type,
  started_at,
  EXTRACT(month FROM started_at) AS month,
  ended_at,
  ride_length,
  day_of_week,
  member_casual,
  start_station_name,
  end_station_name,
  start_lat,
  start_lng,
  end_lat,
  end_lng
FROM `deanscapstone.cyclistic.oct`
UNION DISTINCT
SELECT
  ride_id,
  rideable_type,
  started_at,
  EXTRACT(month FROM started_at) AS month,
  ended_at,
  ride_length,
  day_of_week,
  member_casual,
  start_station_name,
  end_station_name,
  start_lat,
  start_lng,
  end_lat,
  end_lng
FROM `deanscapstone.cyclistic.nov`
UNION DISTINCT
SELECT
  ride_id,
  rideable_type,
  started_at,
  EXTRACT(month FROM started_at) AS month,
  ended_at,
  ride_length,
  day_of_week,
  member_casual,
  start_station_name,
  end_station_name,
  start_lat,
  start_lng,
  end_lat,
  end_lng
FROM `deanscapstone.cyclistic.dec`
)

-- Improve display of day_of_week column to make it easier to read

SELECT
  ride_id,
  rideable_type,
  month,
  started_at,
  ended_at,
  ride_length,
  CASE
    WHEN day_of_week = 1 THEN 'SUN'
    WHEN day_of_week = 2 THEN 'MON'
    WHEN day_of_week = 3 THEN 'TUE'
    WHEN day_of_week = 4 THEN 'WED'
    WHEN day_of_week = 5 THEN 'THU'
    WHEN day_of_week = 6 THEN 'FRI'
    WHEN day_of_week = 7 THEN 'SAT'
    ELSE ''
    END AS day_of_week,
  member_casual,
  start_station_name,
  end_station_name,
  start_lat,
  start_lng,
  end_lat,
  end_lng
FROM J;
