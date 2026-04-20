import numpy as np

def save_masks(mask_cpg, mask_gene, base_path):
    np.save(base_path + "mask_cpg_gene_saved.npy", mask_cpg)
    np.save(base_path + "mask_gene_path_saved.npy", mask_gene)

def reload_masks(base_path):
    m1 = np.load(base_path + "mask_cpg_gene_saved.npy")
    m2 = np.load(base_path + "mask_gene_path_saved.npy")

    print("Reloaded masks:", m1.shape, m2.shape)
    return m1, m2
