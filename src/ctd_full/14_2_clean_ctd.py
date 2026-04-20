import pandas as pd

def clean_ctd():
    df = pd.read_csv("data/raw/CTD_genes_diseases.tsv", sep="\t", comment="#")

    df = df.rename(columns={
        "GeneSymbol": "HGNC_Symbol",
        "DiseaseName": "DiseaseName",
        "DirectEvidence": "Evidence",
        "InferenceScore": "InferenceScore"
    })

    df = df.dropna(subset=["HGNC_Symbol", "DiseaseName"])

    df.to_csv("data/processed/ctd_clean.csv", index=False)

    print("CTD cleaned:", df.shape)

if __name__ == "__main__":
    clean_ctd()
