from src.ehr_llm.ehr_processing import load_ehr_data, basic_cleaning
from src.ehr_llm.llm_feature_extraction import extract_exposure_features
from src.multiomics.integration import merge_modalities
from src.modeling.train_model import train_model

from src.modeling.shap_analysis import run_shap_analysis, save_shap_summary
from src.modeling.feature_importance import get_feature_importance
from src.modeling.ablation import run_ablation

from src.methylation.preprocessing import create_sample_sheet, preview_bed_file
from src.methylation.beta_matrix import inspect_beta_matrix

import yaml

with open("config/config.yaml") as f:
    config = yaml.safe_load(f)

raw_dir = config["data"]["raw_dir"]
beta_path = config["files"]["beta_matrix"]

def main():
    # === Step 1: Define paths (edit these later) ===
    bed_dir = "data/raw/GSE54983_RAW"
    sample_sheet_path = "data/processed/sample_sheet.csv"
    beta_matrix_path = "data/processed/beta_matrix.csv"

    # === Step 2: Run preprocessing ===
    print("\n[1] Creating sample sheet...")
    create_sample_sheet(bed_dir, sample_sheet_path)

    print("\n[2] Preview BED file...")
    preview_bed_file(bed_dir)

    # === Step 3: Inspect beta matrix ===
    print("\n[3] Inspecting beta matrix...")
    inspect_beta_matrix(beta_matrix_path)

    print("\nPipeline completed successfully.")

    # === Step 4: Load EHR ===
    ehr_df = load_ehr_data("data/raw/ehr.csv")
    ehr_df = basic_cleaning(ehr_df)

    # === Step 5: Extract LLM features ===
    ehr_df["features"] = ehr_df["clinical_notes"].apply(extract_exposure_features)
    features_df = ehr_df["features"].apply(pd.Series)
    ehr_df = pd.concat([ehr_df, features_df], axis=1)

    # === Step 6: Merge modalities ===
    merged_df = merge_modalities(beta_df, ehr_df)

    # === Step 7: Train model ===
    model = train_model(merged_df, target_col="biological_age")

    # === Step 8: SHAP explainability ===
    X_sample = merged_df.drop(columns=["biological_age"]).sample(100)
    shap_values = run_shap_analysis(model, X_sample)
    save_shap_summary(shap_values, X_sample)

    # === Step 9: Feature importance ===
    get_feature_importance(model, X_sample.columns)

    # === Step 10: Ablation study ===
    run_ablation(merged_df, target_col="biological_age")

if __name__ == "__main__":
    main()


import subprocess

steps = [
    ["bash", "src/methylation/01_extract_data.sh"],
    ["python", "src/methylation/02_create_sample_sheet.py"],
    ["Rscript", "src/methylation/03_load_methylation.R"],
    ["Rscript", "src/methylation/04_filter_unite.R"],
    ["Rscript", "src/methylation/05_differential_analysis.R"],
    ["Rscript", "src/methylation/07_visualization.R"],
    ["Rscript", "src/methylation/08_beta_matrix.R"],
["python", "src/methylation/08_beta_visualization.py"],
    ["Rscript", "src/methylation/09_chromosome_analysis.R"],
    ["Rscript", "src/methylation/10_annotation.R"],
    ["Rscript", "src/enrichment/11_0_install_packages.R"],
["Rscript", "src/enrichment/11_1_enrichr_analysis.R"],
["Rscript", "src/enrichment/11_2_visualizations.R"],
    ["python", "src/shap_full/13_1_data_diagnostics.py"],
["python", "src/shap_full/13_1b_shap_surrogate.py"],
["Rscript", "src/shap_full/13_2a_extract_gene_names.R"],
["python", "src/shap_full/13_2_projection.py"],
]

for step in steps:
    print(f"Running: {step}")
    subprocess.run(step, check=True)
["Rscript", "src/methylation/06_tiling_analysis.R"],

