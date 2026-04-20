import pandas as pd

def filter_chronic():
    df = pd.read_csv("outputs/tables/shap_ctd_merged.csv")

    keywords = [
        "diabetes", "cardio", "cancer", "neuro", "alzheimer",
        "asthma", "copd", "arthritis", "inflamm"
    ]

    mask = df["DiseaseName"].str.lower().apply(
        lambda x: any(k in x for k in keywords)
    )

    filtered = df[mask]

    filtered.to_csv("outputs/tables/chronic_disease_filtered.csv", index=False)

    print("Filtered diseases:", filtered.shape)

if __name__ == "__main__":
    filter_chronic()
