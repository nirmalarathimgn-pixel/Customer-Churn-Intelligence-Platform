import pandas as pd

# Upload dataset
from google.colab import files
uploaded = files.upload()

# Read dataset
df = pd.read_csv('WA_Fn-UseC_-Telco-Customer-Churn.csv')

# Show first rows
print(df.head())

# Check missing values
print(df.isnull().sum())

# Replace blank spaces
df['TotalCharges'] = df['TotalCharges'].replace(' ', pd.NA)

# Convert to numeric
df['TotalCharges'] = pd.to_numeric(df['TotalCharges'])

# Fill missing values
df['TotalCharges'] = df['TotalCharges'].fillna(
    df['TotalCharges'].median()
)

# Convert churn column
df['Churn'] = df['Churn'].map({
    'Yes': 1,
    'No': 0
})

# Save cleaned dataset
df.to_csv('cleaned_churn_data.csv', index=False)

print('Data cleaned successfully')

# ============================================
# CUSTOMER CHURN INTELLIGENCE PLATFORM
# COMPLETE MACHINE LEARNING PIPELINE
# ============================================

# ============================================
# 1. IMPORT LIBRARIES
# ============================================

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier

from sklearn.metrics import (
    accuracy_score,
    classification_report,
    confusion_matrix
)

# ============================================
# 2. LOAD DATASET
# ============================================

df = pd.read_csv("/content/WA_Fn-UseC_-Telco-Customer-Churn.csv")

print("Dataset Loaded Successfully")
print(df.head())

# ============================================
# 3. DATA PREPROCESSING
# ============================================

# Convert 'TotalCharges' to numeric, coercing errors to NaN
# This column often has issues with empty strings or spaces
df['TotalCharges'] = pd.to_numeric(df['TotalCharges'], errors='coerce')

# Fill NaN values in 'TotalCharges' with 0 (or mean/median, depending on analysis)
# For simplicity, filling with 0 here, assuming missing charges mean no charges
df['TotalCharges'] = df['TotalCharges'].fillna(0)

# Remove customerID column
df.drop("customerID", axis=1, inplace=True)

# Encode categorical columns
le = LabelEncoder()

for column in df.columns:

    if df[column].dtype == "object":

        df[column] = le.fit_transform(df[column])

print("\nData Encoding Completed")

# ============================================
# 4. FEATURE & TARGET SEPARATION
# ============================================

X = df.drop("Churn", axis=1)

y = df["Churn"]

# ============================================
# 5. TRAIN TEST SPLIT
# ============================================

X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.2,
    random_state=42
)

print("\nTrain Test Split Completed")

# ============================================
# 6. MODEL TRAINING
# ============================================

model = RandomForestClassifier(
    n_estimators=200,
    max_depth=10,
    random_state=42
)

model.fit(X_train, y_train)

print("\nModel Training Completed")

# ============================================
# 7. PREDICTIONS
# ============================================

y_pred = model.predict(X_test)

# ============================================
# 8. MODEL EVALUATION
# ============================================

accuracy = accuracy_score(y_test, y_pred)

print("\n====================================")
print("MODEL ACCURACY")
print("====================================")

print(f"Accuracy: {accuracy:.2f}")

print("\n====================================")
print("CLASSIFICATION REPORT")
print("====================================")

print(classification_report(y_test, y_pred))

print("\n====================================")
print("CONFUSION MATRIX")
print("====================================")

print(confusion_matrix(y_test, y_pred))

# ============================================
# 9. FEATURE IMPORTANCE
# ============================================

importance_df = pd.DataFrame({

    "Feature": X.columns,

    "Importance": model.feature_importances_

})

importance_df = importance_df.sort_values(
    by="Importance",
    ascending=False
)

print("\n====================================")
print("TOP IMPORTANT FEATURES")
print("====================================")

print(importance_df.head(10))

# ============================================
# 10. HIGH RISK CUSTOMER PREDICTION
# ============================================

prediction_probabilities = model.predict_proba(X)

# Probability of churn
df["Churn_Probability"] = prediction_probabilities[:, 1]

# High-risk customers
high_risk_customers = df[
    df["Churn_Probability"] > 0.70
]

print("\n====================================")
print("HIGH RISK CUSTOMERS")
print("====================================")

print(
    high_risk_customers[
        ["Churn_Probability"]
    ].head(10)
)

# ============================================
# 11. SAVE HIGH-RISK CUSTOMERS
# ============================================

high_risk_customers.to_csv(
    "high_risk_customers.csv",
    index=False
)

print("\nHigh-risk customers file saved")

# ============================================
# 12. BUSINESS INSIGHTS
# ============================================

print("\n====================================")
print("BUSINESS INSIGHTS")
print("====================================")

top_feature = importance_df.iloc[0]["Feature"]

print(f"Top churn-driving feature: {top_feature}")

print(
    "Customers with month-to-month contracts "
    "and higher monthly charges are more "
    "likely to churn."
)

# Top feature importance graph

top_features = importance_df.head(10)

plt.figure(figsize=(10, 6))

plt.barh(
    top_features["Feature"],
    top_features["Importance"]
)

plt.xlabel("Importance")
plt.ylabel("Features")

plt.title("Top Features Affecting Customer Churn")

plt.show()

# ============================================
# END OF PROJECT
# ============================================
