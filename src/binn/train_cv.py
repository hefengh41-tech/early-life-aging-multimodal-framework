import numpy as np
from sklearn.model_selection import KFold
from tensorflow.keras.optimizers import Adam
from .model import UpgradedBINN

def train_cv(X, Y, mask_cpg, mask_gene):

    kf = KFold(n_splits=5, shuffle=True, random_state=42)

    results = []

    for fold, (train_idx, val_idx) in enumerate(kf.split(X)):

        model = UpgradedBINN(mask_cpg, mask_gene)

        model.compile(
            optimizer=Adam(1e-3),
            loss="mse"
        )

        model.fit(
            X[train_idx], Y[train_idx],
            validation_data=(X[val_idx], Y[val_idx]),
            epochs=50,
            batch_size=8,
            verbose=1
        )

        results.append(model)

    return results
