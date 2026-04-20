# =====================================================
# STEP 11: FUNCTIONAL ENRICHMENT + VISUALIZATION
# =====================================================

suppressPackageStartupMessages({
  library(enrichR)
  library(readr)
  library(dplyr)
  library(stringr)
  library(tidyr)
  library(igraph)
  library(ggraph)
  library(ggplot2)
  library(RColorBrewer)
})

# Create output folders
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)

# ================================
# 11.1 — Gene list extraction
# ================================

cat("Step 11.1: Extracting gene list...\n")

annot_file <- "data/processed/annotated_sig_cpgs.csv"
annot_df <- read.csv(annot_file, stringsAsFactors = FALSE)

gene_list <- unique(na.omit(annot_df$SYMBOL))
gene_list <- gene_list[gene_list != ""]

write.csv(gene_list,
          "data/processed/gene_list.csv",
          row.names = FALSE)

cat("Genes:", length(gene_list), "\n")

# ================================
# 11.2 — enrichR (Aging database)
# ================================

cat("Step 11.2: Running enrichment...\n")

dbs <- c("Aging_Perturbations_from_GEO_up")

enrich_out <- enrichr(gene_list, dbs)

aging_df <- enrich_out[[dbs[1]]]

write.csv(aging_df,
          "data/processed/enrichment_aging.csv",
          row.names = FALSE)

cat("Enrichment results saved.\n")

# ================================
# 11.3 — Bar plot (Top terms)
# ================================

cat("Step 11.3: Bar plot...\n")

top10 <- aging_df %>%
  arrange(Adjusted.P.value) %>%
  slice_head(n = min(10, nrow(aging_df))) %>%
  mutate(
    Term = factor(Term, levels = rev(unique(Term))),
    log10q = -log10(Adjusted.P.value)
  )

bar_cols <- brewer.pal(min(10, nrow(top10)), "Set3")

bar_plot <- ggplot(top10,
                   aes(x = log10q, y = Term, fill = Term)) +
  geom_col(width = 0.7) +
  scale_fill_manual(values = bar_cols, guide = "none") +
  labs(
    x = expression(-log[10]~"(adj. p-value)"),
    y = NULL,
    title = "Aging Enrichment"
  ) +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

ggsave("outputs/figures/enrichment_barplot.png",
       bar_plot, width = 8, height = 6, dpi = 300)

# ================================
# 11.4 — Radial network (Hive plot)
# ================================

cat("Step 11.4: Radial network...\n")

top_df <- aging_df %>%
  arrange(Adjusted.P.value) %>%
  slice_head(n = min(10, nrow(aging_df)))

edges <- top_df %>%
  separate_rows(Genes, sep = ",") %>%
  mutate(Genes = str_trim(Genes)) %>%
  transmute(term = Term, gene = Genes)

nodes <- data.frame(
  name = unique(c(edges$term, edges$gene))
)

nodes$type <- ifelse(nodes$name %in% top_df$Term,
                     "Term", "Gene")

g <- graph_from_data_frame(edges,
                           vertices = nodes,
                           directed = FALSE)

radial_plot <- ggraph(g, layout = "fr") +
  geom_edge_link(color = "gray80", alpha = 0.5) +
  geom_node_point(aes(color = type, size = type)) +
  scale_color_manual(values = c("Term" = "#FF1493",
                                "Gene" = "#06A7FF")) +
  theme_void() +
  ggtitle("Enrichment Network") +
  theme(plot.title = element_text(hjust = 0.5))

ggsave("outputs/figures/enrichment_network.png",
       radial_plot, width = 8, height = 8, dpi = 300)

cat("Step 11 completed.\n")
