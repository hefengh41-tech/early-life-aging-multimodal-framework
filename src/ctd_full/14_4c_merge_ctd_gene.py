import pandas as pd

def merge_ctd_gene():
    ctd = pd.read_csv("data/processed/ctd_clean.csv")
    mapping = pd.read_csv("data/processed/gene_mapping.csv")

    merged = pd.merge(
        ctd,
        mapping,
        left_on="HGNC_Symbol",
        right_on="Symbol",
        how="left"
    )

    merged.to_csv("data/processed/ctd_with_gene_ids.csv", index=False)

    print("CTD merged with gene IDs")

if __name__ == "__main__":
    merge_ctd_gene()
