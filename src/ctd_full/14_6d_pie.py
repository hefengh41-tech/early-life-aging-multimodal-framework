import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

def pie_chart():
    df = pd.read_csv("outputs/tables/chronic_disease_by_category.csv")

    counts = df["Category"].value_counts()

    colors = sns.color_palette("Set3", len(counts))

    plt.figure(figsize=(8,8))
    plt.pie(
        counts.values,
        labels=counts.index,
        autopct='%1.1f%%',
        colors=colors,
        startangle=140
    )

    plt.title("Disease Category Distribution")
    plt.tight_layout()

    plt.savefig("outputs/figures/disease_category_pie.jpeg", dpi=600)

    print("Pie chart saved")

if __name__ == "__main__":
    pie_chart()
