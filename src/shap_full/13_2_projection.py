import numpy as np
import pandas as pd

def project_shap_to_gene():

    shap_values = np.load("outputs/tables/shap_values.npy")
    shap_indices = np.load("outputs/tables/shap_indices.npy")

    mask_cpg_gene = np.load("data/processed/binn_cpg_gene_mask.npy")

    gene_names = pd.read_csv("data/processed/gene_names.csv")["Gene"].values

    # Mean absolute SHAP
    shap_mean = np.abs(shap_values).mean(axis=0)

    # Expand back to full CpG space
    full_shap = np.zeros(mask_cpg_gene.shape[0])
    full_shap[shap_indices] = shap_mean

    # Project to gene space
    gene_scores = np.dot(full_shap, mask_cpg_gene)

    df = pd.DataFrame({
        "Gene": gene_names,
        "SHAP_Score": gene_scores
    })

    df = df.sort_values("SHAP_Score", ascending=False)

    df.to_csv("outputs/tables/binn_gene_shap_scores.csv", index=False)

    print("Saved gene-level SHAP scores")
