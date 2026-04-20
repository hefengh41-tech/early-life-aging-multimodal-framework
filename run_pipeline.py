import os
import subprocess
import yaml
import pandas as pd

# ================================
# LOAD CONFIG
# ================================
with open("config/config.yaml") as f:
    config = yaml.safe_load(f)

RAW_DIR = config["data"]["raw_dir"]
PROCESSED_DIR = config["data"]["processed_dir"]

# ================================
# HELPER: RUN STEP
# ================================
def run_step(step):
    print("\nRunning:", " ".join(step))
    subprocess.run(step, check=True)

# ================================
# MAIN PIPELINE
# ================================
def main():

    os.makedirs("outputs/figures", exist_ok=True)
    os.makedirs("outputs/tables", exist_ok=True)
    os.makedirs("outputs/models", exist_ok=True)

    steps = [

        # ----------------------------------
        # STEP 1–2: DATA EXTRACTION + SETUP
        # ----------------------------------
        ["bash", "src/methylation/01_extract_data.sh"],
        ["python", "src/methylation/02_create_sample_sheet.py"],

        # ----------------------------------
        # STEP 3–5: METHYLATION CORE
        # ----------------------------------
        ["Rscript", "src/methylation/03_load_methylation.R"],
        ["Rscript", "src/methylation/04_filter_unite.R"],
        ["Rscript", "src/methylation/05_differential_analysis.R"],

        # ----------------------------------
        # STEP 6: TILING (MUST COME EARLY)
        # ----------------------------------
        ["Rscript", "src/methylation/06_tiling_analysis.R"],

        # ----------------------------------
        # STEP 7: VISUALIZATION
        # ----------------------------------
        ["Rscript", "src/methylation/07_visualization.R"],

        # ----------------------------------
        # STEP 8: BETA MATRIX
        # ----------------------------------
        ["Rscript", "src/methylation/08_beta_matrix.R"],
        ["python", "src/methylation/08_beta_visualization.py"],

        # ----------------------------------
        # STEP 9: CHROMOSOME ANALYSIS
        # ----------------------------------
        ["Rscript", "src/methylation/09_chromosome_analysis.R"],

        # ----------------------------------
        # STEP 10: ANNOTATION
        # ----------------------------------
        ["Rscript", "src/methylation/10_annotation.R"],

        # ----------------------------------
        # STEP 11: ENRICHMENT
        # ----------------------------------
        ["Rscript", "src/enrichment/11_0_install_packages.R"],
        ["Rscript", "src/enrichment/11_1_enrichr_analysis.R"],
        ["Rscript", "src/enrichment/11_2_visualizations.R"],

        # ----------------------------------
        # STEP 12: BINN MODEL (FULL)
        # ----------------------------------
        ["python", "src/binn_full/12_0_device_setup.py"],
        ["python", "src/binn_full/12_1_load_inputs.py"],
        ["python", "src/binn_full/12_3_mask_save_reload.py"],
        ["python", "src/binn_full/12_5_data_diagnostics.py"],
        ["python", "src/binn_full/12_6_clean_filter.py"],
        ["python", "src/binn_full/12_6b_mask_fix.py"],
        ["python", "src/binn_full/12_6c_bottleneck.py"],
        ["python", "src/binn_full/12_9_cv_training.py"],

        # ----------------------------------
        # STEP 13: SHAP
        # ----------------------------------
        ["python", "src/shap_full/13_1_data_diagnostics.py"],
        ["python", "src/shap_full/13_1b_shap_surrogate.py"],
        ["Rscript", "src/shap_full/13_2a_extract_gene_names.R"],
        ["python", "src/shap_full/13_2_projection.py"],

        # ----------------------------------
        # STEP 14: CTD + DISEASE ANALYSIS
        # ----------------------------------
        ["python", "src/ctd_full/14_1_download_ctd.py"],
        ["python", "src/ctd_full/14_2_clean_ctd.py"],
        ["python", "src/ctd_full/14_4a_download_ncbi.py"],
        ["python", "src/ctd_full/14_4b_gene_mapping.py"],
        ["python", "src/ctd_full/14_4c_merge_ctd_gene.py"],
        ["python", "src/ctd_full/14_5_merge_shap_ctd.py"],
        ["python", "src/ctd_full/14_6a_filter_chronic.py"],
        ["python", "src/ctd_full/14_6b_barplot.py"],
        ["python", "src/ctd_full/14_6c_category.py"],
        ["python", "src/ctd_full/14_6d_pie.py"],
    ]

    # Execute all steps
    for step in steps:
        run_step(step)

    print("\nCore pipeline completed.")

    # ----------------------------------
    # OPTIONAL: MULTIMODAL ML LAYER
    # ----------------------------------
    try:
        from src.ehr_llm.ehr_processing import load_ehr_data, basic_cleaning
        from src.ehr_llm.llm_feature_extraction import extract_exposure_features
        from src.multiomics.integration import merge_modalities
        from src.modeling.train_model import train_model
        from src.modeling.shap_analysis import run_shap_analysis, save_shap_summary
        from src.modeling.feature_importance import get_feature_importance
        from src.modeling.ablation import run_ablation

        print("\nRunning multimodal ML layer...")

        ehr_df = load_ehr_data("data/raw/ehr.csv")
        ehr_df = basic_cleaning(ehr_df)

        ehr_df["features"] = ehr_df["clinical_notes"].apply(extract_exposure_features)
        features_df = ehr_df["features"].apply(pd.Series)
        ehr_df = pd.concat([ehr_df, features_df], axis=1)

        beta_df = pd.read_csv("data/processed/beta_matrix.csv")

        merged_df = merge_modalities(beta_df, ehr_df)

        model = train_model(merged_df, target_col="biological_age")

        X_sample = merged_df.drop(columns=["biological_age"]).sample(100)
        shap_values = run_shap_analysis(model, X_sample)
        save_shap_summary(shap_values, X_sample)

        get_feature_importance(model, X_sample.columns)
        run_ablation(merged_df, target_col="biological_age")

        print("\nMultimodal ML layer completed.")

    except Exception as e:
        print("\nSkipping multimodal ML layer:", str(e))


# ================================
# ENTRY POINT
# ================================
if __name__ == "__main__":
    main()
