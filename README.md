# Social Media Analytics: Real Estate Price Prediction project implemented using R

The 'House Prices in Poland' dataset is taken from Kaggle (as of Feb, 2021): https://www.kaggle.com/datasets/dawidcegielski/house-prices-in-poland/data 

### Part 1: Quantitative Analysis of Scenario Data

1.1 Data Overview 

1.2 Descriptive Statistics & Data Visualization
<img width="951" height="533" alt="image" src="https://github.com/user-attachments/assets/9653c826-8aad-4b4a-82e4-9daf2a4bedfd" />
<img width="819" height="400" alt="image" src="https://github.com/user-attachments/assets/bc012d6f-ec5c-46c1-95d8-3c43c711e276" />

1.3 Correlation Analysis

1.4 Data Preprocessing & Feature Engineering

1.5 Data Prediction & Modeling:
- Linear Regression: R² = 0.664
- Decision Tree: R² = 0.843

### Part 2: Data from Social Media

The data was collected from Instagram platform: https://www.instagram.com/warsawishere.realestate/ (Warsaw Real Estate page)

2.1 Web Data collection

2.2 Data Overview
- The initial dataset is saved as 'instagram_posts_raw.csv' 
  
2.3 Data Preprocessing, Cleaning & Feature Engineering 
- Final/preprocessed dataset is saved as 'insta_df.csv'

2.4 Data Visualization
<img width="984" height="547" alt="image" src="https://github.com/user-attachments/assets/ec501f71-004c-4839-9fff-fae31db440a8" />

<img width="972" height="447" alt="image" src="https://github.com/user-attachments/assets/230c059f-5815-4f3d-af3b-fcbef0ec8a17" />

2.5 Data Prediction & Modeling:
- Linear Regression: R² = 0.435 (all predictors) vs R² = 0.435 (after feature selection)
- Random Forest: R² = 0.722 (all predictors) vs R² = 0.839 (after feature selection)




