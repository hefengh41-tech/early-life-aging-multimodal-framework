import numpy as np

def diagnostics(X, Y):
    print("X shape:", X.shape)
    print("Y shape:", Y.shape)

    print("NaN in X:", np.isnan(X).sum())
    print("Inf in X:", np.isinf(X).sum())

    print("NaN in Y:", np.isnan(Y).sum())
    print("Inf in Y:", np.isinf(Y).sum())

    zero_var = np.sum(np.var(X, axis=0) == 0)
    print("Zero variance CpGs:", zero_var)
