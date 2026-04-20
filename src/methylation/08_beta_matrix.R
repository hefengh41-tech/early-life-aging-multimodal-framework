# ==========================================
# STEP 8.1 — BUILD β MATRIX (CpG-level)
# ==========================================

library(methylKit)

# Load methylation object
meth_united <- readRDS("data/processed/meth_united.rds")

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)

# Extract raw methylation data
dt <- getData(meth_united)

# Sample IDs
samples <- meth_united@sample.ids

# Compute β matrix
beta_matrix <- sapply(seq_along(samples), function(i) {
  dt[[paste0("numCs", i)]] / dt[[paste0("coverage", i)]]
})

colnames(beta_matrix) <- samples

# Add CpG coordinates
rownames(beta_matrix) <- paste0(dt$chr, ":", dt$start)

# Convert to dataframe
beta_df <- as.data.frame(beta_matrix)
beta_df$CpG <- rownames(beta_matrix)

# Reorder columns
beta_df <- beta_df[, c("CpG", samples)]

# Save
write.csv(beta_df,
          "data/processed/beta_matrix.csv",
          row.names = FALSE)

cat("β matrix saved: data/processed/beta_matrix.csv\n")
