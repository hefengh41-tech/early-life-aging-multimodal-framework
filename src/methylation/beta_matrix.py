import pandas as pd

def inspect_beta_matrix(beta_path):
    beta_df = pd.read_csv(beta_path)

    print("Shape:", beta_df.shape)

    if "CpG" not in beta_df.columns:
        raise ValueError("Missing CpG column")

    sample_cols = beta_df.columns.drop("CpG")
    print("Samples:", sample_cols[:10].tolist())

    na_count = beta_df.isna().sum().sum()
    print("Missing values:", na_count)

    return beta_df
