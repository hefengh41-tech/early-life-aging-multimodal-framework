import numpy as np
import shap
from sklearn.linear_model import Ridge
from sklearn.feature_selection import SelectKBest, f_regression

def run_shap(X, Y, k=1000):

    y = Y[:, 0]

    selector = SelectKBest(f_regression, k=k)
    X_selected = selector.fit_transform(X, y)

    selected_indices = selector.get_support(indices=True)

    model = Ridge(alpha=1.0)
    model.fit(X_selected, y)

    background = X_selected[:10]
    explainer = shap.KernelExplainer(model.predict, background)

    shap_values = explainer.shap_values(X_selected[:50])

    np.save("outputs/tables/shap_values.npy", shap_values)
    np.save("outputs/tables/shap_indices.npy", selected_indices)

    return shap_values, selected_indices
