import pandas as pd

def merge_shap_ctd():
    shap_df = pd.read_csv("outputs/tables/binn_gene_shap_scores.csv")
    ctd = pd.read_csv("data/processed/ctd_with_gene_ids.csv")

    merged = pd.merge(
        ctd,
        shap_df,
        left_on="HGNC_Symbol",
        right_on="Gene",
        how="inner"
    )

    merged.to_csv("outputs/tables/shap_ctd_merged.csv", index=False)

    print("SHAP + CTD merged:", merged.shape)

if __name__ == "__main__":
    merge_shap_ctd()
