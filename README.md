# **New York Hospital Charges Prediction**

## Overview  
This project predicts **total hospital charges** for inpatient discharges in New York using the **SPARCS (Statewide Planning and Research Cooperative System)** dataset.  
The workflow includes **SQL-based data preparation**, **exploratory data analysis**, **feature engineering**, and **LightGBM modeling** — with segmentation, quantile regression, and hybrid blending to minimize prediction error.  

## Motivation

Predicting hospital charges accurately is crucial for healthcare cost management and resource allocation. It enables hospitals and policymakers to anticipate expenses, improve budgeting, and identify cost drivers. This can lead to more efficient healthcare delivery, better patient outcomes, and reduced financial burden on both providers and patients.

---

## Project Structure

```text
ny-hospital-charges-analysis/
│
├── data/
│   ├── raw/           # Original datasets (ignored in Git)
│   ├── processed/     # Cleaned and feature-engineered datasets
│   ├── predictions/   # Model outputs
│   ├── residuals/     # Residual and error analysis files
│   └── mappings/      # Encoding lookup tables (kept in Git)
│
├── models/
│   ├── baseline/      # Untuned reference models
│   ├── tuned/         # Tuned LOS group models
│   ├── experiments/   # Experimental runs
│   └── final/         # Best-performing models (kept in Git)
│
├── notebooks/         # Jupyter notebooks for EDA, modeling, explainability
├── sql/               # SQL scripts for data preparation and feature engineering
├── images/            # Plots and visual assets
└── README.md
```

---

## Workflow  

### **Data Preparation (SQL)**  
- **01_create_sparcs_discharges.sql** → Creates raw table from SPARCS CSV.  
- **02_create_modeling_table.sql** → Selects relevant columns for modeling.  
- **03_exploration.sql** → SQL-based exploratory data analysis.  
- **04_feature_selection.sql** → Filters & cleans modeling-ready dataset.  
- **05_encode_features.sql** → Encodes categorical variables & exports mapping tables.  

### **Exploratory Data Analysis (Key Findings)**  
- **Average total charges**: ~$46,000.  
- Charges increase with **length of stay** and **severity**.  
- Highest-cost procedures: organ transplants, tracheostomies, bone marrow transplants.  
- Counties with highest charges: Manhattan, Nassau, Westchester.  

### **Modeling (Python + LightGBM)**  
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

### Results Interpretation

The achieved MAE values indicate that on average, the model's predictions deviate from the actual hospital charges by approximately $10,486. This level of accuracy is significant given the complexity and variability of inpatient costs, and it demonstrates the model's practical utility for forecasting and budgeting purposes.

The **Quantile Long + Extended LOS Hybrid** model is the **final deliverable**.

---

## Key Findings

1. Certain patient categories are much harder to predict — Extended LOS + Minor severity cases had unusually high residuals, suggesting unusual or rare cost drivers. Severe/extreme long-stay cases also showed high errors, likely due to complications or multiple procedures.

2. Diagnosis groups drive large differences in accuracy — Oncology had the highest MAE (~$19.5K), followed by Orthopedic and Cardio-Metabolic cases. OB/GYN and Neonatal cases were among the most predictable, likely due to standardized care pathways.

3. Hybrid segmentation improves accuracy, but there’s still room for improvement — The Quantile Long + Extended LOS Hybrid reduced MAE by ~6% over the baseline. Further gains may require richer features (e.g., insurance details, hospital policies) and advanced ensembling.

---

##  Explainability (SHAP Insights)  
- **Length of stay** and **severity of illness** are the dominant drivers of cost.  
- Certain **diagnosis–procedure combinations** produce large cost spikes (especially for outliers).  
- Segmentation improves prediction accuracy for long and extended LOS cases.  

## Future Improvements

- Explore advanced ensembling techniques to further reduce prediction error.  
- Implement more granular segmentation strategies beyond LOS groups.  
- Incorporate additional features such as insurance type, hospital specialization, and patient comorbidities.  
- Experiment with other model architectures like neural networks or gradient boosting variants.

