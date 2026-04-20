import os
import urllib.request
import gzip
import shutil

def download_ctd():
    os.makedirs("data/raw", exist_ok=True)

    url = "https://ctdbase.org/reports/CTD_genes_diseases.tsv.gz"
    gz_path = "data/raw/CTD_genes_diseases.tsv.gz"
    out_path = "data/raw/CTD_genes_diseases.tsv"

    urllib.request.urlretrieve(url, gz_path)

    with gzip.open(gz_path, 'rb') as f_in:
        with open(out_path, 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)

    print("CTD downloaded and extracted")

if __name__ == "__main__":
    download_ctd()
