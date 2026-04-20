
import pandas as pd
import pathlib
import gzip
import itertools

def create_sample_sheet(bed_dir, output_csv):
    bed_dir = pathlib.Path(bed_dir)
    bed_files = sorted(bed_dir.glob("*.bed.gz"))

    samples = pd.DataFrame({
        "Sample_ID": [f.stem.split("_")[0] for f in bed_files],
        "BED_path": [str(f) for f in bed_files]
    })

    samples.to_csv(output_csv, index=False)
    print(f"Sample sheet saved: {output_csv}")
    return samples


def preview_bed_file(bed_dir, n_lines=5):
    example_file = next(pathlib.Path(bed_dir).glob("*.bed.gz"))
    print("Previewing:", example_file)

    with gzip.open(example_file, "rt") as fh:
        for line in itertools.islice(fh, n_lines):
            print(line.strip())
