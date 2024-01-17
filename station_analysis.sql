SELECT
  end_station_name,
  members,
  casuals
  FROM (
SELECT
  end_station_name,
  COUNT(end_station_name) as members
FROM `deanscapstone.cyclistic.full_year_f` 
WHERE member_casual = 'member'
GROUP BY end_station_name, member_casual
ORDER BY members DESC
LIMIT 100
  )
JOIN
(
SELECT
  end_station_name,
  COUNT(end_station_name) as casuals
FROM `deanscapstone.cyclistic.full_year_f` 
WHERE member_casual = 'casual'
GROUP BY end_station_name, member_casual
ORDER BY casuals DESC
LIMIT 100
  )  
USING(end_station_name)
