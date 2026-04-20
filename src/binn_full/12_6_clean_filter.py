import numpy as np

def clean_data(X, Y):
    mask = ~np.isnan(X).any(axis=1)
    mask &= ~np.isnan(Y).any(axis=1)

    X_clean = X[mask]
    Y_clean = Y[mask]

    print("Filtered samples:", X_clean.shape[0])

    return X_clean, Y_clean
