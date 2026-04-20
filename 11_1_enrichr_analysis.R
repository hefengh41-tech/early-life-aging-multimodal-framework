# =====================================================
# STEP 11.1 — Aging Enrichment (FULL VERSION)
# =====================================================

library(enrichR)
library(readr)
library(dplyr)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)

# -------------------------------
# Load annotated CpGs
# -------------------------------
annot_file <- "data/processed/annotated_sig_cpgs.csv"
annot_df <- read.csv(annot_file, stringsAsFactors = FALSE)

gene_list <- unique(na.omit(annot_df$SYMBOL))
gene_list <- gene_list[gene_list != ""]

cat("Gene symbols:", length(gene_list), "\n")

# Save gene list
write.csv(gene_list,
          "data/processed/gene_list_for_enrichment.csv",
          row.names = FALSE)

# -------------------------------
# Run enrichR
# -------------------------------
dbs <- c("Aging_Perturbations_from_GEO_up")

enrich_out <- enrichr(gene_list, dbs)
aging_df <- enrich_out[[1]]

# Save output
write.csv(aging_df,
          "data/processed/enrichment_aging_up.csv",
          row.names = FALSE)

cat("Enrichment complete.\n")
