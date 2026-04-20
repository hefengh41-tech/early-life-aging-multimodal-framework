def fix_masks(X, mask_cpg_gene, mask_gene_path):
    if X.shape[1] != mask_cpg_gene.shape[0]:
        raise ValueError("Mismatch between CpGs and mask")

    print("Mask dimensions OK:", mask_cpg_gene.shape, mask_gene_path.shape)
    return mask_cpg_gene, mask_gene_path
