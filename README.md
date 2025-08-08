## Final Results  

| Model Variant            | MAE ($)    |
|--------------------------|------------|
| Baseline Global LightGBM | ~11,137.83 |
| LOS Hybrid Quantile      | **~10,486.20** |

![MAE by Diagnosis Group](images/mae_by_diagnosis_group.png "Mean Absolute Error by Diagnosis Group")

![Average Residual by LOS × Severity Group](images/avg_residual_by_los_x_severity.png "Residuals by Length of Stay and Severity Group")

### Results Interpretation

The achieved MAE values indicate that on average, the model's predictions deviate from the actual hospital charges by approximately $10,486. This level of accuracy is significant given the complexity and variability of inpatient costs, and it demonstrates the model's practical utility for forecasting and budgeting purposes.

The **Quantile Long + Extended LOS Hybrid** model is the **final deliverable**.
---
