CREATE TABLE feature_dataset AS
WITH modeling_cte AS (
    SELECT
        gender,
        age_group,
        length_of_stay::int AS los,
        apr_severity_of_illness_description AS severity,
        ccs_diagnosis_description,
        ccs_procedure_description,
        hospital_county,
        payment_typology_1 AS payment_type,
        type_of_admission,
        total_charges 
    FROM
        modeling_table
    WHERE 
        total_charges IS NOT NULL
        AND length_of_stay ~ '^\d+$'
        AND gender IN ('M', 'F')
)
SELECT * FROM modeling_cte;


-- Verify table was created properly 
SELECT COUNT(*) FROM feature_dataset;

-- Preview table 
SELECT * FROM feature_dataset LIMIT 100;
