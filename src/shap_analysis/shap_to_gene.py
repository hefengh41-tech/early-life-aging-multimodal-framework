import numpy as np
import pandas as pd

def project_to_gene(shap_values, indices, mask, gene_names):

    mean_shap = np.abs(shap_values).mean(axis=0)

    full = np.zeros(mask.shape[0])
    full[indices] = mean_shap

    gene_scores = np.dot(full, mask)

    df = pd.DataFrame({
        "Gene": gene_names,
        "SHAP_Score": gene_scores
    }).sort_values("SHAP_Score", ascending=False)

    return df
