library(data.table)
library(methylKit)

samples <- fread("data/processed/sample_sheet.csv")
samples$group <- c(rep(1, 24), rep(0, 24))

read_as_methylRaw <- function(fp, sid) {
  dt <- fread(fp, header = FALSE,
              col.names = c("chr","start","end","meth_unmeth","score","strand"))

  dt$strand[!dt$strand %in% c("+","-")] <- "*"

  parts <- tstrsplit(gsub("'", "", dt$meth_unmeth), "/", fixed = TRUE)
  dt[, numCs := as.integer(parts[[1]])]
  dt[, numTs := as.integer(parts[[2]])]
  dt[, coverage := numCs + numTs]

  dt2 <- dt[, .(chr,start,end,strand,coverage,numCs,numTs)]

  new("methylRaw",
      dt2,
      sample.id=sid,
      assembly="hg19",
      context="CpG",
      resolution="base")
}

raw_list <- list()
for (i in seq_len(nrow(samples))) {
  raw_list[[i]] <- read_as_methylRaw(samples$BED_path[i], samples$Sample_ID[i])
}

meth_list <- new("methylRawList", raw_list, treatment=samples$group)

saveRDS(meth_list, "data/processed/meth_list.rds")
