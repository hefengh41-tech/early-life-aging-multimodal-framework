import shap
import pandas as pd

def run_shap_analysis(model, X_sample):
    """
    Compute SHAP values for model interpretability
    """
    explainer = shap.TreeExplainer(model)
    shap_values = explainer.shap_values(X_sample)

    print("SHAP analysis completed.")
    return shap_values


def save_shap_summary(shap_values, X_sample, output_path="outputs/shap_summary.png"):
    shap.summary_plot(shap_values, X_sample, show=False)
    import matplotlib.pyplot as plt
    plt.tight_layout()
    plt.savefig(output_path, dpi=300)
    plt.close()
