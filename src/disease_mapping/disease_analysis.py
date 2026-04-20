import pandas as pd

def map_diseases(shap_df, ctd_df):

    shap_genes = set(shap_df["Gene"])

    filtered = ctd_df[ctd_df["HGNC_Symbol"].isin(shap_genes)]

    merged = pd.merge(
        filtered,
        shap_df,
        left_on="HGNC_Symbol",
        right_on="Gene"
    )

    return merged.sort_values("SHAP_Score", ascending=False)
