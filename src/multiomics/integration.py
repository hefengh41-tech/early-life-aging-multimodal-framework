import pandas as pd

def merge_modalities(beta_df, ehr_df):
    """
    Merge methylation + EHR features
    """
    merged = pd.merge(beta_df, ehr_df, on="Sample_ID", how="inner")
    print("Merged shape:", merged.shape)
    return merged
