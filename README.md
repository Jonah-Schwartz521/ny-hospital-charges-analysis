## Exploratory Data Analysis (EDA)

I explored the `modeling_table` to understand what affects hospital charges in New York. Here’s what I found:

### Charges Overview
- **Average charge:** $46,000  
- **Median charge:** $25,000  
- **Max charge:** Over $10 million — likely extreme outliers

### Charges by Age Group
- **0–17:** ~$29,000  
- **18–29:** ~$29,800  
- **30–49:** ~$37,600  
- **50–69:** ~$56,400  
- **70+:** ~$56,600  

Charges steadily increase with age.

### Charges by Gender
- **Male:** ~$50,800  
- **Female:** ~$42,200  
- **Unknown:** ~$32,000 (very few patients)

Males had noticeably higher average charges.

### Most Common Diagnoses
Top 5 by frequency:
1. Liveborn
2. Septicemia (except in labor)
3. Osteoarthritis
4. Mood disorders
5. Alcohol-related disorders

### Most Expensive Diagnoses (with 1,000+ cases)
- **Leukemias:** ~$239,000  
- **Heart valve disorders:** ~$178,000  
- **Cancers and severe cardiovascular conditions** also had high average charges

### Most Expensive Procedures (with 500+ cases)
- **Organ Transplant:** ~$734,000  
- **Tracheostomy:** ~$485,000  
- **Bone Marrow Transplant:** ~$405,000  
- Other expensive surgeries: heart, nerve, or vascular procedures

### Length of Stay vs. Charges
- **0–1 days:** ~$19,000  
- **2–3 days:** ~$23,000  
- **4–7 days:** ~$43,700  
- **8+ days:** ~$121,000  

Longer stays significantly drive up costs.

### Charges by Admission Type
- **Trauma:** ~$76,300  
- **Elective:** ~$53,600  
- **Emergency:** ~$46,700  
- **Newborn:** ~$22,100 (lowest)

### Charges by County
- Highest: **Manhattan ($68K)**, **Nassau ($66K)**, **Westchester ($57K)**  
- Rural counties averaged as low as $10K–$20K

### Charges by Payment Type
- Highest averages:  
  - *Miscellaneous/Other:* ~$62,800  
  - *Medicare:* ~$56,500  
  - *Department of Corrections:* ~$48,400  
- Most common: *Medicare*, *Medicaid*, *Private Insurance*

---

## Model Files

Trained models (e.g., `.pkl` files) are saved in the `models/` folder.  
These files are excluded from Git tracking via `.gitignore`.

To reproduce or use the model:

```python
import joblib
model = joblib.load("models/my_model.pkl")