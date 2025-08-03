-- Drop existing table if it exists
DROP TABLE IF EXISTS model_input;

-- Create model_input table with encoded features + numeric los
CREATE TABLE model_input AS
SELECT
  -- Encode gender
  CASE WHEN gender = 'F' THEN 0 ELSE 1 END AS gender_encoded,

  -- Encode age group
  CASE 
    WHEN age_group = '0 to 17' THEN 0
    WHEN age_group = '18 to 29' THEN 1
    WHEN age_group = '30 to 49' THEN 2
    WHEN age_group = '50 to 69' THEN 3
    WHEN age_group = '70 or Older' THEN 4
    ELSE NULL
  END AS age_group_encoded,

  -- Encode severity
  CASE 
    WHEN severity = 'Minor' THEN 1
    WHEN severity = 'Moderate' THEN 2
    WHEN severity = 'Major' THEN 3
    WHEN severity = 'Extreme' THEN 4
    ELSE NULL
  END AS severity_encoded,

  -- Encode admission type
  CASE 
    WHEN type_of_admission = 'Emergency' THEN 3
    WHEN type_of_admission = 'Urgent' THEN 2
    WHEN type_of_admission = 'Elective' THEN 1
    ELSE 0
  END AS admission_encoded,

  -- Encode payment type
  CASE 
    WHEN payment_type = 'Private Health Insurance' THEN 3
    WHEN payment_type = 'Medicare' THEN 2
    WHEN payment_type = 'Medicaid' THEN 1
    ELSE 0
  END AS payment_type_encoded,

  -- Encode the diagnosis description
  DENSE_RANK() OVER (ORDER BY ccs_diagnosis_description) AS diagnosis_encoded,

  -- Encode the procedure description
  DENSE_RANK() OVER (ORDER BY ccs_procedure_description) AS procedure_encoded,

  -- Encode hospital county (label encoding)
  DENSE_RANK() OVER (ORDER BY hospital_county) AS county_encoded,
  
  -- Numeric feature
  los,

  -- Target
  total_charges

FROM feature_dataset
WHERE age_group IS NOT NULL AND severity IS NOT NULL;



SELECT DISTINCT 
  ccs_diagnosis_description,
  DENSE_RANK() OVER (ORDER BY ccs_diagnosis_description) AS diagnosis_encoded
FROM feature_dataset
ORDER BY diagnosis_encoded


SELECT DISTINCT 
  ccs_diagnosis_description,
  DENSE_RANK() OVER (ORDER BY ccs_diagnosis_description) AS diagnosis_encoded
FROM feature_dataset
WHERE ccs_diagnosis_description = 'Liveborn';