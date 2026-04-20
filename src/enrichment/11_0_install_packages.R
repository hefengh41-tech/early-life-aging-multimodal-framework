# =====================================================
# STEP 11.0 — Install Enrichment & Plotting Toolchain
# FULL replication (Bioconductor + CRAN stack)
# =====================================================

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager", repos = "https://cloud.r-project.org")
}

BiocManager::install(
  c(
    "clusterProfiler",
    "enrichplot",
    "ComplexHeatmap",
    "org.Hs.eg.db",
    "msigdbr",
    "circlize"
  ),
  ask = FALSE,
  update = FALSE
)

install.packages(
  c(
    "ggraph",
    "igraph",
    "ggnewscale",
    "patchwork",
    "ggrastr",
    "ggridges",
    "RColorBrewer",
    "jpeg",
    "grid",
    "readr",
    "dplyr",
    "tidyr",
    "stringr",
    "ggplot2",
    "enrichR"
  ),
  repos = "https://cloud.r-project.org"
)

cat("All enrichment packages installed.\n")
