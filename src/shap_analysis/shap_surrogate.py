import numpy as np
import shap
from sklearn.linear_model import Ridge
from sklearn.feature_selection import SelectKBest, f_regression

def run_shap(X, Y, k=1000):

    y = Y[:, 0]

    selector = SelectKBest(f_regression, k=k)
    X_reduced = selector.fit_transform(X, y)

    model = Ridge()
    model.fit(X_reduced, y)

    explainer = shap.KernelExplainer(model.predict, X_reduced[:10])
    shap_values = explainer.shap_values(X_reduced[:5])

    return shap_values, selector.get_support(indices=True)
