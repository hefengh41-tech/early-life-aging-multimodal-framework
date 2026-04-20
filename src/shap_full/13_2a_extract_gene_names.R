# ==========================================
# STEP 13.2α — Extract gene names from RDS
# ==========================================

library(methylKit)

# Load methylation object
meth_united <- readRDS("data/processed/meth_united.rds")

# Extract coordinates
dt <- getData(meth_united)

# Create CpG identifiers
cpg_ids <- paste0(dt$chr, ":", dt$start)

# Save CpG list
write.csv(
  data.frame(CpG = cpg_ids),
  "data/processed/cpg_ids.csv",
  row.names = FALSE
)

cat("Saved CpG IDs.\n")