## Dataset  

The dataset is provided by the **New York State Department of Health** via the [SPARCS](https://www.health.ny.gov/statistics/sparcs/) program.

- **Rows:** ~2 million inpatient discharge records  
- **Columns:** Patient demographics, diagnoses, procedures, length of stay, severity, hospital info, total charges  
- Due to size, the raw CSV is not stored in GitHub. Download it from the official site and place it in:  



---

## Notebooks

- `notebooks/04_los_segmented_modeling.ipynb` — LOS-based segmented modeling  
- `notebooks/05_los_ensemble_prediction.ipynb` — Ensemble prediction for LOS groups  
- `notebooks/06_feature_engineering.ipynb` — Feature engineering  
- `notebooks/07_final_model_lightgbm.ipynb` — Final tuned LightGBM model  

---

## How to Reproduce

> **Note:** Skip custom PostgreSQL steps if using default port (5432) and matching OS/DB user.

### PostgreSQL Setup (Custom)

If you use a non-default PostgreSQL setup (e.g., port 5433, custom user):

1. Initialize a new data directory with a password prompt:

```bash
mkdir -p ~/pg/nyhc14
/opt/homebrew/opt/postgresql@14/bin/initdb -D ~/pg/nyhc14 -U postgres -A scram-sha-256 -W
```

2. Start PostgreSQL on port 5433:

```bash
/opt/homebrew/opt/postgresql@14/bin/pg_ctl -D ~/pg/nyhc14 -o "-p 5433" -l ~/pg/nyhc14/logfile start
```

3. Create a role and database (connect as postgres superuser):

```sql
CREATE ROLE nyhc_user WITH LOGIN PASSWORD 'your_password';
CREATE DATABASE nyhc OWNER nyhc_user;
```

4. Export environment variables before running the project:

```bash
export PGHOST=127.0.0.1
export PGPORT=5433
export PGUSER=nyhc_user
export PGPASSWORD='your_password'
export PGDATABASE=nyhc
```

5. Verify connection:

```bash
psql -h 127.0.0.1 -p 5433 -U nyhc_user -d nyhc
```

If your PostgreSQL runs on default port 5432 and your OS user matches the DB user, you can skip this.

### 0. Install Dependencies
Make sure you have Python 3.12 (or compatible) installed.

Create and activate a virtual environment:
```bash
python -m venv .venv
source .venv/bin/activate
```

Install the required packages:
```bash
pip install -r requirements.txt
```

### 1. Create Database & Load Data
Run the table creation script:
```bash
psql -U postgres -f sql/01_create_sparcs_discharges.sql
```

Step 2: Load the raw SPARCS CSV into PostgreSQL
Run this inside the psql shell (adjust the path to match your file location):
```sql
\COPY sparcs_discharges FROM 'data/raw/sparcs_inpatient.csv' CSV HEADER
```

---

2. Prepare Modeling Dataset

Run the SQL scripts in order:
```bash
psql -U postgres -f sql/02_modeling_table.sql
psql -U postgres -f sql/04_feature_selection_and_cleaning.sql
psql -U postgres -f sql/05_modeling_prep.sql
```

---

3. Train or Load Models

```python
import joblib

# Example: Load tuned long LOS quantile model
long_quantile = joblib.load("models/final/model_los_long_quantile.pkl")

# Example: Load tuned extended LOS quantile model
extended_quantile = joblib.load("models/final/model_los_extended_quantile.pkl")

# Example: Load global tuned model
global_model = joblib.load("models/final/final_tuned_lgbm.joblib")
```

---

4. Generate Predictions
```python
# Predict using the hybrid approach
# (use quantile models for Long/Extended LOS, global for others)
preds = hybrid_predict(global_model, long_quantile, extended_quantile, X_test)
```

---

5. Evaluate Performance

| Model Variant                          | MAE ($)    |
|----------------------------------------|------------|
| Baseline Global LightGBM               | ~11,137.83 |
| Quantile Long + Extended LOS Hybrid    | **~10,486.20** |

