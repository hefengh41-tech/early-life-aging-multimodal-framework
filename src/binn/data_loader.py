import numpy as np
import pandas as pd

def load_data(base_path):
    X = np.load(base_path + "binn_beta_input_50k_clean.npy").astype("float32")
    Y = np.load(base_path + "binn_Y_labels_gsva_clean.npy").astype("float32")

    mask_cpg = np.load(base_path + "binn_cpg_gene_mask.npy").astype("float32")
    mask_gene = np.load(base_path + "binn_gene_pathway_mask.npy").astype("float32")

    return X, Y, mask_cpg, mask_gene
