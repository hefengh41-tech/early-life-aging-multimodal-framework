import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from sklearn.model_selection import KFold
from .12_7_model import BINN
from .12_8_compile_strategy import compile_model

def train_cv(X, Y, mask_cpg, mask_gene, strategy):

    kf = KFold(n_splits=5, shuffle=True, random_state=42)
    preds_all = []

    os.makedirs("outputs/models", exist_ok=True)
    os.makedirs("outputs/figures", exist_ok=True)
    os.makedirs("outputs/tables", exist_ok=True)

    for fold, (tr, val) in enumerate(kf.split(X)):

        with strategy.scope():
            model = BINN(mask_cpg, mask_gene)
            model = compile_model(model)

        history = model.fit(
            X[tr], Y[tr],
            validation_data=(X[val], Y[val]),
            epochs=50,
            batch_size=8,
            verbose=1
        )

        model.save(f"outputs/models/model_fold_{fold}.h5")

        hist_df = pd.DataFrame(history.history)
        hist_df.to_csv(f"outputs/tables/history_fold_{fold}.csv", index=False)

        plt.figure()
        plt.plot(hist_df["loss"], label="train")
        plt.plot(hist_df["val_loss"], label="val")
        plt.legend()
        plt.title(f"Fold {fold}")
        plt.savefig(f"outputs/figures/training_curve_fold_{fold}.png")
        plt.close()

        preds = model.predict(X[val])
        preds_all.append(preds)

        np.save(f"outputs/tables/preds_fold_{fold}.npy", preds)

    ensemble = np.mean(np.vstack(preds_all), axis=0)
    np.save("outputs/tables/ensemble_predictions.npy", ensemble)

    print("Cross-validation complete")
