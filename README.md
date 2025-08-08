# **New York Hospital Charges Prediction**

## Overview  
This project predicts **total hospital charges** for inpatient discharges in New York using the **SPARCS (Statewide Planning and Research Cooperative System)** dataset.  
The workflow includes **SQL-based data preparation**, **exploratory data analysis**, **feature engineering**, and **LightGBM modeling** — with segmentation, quantile regression, and hybrid blending to minimize prediction error.  

---

## Project Structure  

```text
ny-hospital-charges-analysis/
│
├── data/
│   ├── raw/           # Original datasets (ignored in Git)
│   ├── processed/     # Cleaned & feature-engineered datasets
│   ├── predictions/   # Model outputs
│   ├── residuals/     # Residual/error analysis files
│   └── mappings/      # Encoding lookup tables (kept in Git)
│
├── models/
│   ├── baseline/      # Untuned reference models
│   ├── tuned/         # Tuned LOS group models
│   ├── experiments/   # Experimental runs
│   └── final/         # Best-performing models kept in Git
│
├── notebooks/         # Jupyter notebooks for EDA, modeling, explainability
├── sql/               # SQL scripts for data prep & feature engineering
└── README.md


---

## Workflow  

### **1️⃣ Data Preparation (SQL)**  
- **01_create_sparcs_discharges.sql** → Creates raw table from SPARCS CSV.  
- **02_create_modeling_table.sql** → Selects relevant columns for modeling.  
- **03_exploration.sql** → SQL-based exploratory data analysis.  
- **04_feature_selection.sql** → Filters & cleans modeling-ready dataset.  
- **05_encode_features.sql** → Encodes categorical variables & exports mapping tables.  

### **2️⃣ Exploratory Data Analysis (Key Findings)**  
- **Average total charges**: ~$46,000.  
- Charges increase with **length of stay** and **severity**.  
- Highest-cost procedures: organ transplants, tracheostomies, bone marrow transplants.  
- Counties with highest charges: Manhattan, Nassau, Westchester.  

### **3️⃣ Modeling (Python + LightGBM)**  
- **Base Model**: Global LightGBM on encoded features.  
- **Segmentation**:  
  - By **Length of Stay (LOS)** → short, moderate, long, extended.  
  - Quantile regression for long & extended LOS groups.  
- **Hybrid Model**: Blends LOS-specific predictions with global predictions for best MAE.  

---

## Final Results  

| Model Variant            | MAE ($)    |
|--------------------------|------------|
| Baseline Global LightGBM | ~11,137.83 |
| LOS Hybrid Quantile      | **~10,486.20** |

The **Quantile Long + Extended LOS Hybrid** model is the **final deliverable**.
---

##  Explainability (SHAP Insights)  
- **Length of stay** and **severity of illness** are the dominant drivers of cost.  
- Certain **diagnosis–procedure combinations** produce large cost spikes (especially for outliers).  
- Segmentation improves prediction accuracy for long and extended LOS cases.  

## Dataset  

The dataset is provided by the **New York State Department of Health** via the [SPARCS](https://www.health.ny.gov/statistics/sparcs/) program.

- **Rows:** ~2 million inpatient discharge records  
- **Columns:** Patient demographics, diagnoses, procedures, length of stay, severity, hospital info, total charges  
- Due to size, the raw CSV is not stored in GitHub. Download it from the official site and place it in:  



---

## How to Reproduce

### 1️⃣ Create Database & Load Data
Run the table creation script:
```bash
psql -U postgres -f sql/01_create_sparcs_discharges.sql


Step 2: Load the raw SPARCS CSV into PostgreSQL
Run this inside the psql shell (adjust the path to match your file location): \COPY sparcs_discharges FROM 'data/raw/sparcs_inpatient.csv' CSV HEADER

2️⃣ Prepare Modeling Dataset

Run the SQL scripts in order:

psql -U postgres -f sql/02_modeling_table.sql
psql -U postgres -f sql/04_feature_selection_and_cleaning.sql
psql -U postgres -f sql/05_modeling_prep.sql

3️⃣ Train or Load Models

import joblib

# Example: Load tuned long LOS quantile model
long_quantile = joblib.load("models/final/model_los_long_quantile.pkl")

# Example: Load tuned extended LOS quantile model
extended_quantile = joblib.load("models/final/model_los_extended_quantile.pkl")

# Example: Load global tuned model
global_model = joblib.load("models/final/final_tuned_lgbm.joblib")

4️⃣ Generate Predictions
# Predict using the hybrid approach
# (use quantile models for Long/Extended LOS, global for others)
preds = hybrid_predict(global_model, long_quantile, extended_quantile, X_test)

5️⃣ Evaluate Performance

| Model Variant                          | MAE ($)    |
|----------------------------------------|------------|
| Baseline Global LightGBM               | ~11,137.83 |
| Quantile Long + Extended LOS Hybrid    | **~10,486.20** |

