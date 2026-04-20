library(methylKit)

meth_list <- readRDS("data/processed/meth_list.rds")

meth_filtered <- filterByCoverage(meth_list, lo.count=10, hi.perc=99.9)
meth_united <- unite(meth_filtered)

saveRDS(meth_united, "data/processed/meth_united.rds")
