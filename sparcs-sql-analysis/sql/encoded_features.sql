-- Create a new table for modeling input with encoded categorical features
CREATE TABLE model_input AS
SELECT
 -- Encode gender: F → 0, M → 1
  CASE WHEN gender = 'F' THEN 0 ELSE 1 END AS gender_encoded,

   -- Encode age_group into ordinal numeric values
  CASE 
    WHEN age_group = '0 to 17' THEN 0
    WHEN age_group = '18 to 29' THEN 1
    WHEN age_group = '30 to 49' THEN 2
    WHEN age_group = '50 to 69' THEN 3
    WHEN age_group = '70 or Older' THEN 4
    ELSE NULL  -- Handle unexpected values
  END AS age_group_encoded,

  -- Encode severity level into ordinal scale
  CASE 
    WHEN severity = 'Minor' THEN 1
    WHEN severity = 'Moderate' THEN 2
    WHEN severity = 'Major' THEN 3
    WHEN severity = 'Extreme' THEN 4
    ELSE NULL  -- Handle unknown severity
  END AS severity_encoded,

  -- Target variable for modeling
  total_charges
FROM feature_dataset

-- Keep only rows where age_group and severity are defined
WHERE age_group IS NOT NULL AND severity IS NOT NULL;


-- Verify table was created properly 
SELECT * FROM model_input LIMIT 100;

