# Early-Life Exposures and Biological Aging

## A Multimodal Prediction Framework Using LLM-Augmented EHRs, Multi-Omics Biomarkers, and Advanced Machine Learning

---

## Overview

This repository implements a fully reproducible, end-to-end computational framework for investigating the relationship between early-life environmental exposures and biological aging. The system integrates genome-wide DNA methylation data, biologically constrained neural networks, explainable AI, and curated gene–disease knowledgebases.

The pipeline proceeds from raw methylation sequencing data through differential analysis, functional enrichment, mechanistic modeling, and disease association mapping, with optional integration of electronic health records and language-model-derived exposure features.

---

## Pipeline Summary

The workflow consists of four major phases:

### Phase 1: Methylation Processing

* Raw BED file extraction and preprocessing
* CpG-level filtering and normalization
* Differential methylation analysis
* Genomic tiling (1 kb and 500 bp)
* Visualization (PCA, heatmaps, distributions)

### Phase 2: Functional Annotation

* CpG-to-gene mapping using genomic annotation
* Pathway enrichment analysis (aging-related databases)
* Gene–term network construction
* High-resolution publication-ready visualizations

### Phase 3: Mechanistic Modeling (BINN)

* Construction of a biologically informed neural network
* CpG → Gene → Pathway hierarchical architecture
* Mask-constrained learning
* Cross-validation and model evaluation
* Ensemble prediction generation

### Phase 4: Explainability and Disease Mapping

* SHAP-based feature attribution (surrogate model)
* CpG → gene importance projection
* Integration with CTD (Comparative Toxicogenomics Database)
* Chronic disease filtering and categorization
* Visualization of disease burden and category distributions

---

## Repository Structure

```
├── config/
│   └── config.yaml
│
├── data/
│   ├── raw/
│   └── processed/
│
├── outputs/
│   ├── figures/
│   ├── tables/
│   └── models/
│
├── src/
│   ├── methylation/        # Steps 1–10
│   ├── enrichment/         # Step 11
│   ├── binn_full/          # Step 12
│   ├── shap_full/          # Step 13
│   ├── ctd_full/           # Step 14
│   ├── ehr_llm/            # Optional multimodal layer
│   ├── multiomics/
│   └── modeling/
│
├── run_pipeline.py
├── requirements.txt
├── environment.yml
└── README.md
```

---

## Installation

### Option 1: Conda (recommended)

```
conda env create -f environment.yml
conda activate methylation_env
```

### Option 2: pip

```
pip install -r requirements.txt
```

---

## Data Requirements

### Required Inputs

1. **DNA Methylation Data**

   * GEO dataset (e.g., GSE54983)
   * Format: `.bed.gz`
   * Place in:

     ```
     data/raw/GSE54983_RAW/
     ```

2. **CTD Database**

   * Automatically downloaded during pipeline execution

3. **NCBI gene_info**

   * Automatically downloaded during pipeline execution

4. **Optional: EHR Data**

   * CSV format
   * Must include:

     * `clinical_notes`
     * `Sample_ID`

---

## Running the Pipeline

Execute the full pipeline:

```
python run_pipeline.py
```

This will automatically run:

* Methylation preprocessing and analysis
* Functional enrichment
* BINN model training
* SHAP analysis
* CTD disease mapping

---

## Outputs

### Figures

Located in:

```
outputs/figures/
```

Includes:

* Volcano plots
* Manhattan plots
* PCA and heatmaps
* Enrichment barplots
* Radial gene–term networks
* Chromosome-level analyses
* Disease burden visualizations

---

### Tables

Located in:

```
outputs/tables/
```

Includes:

* Differential methylation results
* Annotated CpGs
* Enrichment outputs
* SHAP feature importance
* Gene–disease associations

---

### Models

Located in:

```
outputs/models/
```

Includes:

* Trained BINN models (per fold)
* Ensemble predictions

---

## Key Methodological Components

### Biologically Informed Neural Network (BINN)

* Enforces biological structure through connectivity masks
* Reduces model interpretability gap
* Enables mechanistic interpretation of methylation effects

### SHAP-Based Explainability

* Surrogate Ridge model used for tractable SHAP computation
* Feature importance projected from CpGs to genes

### CTD Integration

* Links model-derived gene importance to disease associations
* Enables downstream clinical interpretation

---

## Important Notes

* SHAP values are derived from a surrogate model, not directly from the BINN model
* CpG feature space is reduced via variance-based bottlenecking
* Sample size is limited; results should be interpreted as mechanistic insights rather than definitive predictive conclusions
* Internet access is required for CTD and enrichment queries

---

## Reproducibility

This repository is designed to be fully reproducible:

1. Clone repository
2. Install dependencies
3. Place raw data in `data/raw/`
4. Run `python run_pipeline.py`

All outputs will be generated automatically.

---

## Citation

If you use this repository, please cite:

```
Hefeng (2026). Early-Life Exposures and Biological Aging:
A Multimodal Prediction Framework Using LLM-Augmented EHRs,
Multi-Omics Biomarkers, and Advanced Machine Learning.
```

---

## License

This project is released under the MIT License.

---

## Contact

For questions or collaboration:

* Open an issue in this repository
* Contact the corresponding author
* hefengh41@gmail.com
