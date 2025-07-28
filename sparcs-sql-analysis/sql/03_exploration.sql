-- Inital EDA on modeling_table 


-- Preview table
SELECT * 
FROM modeling_table 
LIMIT 5;


-- Total row count 
SELECT COUNT(*) FROM modeling_table;



-- Make sure there isn't any missing data 
SELECT 
    COUNT(*) FILTER (WHERE total_charges IS NULL) AS null_charges,
    COUNT(*) FILTER (WHERE gender IS NULL) AS null_gender,
    COUNT(*) FILTER (WHERE age_group IS NULL) AS null_age,
    COUNT(*) FILTER (WHERE ccs_diagnosis_description IS NULL) AS null_dx
FROM 
    modeling_table;



-- Distribution of charges 
SELECT
    MIN(total_charges),
    MAX(total_charges),
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_charges) AS median,
    ROUND(AVG(total_charges)) AS avg
FROM
    modeling_table;



-- Charges by age group 
SELECT
    age_group,
    ROUND(AVG(total_charges)) AS avg_charge
FROM
    modeling_table
GROUP BY
    age_group
ORDER BY
    avg_charge;



-- Charges by gender 
SELECT 
    gender,
    ROUND(AVG(total_charges)) AS avg_charge,
    COUNT(*) AS patients
FROM
    modeling_table
GROUP BY 
    gender;



-- Top diagnoses by frequency 
SELECT
    ccs_diagnosis_description,
    COUNT(*) AS frequency 
FROM
    modeling_table
GROUP BY 
    ccs_diagnosis_description
ORDER BY
    frequency DESC
LIMIT 10;



-- Charges by diagnosis
SELECT
    ccs_diagnosis_description,
    ROUND(AVG(total_charges)) AS avg_charge,
    COUNT(*) AS frequency
FROM
    modeling_table
GROUP BY
    ccs_diagnosis_description
HAVING
    COUNT(*) > 1000
ORDER BY avg_charge DESC
LIMIT 20;



-- Charges by severity
SELECT
    apr_severity_of_illness_description,
    ROUND(AVG(total_charges)) AS avg_charge,
    COUNT(*) AS patients
FROM
    modeling_table
GROUP BY
    apr_severity_of_illness_description
ORDER BY
    avg_charge DESC;



-- Charges by procedure 
SELECT 
    ccs_procedure_description,
    ROUND(AVG(total_charges)) AS avg_charge,
    COUNT(*) AS procedures
FROM
    modeling_table
GROUP BY 
    ccs_procedure_description
HAVING
    COUNT(*) > 500
ORDER BY 
    avg_charge DESC
LIMIT 20;


-- Charges by admission type 
SELECT 
    type_of_admission,
    ROUND(AVG(total_charges)) AS avg_charge
FROM
    modeling_table
GROUP BY 
    type_of_admission
ORDER BY 
    avg_charge DESC;


-- Charges by country or region 
SELECT
    hospital_county,
    ROUND(AVG(total_charges)) AS avg_charge,
    COUNT(*) AS patients
FROM
    modeling_table
GROUP BY
    hospital_county
ORDER BY avg_charge DESC;


-- Charges by payment type
SELECT
    payment_typology_1,
    ROUND(AVG(total_charges)) AS avg_charge,
    COUNT(*) AS patients
FROM
    modeling_table
GROUP BY
    payment_typology_1
ORDER BY 
    avg_charge DESC;


-- Length of stay vs charges
SELECT
    CASE
        WHEN length_of_stay::int <= 1 THEN '0-1 days'
        WHEN length_of_stay::int <= 3 THEN '2–3 days'
        WHEN length_of_stay::int <= 7 THEN '4–7 days'
        ELSE '8+ days'
    END AS stay_range,
    ROUND(AVG(total_charges)) AS avg_charge,
    COUNT(*) AS patients
FROM 
    modeling_table
WHERE 
    length_of_stay ~ '^\d+$'   -- only keep numeric values
GROUP BY 
    stay_range
ORDER BY 
    avg_charge DESC;
