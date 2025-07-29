SELECT * 
FROM feature_dataset
LIMIT 100;


SELECT 
  -- Encode gender: 0 for Female, 1 for Male
  CASE WHEN gender = 'F' THEN 0 ELSE 1 END AS gender_encoded,

  -- Encode age groups into ordinal values (younger to older)
  CASE 
    WHEN age_group = '0 to 17' THEN 0
    WHEN age_group = '18 to 29' THEN 1
    WHEN age_group = '30 to 49' THEN 2
    WHEN age_group = '50 to 69' THEN 3
    WHEN age_group = '70 or Older' THEN 4
    ELSE NULL  -- Catch any unexpected age values
  END AS age_group_encoded,

  -- Encode severity of illness: higher number = more severe
  CASE 
    WHEN severity = 'Minor' THEN 1
    WHEN severity = 'Moderate' THEN 2
    WHEN severity = 'Major' THEN 3
    WHEN severity = 'Extreme' THEN 4
    ELSE NULL  -- Catch any unknown severity labels
  END AS severity_encoded,

  -- Target variable for modeling
  total_charges
FROM feature_dataset
LIMIT 100;

