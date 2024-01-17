--remove duplicates and round values for lng and lat
SELECT
  ride_id,
  rideable_type,
  month,
  started_at,
  ended_at,
  ride_length,
  day_of_week,
  member_casual,
  start_station_name,
  end_station_name,
  round(start_lat,2) as start_lat,
  round(start_lng,2) as start_lng,
  round(end_lat,2) as end_lat,
  round(end_lng,2) as end_lng
FROM (
SELECT *
FROM (
  SELECT
      *,
      ROW_NUMBER()
          OVER (PARTITION BY ride_id)
          row_number
  FROM `deanscapstone.cyclistic.full_year`
)
WHERE row_number = 1
)
