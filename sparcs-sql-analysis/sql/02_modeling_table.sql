-- Create a table for modeling total charges 

DROP TABLE IF EXISTS modeling_table;

CREATE TABLE modeling_table AS 
SELECT 
    -- Target Variable 
    total_charges,

    -- Patient Demographics
    gender,
    race,
    ethnicity,
    age_group,
    zip_code_3_digits,

    -- Hospital information
    health_service_area,
    hospital_county,
    facility_id,
    facility_name,

    -- Admission info 
    type_of_admission,
    length_of_stay,
    patient_disposition,

    -- Diagnosis and procedure information
    ccs_diagnosis_description,
    ccs_procedure_description,

    -- Severity and risk indicators 
    apr_drg_description,
    apr_severity_of_illness_description,
    apr_medical_surgical_description,

    -- Payment information
    payment_typology_1

FROM sparcs_discharges
WHERE total_charges IS NOT NULL;