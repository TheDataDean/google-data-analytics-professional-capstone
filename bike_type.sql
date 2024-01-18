With docked as (SELECT 
  member_casual,
  count(ride_id) as total_docked
  FROM
 (
  SELECT 
  member_casual,
  ride_id,
  rideable_type
  FROM `deanscapstone.cyclistic.full_year` 
  WHERE rideable_type = 'docked_bike'
)
GROUP BY member_casual
),

classic as (SELECT 
  member_casual,
  count(ride_id) as total_classic
  FROM
 (
  SELECT 
  member_casual,
  ride_id,
  rideable_type
  FROM `deanscapstone.cyclistic.full_year` 
  WHERE rideable_type = 'classic_bike'
)
GROUP BY member_casual
),

electric as (SELECT 
  member_casual,
  count(ride_id) as total_electric
  FROM
 (
  SELECT 
  member_casual,
  ride_id,
  rideable_type
  FROM `deanscapstone.cyclistic.full_year` 
  WHERE rideable_type = 'electric_bike'
)
GROUP BY member_casual
)

SELECT *
FROM
  docked
RIGHT JOIN
  classic
USING(member_casual)
JOIN
  electric
USING
  (member_casual)
