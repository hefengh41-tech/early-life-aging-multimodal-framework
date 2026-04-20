import numpy as np

def load_all(base_path):
    X = np.load(base_path + "binn_beta_input_50k_clean.npy")
    Y = np.load(base_path + "binn_Y_labels_gsva_clean.npy")

    mask_cpg_gene = np.load(base_path + "binn_cpg_gene_mask.npy")
    mask_gene_path = np.load(base_path + "binn_gene_pathway_mask.npy")

    return X, Y, mask_cpg_gene, mask_gene_path
