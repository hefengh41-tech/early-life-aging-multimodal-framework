import numpy as np

def bottleneck(X, mask_cpg_gene, top_k=1000):
    variances = np.var(X, axis=0)
    idx = np.argsort(-variances)[:top_k]

    X_reduced = X[:, idx]
    mask_reduced = mask_cpg_gene[idx, :]

    print("Reduced CpGs:", X_reduced.shape)

    return X_reduced, mask_reduced, idx
