import pandas as pd
import numpy as np
import re

def missing_vars(data, column, random_proba=True):
    '''Function is called for filling of missing data'''
    # With using probability and random choise

    if random_proba:
        col_name = data[column].value_counts().index.to_list(
        )  # get list of values
        col_distr = data[column].value_counts(
            normalize=True).values  # get l;ist of probs
        missing = data[col].isnull()  # flag of missing val
        # substitute values from the list of names in accordance with the probability of meeting the name
        data.loc[missing, [column]] = np.random.choice(col_name,
                                                    size=len(data[missing]),
                                                    p=col_distr)

    # Using  most common in  column
    data[col] = data[col].fillna(data[col].value_counts().index[0])

df_train = pd.read_csv('train_parsed_24_05_21.csv',low_memory=False)
df_test = pd.read_csv('test.csv')

df_test['price'] = np.nan

# let's mark where is train where is test set.
df_train['sample'] = 1  # train
df_test['sample'] = 0  # test

columns = {
    'bodyType': 'body_type',
    'engineDisplacement': 'engine_displacement',
    'enginePower': 'engine_power',
    'fuelType': 'fuel_type',
    'modelDate': 'model_date',
    'numberOfDoors': 'doors_count',
    'priceCurrency': 'price_currency',
    'productionDate': 'production_date',
    'vehicleConfiguration': 'vehicle_configuration',
    'vehicleTransmission': 'vehicle_transmission',
    'Владельцы': 'owner_count',
    'Владение': 'owning_period',
    'ПТС': 'car_passport',
    'Привод': 'wheel_drive',
    'Руль': 'wheel_location',
    'Состояние': 'condition',
    'Таможня': 'custom'
}

df_test.rename(columns=columns,inplace=True)
df_train.rename(columns=columns,inplace=True)
# drop 100% usless cols
df_test = df_test.drop(['car_url','parsing_unixtime'],axis=1)
df_train = df_train.drop(['car_url','parsing_unixtime'],axis=1)
# convert mm to liters in train set
df_train['engine_displacement'] = round(df_train['engine_displacement']/1000, 1)

# clear 'LTR in test set'
df_test['engine_displacement'] = df_test['engine_displacement'].apply(
    lambda x: str(x).replace('LTR', ''))

# convert object to float in test set
df_test['engine_displacement'] = df_test['engine_displacement'].apply(
    lambda x: np.nan if x.strip() == '' else float(x))
# clear 'N12 in test set'
df_test['engine_power'] = df_test['engine_power'].apply(
    lambda x: str(x).replace('N12', ''))

# convert object to float in test set
df_test['engine_power'] = df_test['engine_power'].apply(
    lambda x: np.nan if x.strip() == '' else float(x))

# Let's do same for train set
df_train['owner_count'] = df_train['owner_count'].map({1.0:'1',2.0:'2',3.0:'3',4.0:'3'}).astype('category')

# And clear test set from usless words.
df_test['owner_count'] = df_test['owner_count'].apply(lambda x: x[0]).astype('category')

cols_to_int64 = ['model_date', 'doors_count']

for col in cols_to_int64:
    missing_vars(df_train, col)
    df_train[col] = df_train[col].astype('int64')

df_train['body_type'] = list(str(x).lower().replace('.','') for x in df_train['body_type'])
df_test['body_type'] = list(str(x).lower().replace('.','') for x in df_test['body_type'])

color_map = {'FFD600':'жёлтый',
          "660099":'пурпурный',
          "DEA522":'золотистый',
          "007F00":'зелёный',
          "040001":'чёрный',
          "C49648":'бежевый',
          "CACECB":'серебристый',
          "EE1D19":'красный',
          "0000CC":'синий',
          "22A0F8":'голубой',
          "FFC0CB":'розовый',
          "4A2197":'фиолетовый',
          "FF8649":'оранжевый',
          "200204":'коричневый',
          "97948F":'серый',
          "FAFBFB":'белый'}

df_train['color'] = df_train['color'].map(color_map)
df_train['price_currency'] = df_train['price_currency'].map({'RUR': 'RUB'})
eng_dict = {
    'роботизированная': 'ROBOT',
    'механическая': 'MECHANICAL',
    'автоматическая': 'AUTOMATIC',
    'вариатор': 'VARIATOR'
}

df_test['vehicle_transmission'] = df_test['vehicle_transmission'].map(eng_dict)

df_test['car_passport'] = df_test['car_passport'].map(
    {'Оригинал': 'ORIGINAL', 'Дубликат': 'DUPLICATE'})

df_test['wheel_location'] = df_test['wheel_location'].map(
    {'Левый': 'LEFT', 'Правый': 'RIGHT'})

mers = ['Mercedes-Benz']
# Make replacemewnt
df_train.loc[df_train['brand'].isin(mers), 'brand'] = 'MERCEDES'





df_combined = df_test.append(df_train, sort=False).reset_index(
    drop=True)  # combine sets
