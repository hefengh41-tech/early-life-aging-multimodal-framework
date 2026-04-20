# ==========================================
# STEP 7: SAMPLE-LEVEL VISUALIZATION SUITE
# ==========================================

library(methylKit)
library(ggplot2)
library(pheatmap)
library(RColorBrewer)
library(viridis)
library(reshape2)
library(factoextra)

# -------------------------------
# Load data
# -------------------------------
meth_united <- readRDS("data/processed/meth_united.rds")

dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)

# ================================
# 7.1 — Correlation Heatmap
# ================================

cat("Step 7.1: Correlation heatmap...\n")

meth_matrix <- percMethylation(meth_united)
cor_matrix <- cor(meth_matrix, method = "pearson")

heatmap_colors <- colorRampPalette(rev(brewer.pal(11, "RdYlBu")))(100)

png("outputs/figures/heatmap_correlation.png",
    width = 2000, height = 1600, res = 300)

pheatmap(cor_matrix,
         color = heatmap_colors,
         clustering_distance_rows = "euclidean",
         clustering_distance_cols = "euclidean",
         clustering_method = "complete",
         show_rownames = TRUE,
         show_colnames = TRUE,
         fontsize = 8,
         border_color = NA,
         main = "Methylation Correlations")

dev.off()

# ================================
# 7.2 — PCA Plot
# ================================

cat("Step 7.2: PCA...\n")

zero_var <- apply(meth_matrix, 1, function(x) var(x, na.rm = TRUE) == 0)
meth_filtered <- meth_matrix[!zero_var, ]

meth_t <- t(meth_filtered)

pca_res <- prcomp(meth_t, center = TRUE, scale. = TRUE)

sample_ids <- getSampleID(meth_united)
group_labels <- ifelse(grepl("GSM13274[42-65]", sample_ids),
                       "Exposed", "Control")

pca_plot <- fviz_pca_ind(pca_res,
                        geom.ind = "point",
                        col.ind = group_labels,
                        palette = c("#FF5733", "#33C3FF"),
                        addEllipses = TRUE,
                        ellipse.type = "confidence",
                        legend.title = "Group",
                        title = "PCA of Methylation Profiles") +
  theme(plot.title = element_text(hjust = 0.5))

ggsave("outputs/figures/pca_plot.png",
       pca_plot, width = 7, height = 5, dpi = 300)

# ================================
# 7.3 — Boxplot per Sample
# ================================

cat("Step 7.3: Boxplot...\n")

meth_df <- as.data.frame(meth_matrix)
meth_df$CpG <- rownames(meth_df)

long_df <- melt(meth_df,
                id.vars = "CpG",
                variable.name = "Sample",
                value.name = "Methylation")

long_df$Group <- ifelse(grepl("GSM13274[42-65]", long_df$Sample),
                        "Exposed", "Control")

box_plot <- ggplot(long_df,
                   aes(x = Sample, y = Methylation, fill = Group)) +
  geom_boxplot(outlier.size = 0.5, lwd = 0.2, alpha = 0.8) +
  scale_fill_manual(values = c("Control" = "#1f78b4",
                               "Exposed" = "#e31a1c")) +
  labs(title = "Global Methylation Distribution per Sample",
       x = "Sample ID", y = "β-value") +
  theme_bw(base_size = 12) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
        plot.title = element_text(hjust = 0.5),
        legend.position = "top")

ggsave("outputs/figures/boxplot_samples.png",
       box_plot, width = 10, height = 6, dpi = 300)

# ================================
# 7.4 — Violin + Box (Group Means)
# ================================

cat("Step 7.4: Violin plot...\n")

sample_ids <- colnames(meth_df)[-ncol(meth_df)]
group_vec <- ifelse(grepl("GSM13274[42-65]", sample_ids),
                    "Exposed", "Control")

sample_means <- colMeans(meth_df[, sample_ids], na.rm = TRUE)

group_df <- data.frame(Sample = sample_ids,
                       MeanMeth = sample_means,
                       Group = group_vec)

vioplot <- ggplot(group_df,
                  aes(x = Group, y = MeanMeth, fill = Group)) +
  geom_violin(trim = FALSE, scale = "width",
              alpha = 0.6, color = NA) +
  geom_boxplot(width = 0.2,
               outlier.shape = NA,
               fill = "white",
               color = "black") +
  scale_fill_manual(values = c("Control" = "#1f78b4",
                               "Exposed" = "#e31a1c")) +
  labs(title = "Distribution of Mean Methylation by Group",
       y = "Mean β-value", x = NULL) +
  theme_bw(base_size = 14) +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = "none")

ggsave("outputs/figures/violin_group.png",
       vioplot, width = 6, height = 5, dpi = 300)

# ================================
# 7.5 — Heatmap of Significant CpGs
# ================================

cat("Step 7.5: Significant CpG heatmap...\n")

sig_cpgs <- readRDS("data/processed/sig_cpgs.rds")

sig_coords <- with(getData(sig_cpgs),
                   paste0(chr, ":", start, "-", end))

all_coords <- with(getData(meth_united),
                   paste0(chr, ":", start, "-", end))

match_idx <- which(all_coords %in% sig_coords)

if (length(match_idx) >= 5) {

  sub_mat <- meth_matrix[match_idx, ]
  z_mat <- t(scale(t(sub_mat)))

  samp_ids <- colnames(z_mat)
  grp_lbl <- ifelse(grepl("GSM13274[42-65]", samp_ids),
                    "Exposed", "Control")

  ann_col <- data.frame(Group = grp_lbl)
  rownames(ann_col) <- samp_ids

  png("outputs/figures/heatmap_sig_cpgs.png",
      width = 2000, height = 1600, res = 300)

  pheatmap(z_mat,
           annotation_col = ann_col,
           clustering_distance_rows = "euclidean",
           clustering_distance_cols = "euclidean",
           clustering_method = "ward.D2",
           color = colorRampPalette(brewer.pal(9, "RdYlBu"))(100),
           show_rownames = FALSE,
           show_colnames = TRUE,
           main = "Significant CpGs")

  dev.off()

} else {
  cat("Not enough CpGs for heatmap.\n")
}

cat("Step 7 completed.\n")
