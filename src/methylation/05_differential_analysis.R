library(methylKit)

meth_united <- readRDS("data/processed/meth_united.rds")

diff_results <- calculateDiffMeth(meth_united)
saveRDS(diff_results, "data/processed/dmc_results.rds")

sig_cpgs <- getMethylDiff(diff_results, difference=5, qvalue=0.05)
saveRDS(sig_cpgs, "data/processed/sig_cpgs.rds")
