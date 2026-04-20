# =====================================================
# STEP 10: CpG ANNOTATION (ChIPseeker)
# =====================================================

# -------------------------------
# Load required libraries
# -------------------------------
suppressPackageStartupMessages({
  library(methylKit)
  library(dplyr)
  library(ChIPseeker)
  library(GenomicRanges)
  library(TxDb.Hsapiens.UCSC.hg19.knownGene)
  library(org.Hs.eg.db)
})

# Create output directories
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)

# ================================
# 10.1 — Generate significant CpGs CSV
# ================================

cat("Step 10.1: Extracting significant CpGs...\n")

# Load methylation object
meth_united <- readRDS("data/processed/meth_united.rds")

# Run differential methylation
diff_obj <- calculateDiffMeth(meth_united)
diff_df <- getData(diff_obj)

# Filter significant CpGs
sig_df <- diff_df %>%
  filter(qvalue < 0.05, abs(meth.diff) >= 5)

# Save CSV
write.csv(sig_df,
          "data/processed/sig_cpgs.csv",
          row.names = FALSE)

cat("Saved: data/processed/sig_cpgs.csv\n")
cat("Total significant CpGs:", nrow(sig_df), "\n\n")

# ================================
# 10.2 — Annotation using ChIPseeker
# ================================

cat("Step 10.2: Annotating CpGs...\n")

# Load significant CpGs
sig_cpgs <- read.csv("data/processed/sig_cpgs.csv")

# Convert to GRanges
gr_cpgs <- GRanges(
  seqnames = sig_cpgs$chr,
  ranges   = IRanges(start = sig_cpgs$start,
                     end   = sig_cpgs$end),
  strand   = sig_cpgs$strand
)

# Load annotation database
txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene

# Annotate CpGs
anno <- annotatePeak(
  gr_cpgs,
  TxDb      = txdb,
  tssRegion = c(-2000, 2000),
  annoDb    = "org.Hs.eg.db"
)

anno_df <- as.data.frame(anno)

# Merge annotation with CpG data
annot_df <- sig_cpgs %>%
  bind_cols(
    dplyr::select(anno_df,
                  geneId,
                  SYMBOL,
                  annotation,
                  distanceToTSS)
  )

# Save annotated file
write.csv(annot_df,
          "data/processed/annotated_sig_cpgs.csv",
          row.names = FALSE)

cat("Saved: data/processed/annotated_sig_cpgs.csv\n\n")

# ================================
# 10.3 — Summary statistics
# ================================

cat("Annotation summary:\n")
print(table(annot_df$annotation))

cat("\nUnique genes:", length(unique(annot_df$SYMBOL)), "\n")

cat("\nStep 10 completed.\n")
