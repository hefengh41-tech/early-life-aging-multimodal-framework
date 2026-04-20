import os
import urllib.request
import gzip
import shutil

def download_ncbi():
    os.makedirs("data/raw", exist_ok=True)

    url = "https://ftp.ncbi.nlm.nih.gov/gene/DATA/gene_info.gz"
    gz_path = "data/raw/gene_info.gz"
    out_path = "data/raw/gene_info"

    urllib.request.urlretrieve(url, gz_path)

    with gzip.open(gz_path, 'rb') as f_in:
        with open(out_path, 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)

    print("NCBI gene_info downloaded")

if __name__ == "__main__":
    download_ncbi()
