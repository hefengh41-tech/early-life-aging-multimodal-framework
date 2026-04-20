# ==========================================
# STEP 8.2–8.4 — β MATRIX VISUALIZATION
# ==========================================

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import os

# Create output folder
os.makedirs("outputs/figures", exist_ok=True)

# -------------------------------
# Load β matrix
# -------------------------------
beta_df = pd.read_csv("data/processed/beta_matrix.csv")

print("β matrix shape:", beta_df.shape)

if "CpG" not in beta_df.columns:
    raise ValueError("CpG column missing!")

# -------------------------------
# 8.2 — Basic QC checks
# -------------------------------
sample_cols = beta_df.columns.drop("CpG")

na_count = beta_df.isna().sum().sum()
inf_count = ((beta_df == float("inf")) | (beta_df == float("-inf"))).sum().sum()

numeric_data = beta_df.drop(columns=["CpG"])
zero_var_rows = (numeric_data.nunique(axis=1) == 1).sum()

print("Missing values:", na_count)
print("Infinite values:", inf_count)
print("Zero-variance CpGs:", zero_var_rows)

# -------------------------------
# 8.3 — Violin plot (per sample)
# -------------------------------
beta_long = beta_df.melt(id_vars=["CpG"],
                         var_name="Sample",
                         value_name="Beta")

plt.figure(figsize=(14, 6))
sns.violinplot(x="Sample", y="Beta",
               hue="Sample",
               data=beta_long,
               inner="box",
               palette="Paired",
               dodge=False,
               legend=False)

plt.xticks(rotation=90, fontsize=7)
plt.title("Methylation Distribution per Sample")
plt.xlabel("Sample ID")
plt.ylabel("β-value")
plt.tight_layout()

plt.savefig("outputs/figures/violin_beta_samples.png", dpi=300)
plt.close()

# -------------------------------
# 8.4 — Density plot (group)
# -------------------------------

samples = beta_df.columns.drop("CpG")

# Assumes same structure as original code (first 24 exposed)
groups = ["Exposed"] * 24 + ["Control"] * 24
group_map = dict(zip(samples, groups))

beta_long["Group"] = beta_long["Sample"].map(group_map)

plt.figure(figsize=(8, 6))

sns.kdeplot(data=beta_long,
            x="Beta",
            hue="Group",
            fill=True,
            alpha=0.3,
            linewidth=1.2)

plt.xlim(0, 1)
plt.xlabel("Methylation Level (β)")
plt.ylabel("Density")
plt.title("Global Methylation Density by Group")
plt.tight_layout()

plt.savefig("outputs/figures/density_beta_groups.png", dpi=300)
plt.close()

print("Step 8 completed.")
