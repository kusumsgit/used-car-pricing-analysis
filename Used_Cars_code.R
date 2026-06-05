# ============================================================
# MGT 6203 - Data Analytics in Business
# Homework 1 - Part 1: Linear Models
# ============================================================


# ============================================================
# TASK 1: Import Data and Run a Linear Regression
# ============================================================

# --- Question 1: Import data and run regression ---

# Step 1: Import the data
data <- read.csv("E:/GTU/MGT 6203 Data analytics in Business/HW1/UsedCars.csv")

# Step 2: Check column names
names(data)

# Step 3: Clean the data (remove Id and Model columns)
data_clean <- data[, -c(1, 2)]

# Step 4: Peek at the first few rows
head(data_clean)

# Step 5: Run linear regression of Price on all explanatory variables
model <- lm(Price ~ ., data = data_clean)

# Step 6: Show regression results
summary(model)


# --- Question 2: Fitted values and residuals ---

# Get actual prices (y)
y_actual <- data_clean$Price

# Get fitted values (y-hat) — model predictions
fitted_values <- fitted(model)

# Get residuals (y - y-hat) — prediction errors
residuals <- residuals(model)

# Show first 10 observations side by side
comparison <- cbind(y_actual[1:10], fitted_values[1:10], residuals[1:10])
colnames(comparison) <- c("Actual_Y", "Fitted_Y", "Residuals")
comparison

# Verify: residuals should equal y - y-hat
manual_residuals <- y_actual[1:10] - fitted_values[1:10]
cbind(residuals[1:10], manual_residuals)
# They are exactly the same!


# ============================================================
# TASK 2: t-Statistic and p-Value
# ============================================================

# --- Question 3: Reproduce t-statistics ---

# Extract coefficients (beta-hat values)
beta_hat <- coef(model)

# Extract standard errors (column 2 of coefficients table)
se <- summary(model)$coefficients[, 2]

# Calculate t-statistics manually: t = beta-hat / se(beta-hat)
t_manual <- beta_hat / se

# Get R's t-statistics (column 3 of coefficients table)
t_from_R <- summary(model)$coefficients[, 3]

# Compare them side by side — should be exactly the same
cbind(t_manual, t_from_R)


# --- Question 4: Critical value at 95% confidence ---

# Get degrees of freedom from the model
df <- model$df.residual
df

# Find critical t-value at 95% confidence (two-tailed)
# 97.5th percentile because 2.5% in each tail
critical_value <- qt(0.975, df)
critical_value


# --- Question 5: Calculate p-values ---

# Formula: p = 2 * P(t < -|t_stat|)
p_manual <- 2 * pt(-abs(t_manual), df)

# Get R's p-values (column 4 of coefficients table)
p_from_R <- summary(model)$coefficients[, 4]

# Compare — should be exactly the same
cbind(p_manual, p_from_R)


# --- Question 6: Which variables are significant? ---

# Method 1: p-value < 0.05
significant <- p_manual < 0.05

# Method 2: |t-statistic| > critical value
significant2 <- abs(t_manual) > critical_value

# Both methods give the same answer
cbind(significant, significant2)


# ============================================================
# TASK 3: R-squared and VIF
# ============================================================

# --- Question 7: Calculate R-squared manually ---

# Calculate TSS (Total Sum of Squares)
y_mean <- mean(y_actual)
TSS <- sum((y_actual - y_mean)^2)

# Calculate RSS (Regression Sum of Squares)
RSS <- sum((fitted_values - y_mean)^2)

# Calculate R-squared: R² = RSS / TSS
R_squared_manual <- RSS / TSS
R_squared_manual

# Compare with R's R-squared
R_squared_from_R <- summary(model)$r.squared
R_squared_from_R

# They should be the same
cbind(R_squared_manual, R_squared_from_R)


# --- Question 8: VIF using car package ---

# Install the package (only need to do this once)
install.packages("car")

# Load the package
library(car)

# Calculate VIF for all variables
vif_values <- vif(model)
vif_values


# --- Question 9: Reproduce VIF for Weight manually ---

# Step i: Regress Weight on all other independent variables
model_weight <- lm(Weight ~ Age + KM + HP + Metallic + Automatic + CC + Doors + Gears, data = data_clean)

# Get R-squared from this regression
R_squared_weight <- summary(model_weight)$r.squared
R_squared_weight

# Step ii: Calculate VIF using formula: VIF = 1 / (1 - R²)
VIF_weight_manual <- 1 / (1 - R_squared_weight)
VIF_weight_manual

# Compare with vif() output
vif_values["Weight"]

# They should be the same
cbind(VIF_weight_manual, vif_values["Weight"])


# ============================================================
# TASK 4: Model Comparison
# ============================================================

# --- Question 10: New model with only significant variables ---

# From Question 6, significant variables are: Age, KM, HP, Automatic, Gears, Weight
model_new <- lm(Price ~ Age + KM + HP + Automatic + Gears + Weight, data = data_clean)
summary(model_new)


# --- Question 11: Compare R-squared and Adjusted R-squared ---

comparison_table <- data.frame(
  Model = c("Full (all 9 variables)", "Reduced (6 significant)"),
  R_squared = c(summary(model)$r.squared, summary(model_new)$r.squared),
  Adjusted_R_squared = c(summary(model)$adj.r.squared, summary(model_new)$adj.r.squared)
)
comparison_table


# --- Question 12: Interpret effects from the better model ---

# Show coefficients of the reduced model
coef(model_new)

# Effect of Age: price decrease per YEAR (Age is in months, so multiply by 12)
age_effect_per_year <- coef(model_new)["Age"] * 12
age_effect_per_year

# Effect of KM: price decrease per 10,000 km
km_effect_per_10000 <- coef(model_new)["KM"] * 10000
km_effect_per_10000
