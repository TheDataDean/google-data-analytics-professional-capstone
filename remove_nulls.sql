--remove rows where both name and coordinates are missing

SELECT
  *
FROM `deanscapstone.cyclistic.full_year2`
WHERE ride_id NOT IN (
SELECT
  ride_id
 FROM `deanscapstone.cyclistic.full_year2`
WHERE (end_station_name IS NULL AND end_lat IS NULL) OR (start_station_name IS NULL AND start_lat IS NULL)
);
