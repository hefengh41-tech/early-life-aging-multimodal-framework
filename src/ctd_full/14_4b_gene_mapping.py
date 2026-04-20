import pandas as pd

def map_genes():
    df = pd.read_csv("data/raw/gene_info", sep="\t")

    df_human = df[df["#tax_id"] == 9606]

    mapping = df_human[["GeneID", "Symbol"]]

    mapping.to_csv("data/processed/gene_mapping.csv", index=False)

    print("Gene mapping saved")

if __name__ == "__main__":
    map_genes()
