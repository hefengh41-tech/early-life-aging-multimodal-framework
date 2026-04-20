# =====================================================
# STEP 9: CHROMOSOME-LEVEL ANALYSIS + VISUALIZATION
# =====================================================

library(methylKit)
library(dplyr)
library(ggplot2)
library(ggridges)
library(tidyr)
library(patchwork)
library(circlize)

# Create output directories
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)

# -------------------------------
# Load methylation data
# -------------------------------
meth_united <- readRDS("data/processed/meth_united.rds")

# ================================
# 9.1 — CIRcos Plot
# ================================

cat("Step 9.1: Circos plot...\n")

diff_obj <- calculateDiffMeth(meth_united)
diff_df <- getData(diff_obj)

sig_df <- diff_df %>%
  filter(qvalue < 0.05, abs(meth.diff) >= 10)

beta_mat <- percMethylation(meth_united)
treat <- meth_united@treatment

coords <- getData(meth_united)[, c("chr", "start")]
full_df <- cbind(coords, as.data.frame(beta_mat))

ctrl_idx <- which(treat == 0) + 2
exp_idx  <- which(treat == 1) + 2

chr_list <- unique(full_df$chr)

chr_summary <- bind_rows(lapply(chr_list, function(ch) {
  sub <- full_df[full_df$chr == ch, ]

  avg_c <- mean(rowMeans(sub[, ctrl_idx], na.rm = TRUE))
  avg_e <- mean(rowMeans(sub[, exp_idx], na.rm = TRUE))
  d_beta <- avg_e - avg_c

  sum_q <- sum(-log10(sig_df$qvalue[sig_df$chr == ch]), na.rm = TRUE)

  tibble(chr = ch,
         avg_ctrl = avg_c,
         avg_exp = avg_e,
         delta = d_beta,
         sum_logq = sum_q)
}))

jpeg("outputs/figures/circos_plot.jpeg",
     width = 3000, height = 3000, res = 300)

circos.clear()
circos.par(start.degree = 270, gap.degree = 2)
circos.initialize(factors = chr_summary$chr,
                  xlim = cbind(rep(0, nrow(chr_summary)), rep(1, nrow(chr_summary))))

# Inner track (avg β)
circos.trackPlotRegion(ylim = c(0, 1), track.height = 0.2,
  panel.fun = function(x, y) {
    ch <- CELL_META$sector.index
    summ <- chr_summary[chr_summary$chr == ch, ]

    circos.rect(0, 0, 1, summ$avg_ctrl, col = "#56B4E9", border = NA)
    circos.rect(0, summ$avg_ctrl, 1, summ$avg_ctrl + summ$avg_exp,
                col = "#E69F00", border = NA)
})

# Middle track (Δβ)
max_d <- max(abs(chr_summary$delta))
col_fun <- colorRamp2(c(-max_d, 0, max_d), c("blue", "white", "red"))

circos.trackPlotRegion(ylim = c(0, 1), track.height = 0.1,
  panel.fun = function(x, y) {
    ch <- CELL_META$sector.index
    summ <- chr_summary[chr_summary$chr == ch, ]
    circos.rect(0, 0, 1, 1, col = col_fun(summ$delta), border = NA)
})

# Outer track (q-values)
max_q <- max(chr_summary$sum_logq)

circos.trackPlotRegion(ylim = c(0, 1), track.height = 0.05,
  panel.fun = function(x, y) {
    ch <- CELL_META$sector.index
    summ <- chr_summary[chr_summary$chr == ch, ]

    h <- summ$sum_logq / max_q
    circos.rect(0.4, 0, 0.6, h, col = "gray40", border = NA)
})

dev.off()
circos.clear()

# ================================
# 9.2 — Ridge + Bar Plot
# ================================

cat("Step 9.2: Ridge + bar plots...\n")

beta_df <- cbind(coords, as.data.frame(beta_mat))

sample_cols <- setdiff(colnames(beta_df), c("chr", "start"))

beta_long <- pivot_longer(beta_df,
                          cols = all_of(sample_cols),
                          names_to = "Sample",
                          values_to = "Beta")

beta_long$Group <- rep(ifelse(treat == 0, "Control", "Exposed"),
                       each = nrow(coords))

beta_long$chr <- factor(beta_long$chr, levels = paste0("chr", 1:22))
beta_long <- beta_long %>% filter(!is.na(chr))

# Ridge plot
ridge_plot <- ggplot(beta_long,
                     aes(x = Beta, y = chr, fill = Group)) +
  geom_density_ridges(alpha = 0.6, scale = 1.2) +
  scale_fill_manual(values = c("Control" = "#56B4E9",
                               "Exposed" = "#E69F00")) +
  theme_minimal() +
  labs(title = "β Distribution by Chromosome")

# Bar plot
mean_beta <- beta_long %>%
  group_by(chr, Group) %>%
  summarise(mean_beta = mean(Beta, na.rm = TRUE), .groups = "drop")

bar_plot <- ggplot(mean_beta,
                   aes(x = chr, y = mean_beta, fill = Group)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("Control" = "#56B4E9",
                               "Exposed" = "#E69F00")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90))

combo_plot <- ridge_plot / bar_plot

ggsave("outputs/figures/ridge_bar_plot.png",
       combo_plot, width = 12, height = 10, dpi = 300)

# ================================
# 9.3 — Heatmap + Volcano Insets
# ================================

cat("Step 9.3: Heatmap + volcano...\n")

# Heatmap prep
chr_beta <- beta_long %>%
  group_by(chr, Sample) %>%
  summarise(mean_beta = mean(Beta, na.rm = TRUE), .groups = "drop")

heatmap_data <- chr_beta %>%
  pivot_wider(names_from = chr, values_from = mean_beta)

heatmap_mtx <- as.matrix(heatmap_data[,-1])
rownames(heatmap_mtx) <- heatmap_data$Sample

heat_df <- as.data.frame(as.table(heatmap_mtx))
colnames(heat_df) <- c("Sample", "Chromosome", "Beta")

heatmap_plot <- ggplot(heat_df,
                       aes(x = Chromosome, y = Sample, fill = Beta)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Volcano per chromosome
diff_df$logq <- -log10(diff_df$qvalue)

volcano_list <- lapply(unique(diff_df$chr), function(chr_name) {
  sub <- diff_df %>% filter(chr == chr_name)

  ggplot(sub, aes(x = meth.diff, y = logq)) +
    geom_point(alpha = 0.3, size = 0.4) +
    theme_void() +
    ggtitle(chr_name)
})

volcano_grid <- wrap_plots(volcano_list, ncol = 6)

combo2 <- heatmap_plot / volcano_grid

ggsave("outputs/figures/heatmap_volcano_combo.png",
       combo2, width = 16, height = 12, dpi = 300)

cat("Step 9 completed.\n")
