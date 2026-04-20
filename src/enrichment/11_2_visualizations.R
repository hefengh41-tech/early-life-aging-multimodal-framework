# =====================================================
# STEP 11.2 — ADVANCED VISUALIZATION SUITE
# Includes:
# ✔ Radial hive plot
# ✔ Publication bar plot
# ✔ Wrapped labels
# ✔ 600 DPI export
# =====================================================

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(stringr)
  library(tidyr)
  library(igraph)
  library(ggraph)
  library(circlize)
  library(ggplot2)
  library(RColorBrewer)
  library(jpeg)
  library(grid)
})

dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)

# -------------------------------
# Load enrichment results
# -------------------------------
enr_df <- read_csv("data/processed/enrichment_aging_up.csv",
                   show_col_types = FALSE)

if (nrow(enr_df) == 0) {
  stop("Enrichment file is empty.")
}

# ================================
# 🔥 RADIAL HIVE PLOT
# ================================

top_df <- enr_df %>%
  arrange(Adjusted.P.value) %>%
  slice_head(n = min(10, nrow(enr_df)))

edges <- top_df %>%
  separate_rows(Genes, sep = ",") %>%
  mutate(Genes = str_trim(Genes)) %>%
  transmute(term = Term, gene = Genes)

nodes <- data.frame(
  name = unique(c(edges$term, edges$gene))
)

nodes$type <- ifelse(nodes$name %in% top_df$Term, "Term", "Gene")

log10q <- -log10(top_df$Adjusted.P.value)

col_fun <- circlize::colorRamp2(range(log10q), c("#FFE733", "#FF1493"))
term_col <- setNames(col_fun(log10q), top_df$Term)

g <- graph_from_data_frame(edges, vertices = nodes, directed = FALSE)

p <- ggraph(g, layout = "hive", axis = "type") +
  geom_edge_hive(color = "grey80", alpha = 0.4, width = 0.4) +
  geom_node_point(aes(color = ifelse(type == "Term", name, "Gene"),
                      size = ifelse(type == "Term", 7, 3))) +
  scale_color_manual(values = c(term_col, Gene = "#06A7FF")) +
  scale_size_identity() +
  theme_void() +
  ggtitle("Aging GEO UP – Top Enriched Terms") +
  theme(plot.title = element_text(hjust = 0.5, size = 22, face = "bold"))

jpeg("outputs/figures/step11_radial_hive.jpeg",
     width = 3000, height = 3000, res = 600, quality = 100)

print(p)
dev.off()

# ================================
# 🔥 BAR PLOT (WRAPPED LABELS)
# ================================

top10 <- enr_df %>%
  arrange(Adjusted.P.value) %>%
  slice_head(n = 10) %>%
  mutate(
    Term = vapply(strsplit(str_trim(Term), " +"),
                  function(x) str_wrap(paste(head(x, 6), collapse = " "), 50),
                  character(1)),
    Term = factor(Term, levels = rev(unique(Term))),
    log10q = -log10(Adjusted.P.value)
  )

bar_cols <- brewer.pal(10, "Set3")

p_bar <- ggplot(top10, aes(x = log10q, y = Term, fill = Term)) +
  geom_col(width = 0.7, color = "white") +
  geom_text(aes(label = sprintf("%.2f", log10q)),
            hjust = -0.2, size = 3.2) +
  scale_fill_manual(values = bar_cols, guide = "none") +
  scale_x_continuous(expand = expansion(mult = c(0, 0.2))) +
  labs(
    x = expression(-log[10]~"(adj. p-value)"),
    y = NULL,
    title = "Aging-UP Enrichment"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    axis.text.y = element_text(face = "bold")
  )

ggsave("outputs/figures/step11_barplot.jpeg",
       p_bar, width = 10, height = 7, dpi = 600)

cat("Step 11 visualizations complete.\n")# =====================================================
# STEP 11.2 — ADVANCED VISUALIZATION SUITE
# Includes:
# ✔ Radial hive plot
# ✔ Publication bar plot
# ✔ Wrapped labels
# ✔ 600 DPI export
# =====================================================

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(stringr)
  library(tidyr)
  library(igraph)
  library(ggraph)
  library(circlize)
  library(ggplot2)
  library(RColorBrewer)
  library(jpeg)
  library(grid)
})

dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)

# -------------------------------
# Load enrichment results
# -------------------------------
enr_df <- read_csv("data/processed/enrichment_aging_up.csv",
                   show_col_types = FALSE)

if (nrow(enr_df) == 0) {
  stop("Enrichment file is empty.")
}

# ================================
# 🔥 RADIAL HIVE PLOT
# ================================

top_df <- enr_df %>%
  arrange(Adjusted.P.value) %>%
  slice_head(n = min(10, nrow(enr_df)))

edges <- top_df %>%
  separate_rows(Genes, sep = ",") %>%
  mutate(Genes = str_trim(Genes)) %>%
  transmute(term = Term, gene = Genes)

nodes <- data.frame(
  name = unique(c(edges$term, edges$gene))
)

nodes$type <- ifelse(nodes$name %in% top_df$Term, "Term", "Gene")

log10q <- -log10(top_df$Adjusted.P.value)

col_fun <- circlize::colorRamp2(range(log10q), c("#FFE733", "#FF1493"))
term_col <- setNames(col_fun(log10q), top_df$Term)

g <- graph_from_data_frame(edges, vertices = nodes, directed = FALSE)

p <- ggraph(g, layout = "hive", axis = "type") +
  geom_edge_hive(color = "grey80", alpha = 0.4, width = 0.4) +
  geom_node_point(aes(color = ifelse(type == "Term", name, "Gene"),
                      size = ifelse(type == "Term", 7, 3))) +
  scale_color_manual(values = c(term_col, Gene = "#06A7FF")) +
  scale_size_identity() +
  theme_void() +
  ggtitle("Aging GEO UP – Top Enriched Terms") +
  theme(plot.title = element_text(hjust = 0.5, size = 22, face = "bold"))

jpeg("outputs/figures/step11_radial_hive.jpeg",
     width = 3000, height = 3000, res = 600, quality = 100)

print(p)
dev.off()

# ================================
# 🔥 BAR PLOT (WRAPPED LABELS)
# ================================

top10 <- enr_df %>%
  arrange(Adjusted.P.value) %>%
  slice_head(n = 10) %>%
  mutate(
    Term = vapply(strsplit(str_trim(Term), " +"),
                  function(x) str_wrap(paste(head(x, 6), collapse = " "), 50),
                  character(1)),
    Term = factor(Term, levels = rev(unique(Term))),
    log10q = -log10(Adjusted.P.value)
  )

bar_cols <- brewer.pal(10, "Set3")

p_bar <- ggplot(top10, aes(x = log10q, y = Term, fill = Term)) +
  geom_col(width = 0.7, color = "white") +
  geom_text(aes(label = sprintf("%.2f", log10q)),
            hjust = -0.2, size = 3.2) +
  scale_fill_manual(values = bar_cols, guide = "none") +
  scale_x_continuous(expand = expansion(mult = c(0, 0.2))) +
  labs(
    x = expression(-log[10]~"(adj. p-value)"),
    y = NULL,
    title = "Aging-UP Enrichment"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    axis.text.y = element_text(face = "bold")
  )

ggsave("outputs/figures/step11_barplot.jpeg",
       p_bar, width = 10, height = 7, dpi = 600)

cat("Step 11 visualizations complete.\n")
