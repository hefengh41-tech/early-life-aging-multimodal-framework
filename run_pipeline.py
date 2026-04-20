from src.methylation.preprocessing import create_sample_sheet, preview_bed_file
from src.methylation.beta_matrix import inspect_beta_matrix

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

if __name__ == "__main__":
    main()
