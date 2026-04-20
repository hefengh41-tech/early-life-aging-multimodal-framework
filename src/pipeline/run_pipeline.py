from src.binn.data_loader import load_data
from src.binn.train_cv import train_cv
from src.shap_analysis.shap_surrogate import run_shap

def main():

    base = "data/processed/"

    X, Y, mask_cpg, mask_gene = load_data(base)

    print("Training BINN...")
    models = train_cv(X, Y, mask_cpg, mask_gene)

    print("Running SHAP...")
    shap_values, indices = run_shap(X, Y)

    print("Pipeline complete.")

if __name__ == "__main__":
    main()
