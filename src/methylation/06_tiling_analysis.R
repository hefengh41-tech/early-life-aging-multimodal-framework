# ================================
# STEP 6: TILING + VISUALIZATION
# ================================

library(methylKit)
library(ggplot2)
library(viridis)

# -------------------------------
# Load methylation object
# -------------------------------
meth_united <- readRDS("data/processed/meth_united.rds")

# Create output directory
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)

# ================================
# 6.1 — 1 kb TILING
# ================================

cat("Running 1 kb tiling...\n")

tiles_1kb <- tileMethylCounts(meth_united,
                             win.size = 1000,
                             step.size = 1000)

tiles_diff_1kb <- calculateDiffMeth(tiles_1kb)

saveRDS(tiles_diff_1kb,
        "data/processed/tiles_diff_1kb.rds")

# Prepare dataframe
tiles_df <- as.data.frame(tiles_diff_1kb)
tiles_df$log10q <- -log10(tiles_df$qvalue)
tiles_df$signif <- tiles_df$qvalue < 0.05 & abs(tiles_df$meth.diff) >= 10
tiles_df$pos <- (tiles_df$start + tiles_df$end) / 2
tiles_df$chr <- factor(tiles_df$chr, levels = unique(tiles_df$chr))

# -------------------------------
# Volcano Plot (1 kb)
# -------------------------------
volcano_1kb <- ggplot(tiles_df,
                      aes(x = meth.diff, y = log10q)) +
  geom_point(aes(color = signif), alpha = 0.6, size = 1.2) +
  scale_color_viridis(discrete = TRUE, option = "D") +
  labs(title = "Volcano Plot – 1 kb Tiles",
       x = "Methylation Difference (%)",
       y = expression(-log[10](qvalue))) +
  theme_bw(base_size = 13) +
  theme(legend.position = "top")

ggsave("outputs/figures/volcano_1kb.png",
       volcano_1kb, width = 7, height = 5, dpi = 300)

# -------------------------------
# Manhattan Plot (1 kb)
# -------------------------------
manhattan_1kb <- ggplot(tiles_df,
                        aes(x = pos, y = log10q, color = chr)) +
  geom_point(size = 0.4, alpha = 0.5) +
  facet_wrap(~ chr, scales = "free_x", nrow = 4) +
  scale_color_viridis_d(option = "C") +
  labs(title = "Manhattan Plot – 1 kb Tiles",
       x = "Genomic Position",
       y = expression(-log[10](qvalue))) +
  theme_bw(base_size = 11) +
  theme(legend.position = "none",
        axis.text.x = element_blank())

ggsave("outputs/figures/manhattan_1kb.png",
       manhattan_1kb, width = 12, height = 7, dpi = 300)

# ================================
# 6.2 — 500 bp TILING
# ================================

cat("Running 500 bp tiling...\n")

tiles_500bp <- tileMethylCounts(meth_united,
                               win.size = 500,
                               step.size = 500)

tiles_diff_500bp <- calculateDiffMeth(tiles_500bp)

saveRDS(tiles_diff_500bp,
        "data/processed/tiles_diff_500bp.rds")

# Prepare dataframe
tiles_df_500 <- as.data.frame(tiles_diff_500bp)
tiles_df_500$log10q <- -log10(tiles_df_500$qvalue)
tiles_df_500$signif <- tiles_df_500$qvalue < 0.05 & abs(tiles_df_500$meth.diff) >= 10
tiles_df_500$pos <- (tiles_df_500$start + tiles_df_500$end) / 2
tiles_df_500$chr <- factor(tiles_df_500$chr, levels = unique(tiles_df_500$chr))

# -------------------------------
# Volcano Plot (500 bp)
# -------------------------------
volcano_500 <- ggplot(tiles_df_500,
                      aes(x = meth.diff, y = log10q)) +
  geom_point(aes(color = signif), alpha = 0.65, size = 1.3) +
  scale_color_viridis(discrete = TRUE, option = "D") +
  labs(title = "Volcano Plot – 500 bp Tiles",
       x = "Methylation Difference (%)",
       y = expression(-log[10](qvalue))) +
  theme_bw(base_size = 13) +
  theme(legend.position = "top")

ggsave("outputs/figures/volcano_500bp.png",
       volcano_500, width = 7, height = 5, dpi = 300)

# -------------------------------
# Manhattan Plot (500 bp)
# -------------------------------
manhattan_500 <- ggplot(tiles_df_500,
                        aes(x = pos, y = log10q, color = chr)) +
  geom_point(size = 0.4, alpha = 0.5) +
  facet_wrap(~ chr, scales = "free_x", nrow = 4) +
  scale_color_viridis_d(option = "C") +
  labs(title = "Manhattan Plot – 500 bp Tiles",
       x = "Genomic Position",
       y = expression(-log[10](qvalue))) +
  theme_bw(base_size = 11) +
  theme(legend.position = "none",
        axis.text.x = element_blank())

ggsave("outputs/figures/manhattan_500bp.png",
       manhattan_500, width = 12, height = 7, dpi = 300)

cat("Tiling + plots completed.\n")
