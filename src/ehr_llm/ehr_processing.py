import pandas as pd

def load_ehr_data(path):
    df = pd.read_csv(path)
    print("EHR shape:", df.shape)
    return df


def basic_cleaning(df):
    df = df.drop_duplicates()
    df = df.fillna("UNKNOWN")
    return df
