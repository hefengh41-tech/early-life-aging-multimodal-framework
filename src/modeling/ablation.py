from src.modeling.train_model import train_model

def run_ablation(df, target_col):
    results = {}

    # Full model
    results["full"] = train_model(df, target_col)

    # Without EHR features
    ehr_cols = [c for c in df.columns if "risk" in c or "exposure" in c]
    df_no_ehr = df.drop(columns=ehr_cols, errors="ignore")
    results["no_ehr"] = train_model(df_no_ehr, target_col)

    # Without methylation (simplified assumption)
    meth_cols = [c for c in df.columns if "CpG" in c]
    df_no_meth = df.drop(columns=meth_cols, errors="ignore")
    results["no_methylation"] = train_model(df_no_meth, target_col)

    return results
