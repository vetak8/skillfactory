DESCRIPTION:

To detect cheaters in the platform where a person can buy second hand car,
it is a good way to predict a price of car by parameters.
In case the price is suspicious, the AD with this car can be marked for addition check by human.
For example, the price is very cheap, but seller mentioned that that car in good condition and mileage is not big.
Most likely it is a cheater.

PROJECT TARGETS:

 - Predict price of the car by knowing technical and some commercial parameters.
 - Competition has only test set, so it is requered to find data for training models.
 - Provide Exploratory Data Analysis and find hidden insights.
 - Make a Feature engineering
 - Buld a models
 - Submission to the competition

HOW TO RUN:

Project consits seven parts:
	- test.csv
	- train_parsed_24_05_21.csv
	- Preprocessing.py
	- Car_Price_Prediction_(the _A_Team)_[Scraping].ipynb
	- Car_Price_Prediction_(the _A_Team)_[Prt.1 EDA].ipynb
	- Car Price Prediction (the _A_Team) [Prt.2 MODELS].ipynb
	- pandas_report.html

1) First you need to download test.csv and train_parsed_24_05_21.csv.
It is located in the link below:
https://www.kaggle.com/pauldark/cars-prices-24-05-21-autoru

2) All files shall be placed in the same folder.

3) Car_Price_Prediction_(the _A_Team)_[Scraping].ipynb file is for scraping data from auto.ru. Not necessary to run. 
In case you need scrap more actual data, then you can run it

4) Run Car_Price_Prediction_(the _A_Team)_[Prt.1 EDA].ipynb. This part includes exploratory data analyse

5) Car Price Prediction (the _A_Team) [Prt.2 MODELS].ipynb. This part includes feature engineering and models.

6) Preprocessing.py. This part is for fast preprocessing of the datasets. It is using in Car Price Prediction (the _A_Team) [Prt.2 MODELS].ipynb.
Without Preprocessing.py. you won't be able to run models.

7) pandas_report.html includes brief exploratory report about train data. 
It also can be run from Car_Price_Prediction_(the _A_Team)_[Prt.1 EDA].ipynb


MODELS INSIDE:

	- Random Forest regressor
	- Extream Tree Regressor
	- CatBoost regressor
	- LightGBM regressor
	- XGBoost Regressor
	- Sklearn Gradient Boost regressor
	- Stacking