import pandas as pd
import matplotlib.pyplot as plt

def plot_bar():
    df = pd.read_csv("outputs/tables/chronic_disease_filtered.csv")

    agg = df.groupby("DiseaseName")["SHAP_Score"].sum().sort_values(ascending=False).head(15)

    plt.figure(figsize=(10,6))
    agg[::-1].plot(kind="barh")

    plt.xlabel("Aggregated SHAP Score")
    plt.title("Top Chronic Diseases")

    plt.tight_layout()
    plt.savefig("outputs/figures/disease_barplot.jpeg", dpi=600)

    print("Bar plot saved")

if __name__ == "__main__":
    plot_bar()
