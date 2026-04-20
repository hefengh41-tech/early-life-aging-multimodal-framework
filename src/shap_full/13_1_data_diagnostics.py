import numpy as np

def inspect_data(X, Y, indices):

    print("X shape:", X.shape)
    print("Y shape:", Y.shape)

    print("Selected CpG indices:", len(indices))

    print("NaN in X:", np.isnan(X).sum())
    print("Inf in X:", np.isinf(X).sum())

    print("NaN in Y:", np.isnan(Y).sum())
    print("Inf in Y:", np.isinf(Y).sum())

    unique_vals = np.unique(X[:, indices])
    print("Unique values (subset):", len(unique_vals))

    print("Diagnostics complete")
