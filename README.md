# credit-fraud-predictions

Build model and API to detect credit-fraud-transactions from given data


./rmd

1. variable-selection.rmd is for removing redundant variables using variable clustering . You dont need to run this because is saved the results in files that end with "_clust.csv" . These files are loaded into EDA.rmd
2. EDA.rmd is for feature and interactions selection really . You also dont have to run this because is saved the results in files that end with "_eda.csv" or "_eda.rds" . These files are loaded in credit.rmd
3. credit.rmd is for model building . The model and other important things are saved in /api folder for building our API . You can run this to see how the model performs on test data 


./api 

This folder contains all important files for building and running our api . 