# Used Car Pricing Analytics: Linear Modeling & Multicollinearity Diagnostics

## 📌 Project Overview
This project develops an interpretable predictive pricing model for used vehicles (specifically Toyota Corolla sales records from a European dealership). By analyzing a dataset of physical characteristics, odometer readings, and mechanical configurations, the goal is to determine exactly which features statistically influence the final transaction price and quantify their impact.

In addition to building predictive models, this project focuses on **algorithmic verification**—manually calculating statistical thresholds ($t$-statistics, $p$-values, $R^2$, and Variance Inflation Factors) from fundamental formulas to validate R’s automated routines and diagnose potential multicollinearity.

---

## 📊 Dataset Profile
The analysis utilizes a dataset consisting of sales records with the following core features:
*   **Price (Target Variable):** Transaction price in Euros (€).
*   **Vehicle Metrics:** Age (months), Kilometers driven (KM), Weight (kg).
*   **Mechanical Specs:** Horsepower (HP), Cylinder volume (CC), Doors, Gears.
*   **Categorical Features:** Metallic Color (Binary), Automatic Transmission (Binary).

---

## 🧠 Modeling Approach & Engineering Decisions

### 1. Data Sanitization & Baseline Regression
Initial data cleaning removed the `Id` and `Model` text parameters to ensure a purely mathematical feature space. An Ordinary Least Squares (OLS) linear regression model was fitted using all available independent variables to establish an operational baseline.

### 2. Manual Statistical Verification (Algorithmic Proofs)
To demonstrate a deep structural understanding of regression mechanics rather than relying blindly on black-box software outputs, fundamental statistics were calculated manually from raw vector data:
*   **t-Statistics:** Computed via $t = \frac{\hat{\beta}_j}{se(\hat{\beta}_j)}$ and cross-referenced against the model matrix.
*   **p-Values:** Derived via the cumulative distribution function $p = 2 \cdot Pr(t < -|t_{stat}|)$ against a critical two-tailed $t$-distribution threshold at a 95% confidence interval ($\alpha = 0.05$).
*   **R-squared ($R^2$):** Calculated utilizing the ratio of Regression Sum of Squares (RSS) to Total Sum of Squares (TSS): $R^2 = \frac{RSS}{TSS}$.

### 3. Diagnosing Multicollinearity (VIF Proof)
High correlations between structural variables can destabilize parameter estimates. A full Variance Inflation Factor (VIF) audit was conducted using the `car` library. 

To prove the underlying mathematics, the VIF for the `Weight` variable (which exhibited the highest variance inflation) was manually reproduced by isolating it as a target vector against all remaining features, deriving its internal localized coefficient of determination ($R^2_{weight}$), and applying the variance multiplier formula:

$$\text{VIF}(\hat{\beta}_j) = \frac{1}{1 - R_j^2}$$

### 4. Model Optimization (Feature Reduction)
Statistically insignificant predictors (`Metallic`, `CC`, and `Doors`) were pruned ($p > 0.05$). A reduced, parsimonious model was trained exclusively on the statistically robust drivers of value: `Age`, `KM`, `HP`, `Automatic`, `Gears`, and `Weight`.

---

## 📈 Analytical Insights & Model Performance

### Model Comparison Table
| Metric | Full Model (9 Variables) | Reduced Model (6 Variables) | Evaluation Insight |
| :--- | :---: | :---: | :--- |
| **$R^2$** | 0.8686 | 0.8679 | The full model captures slightly more variance due to mathematical properties of adding variables. |
| **Adjusted $R^2$** | 0.8678 | 0.8674 | The marginal drop (0.0004) confirms that the 3 removed variables added practically zero predictive power. |

### Real-World Business Interpretations
Utilizing the optimized, parsimonious model, the real-world operational impact of vehicle depreciation can be precisely isolated (holding all other variables constant):
*   **The Cost of Time (Age Depreciation):** For every additional **year** a car ages, its market value drops by approximately **€1,450.40** (derived from a monthly depreciation of €120.87).
*   **The Cost of Usage (Odometer Impact):** For every additional **10,000 kilometers** driven, the vehicle's value drops by **€164.60**.

---

## 💻 Technical Environment & Execution
*   **Language:** R
*   **Core Libraries Used:** `car` (for Variance Inflation Factor metrics)
*   **Core Functions Demonstrated:** `lm()`, `qt()`, `pt()`, `fitted()`, `residuals()`, `vif()`

### How to Run the Code
1. Clone this repository to your local machine.
2. Ensure you have the `UsedCars.csv` data file in your working directory.
3. Open `used_car_regression.R` in RStudio and execute the scripts sequentially to view console outputs and verification matrices.
