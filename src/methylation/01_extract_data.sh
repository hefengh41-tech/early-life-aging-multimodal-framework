#!/bin/bash

RAW_TAR="data/raw/GSE54983_RAW.tar"
OUT_DIR="data/raw/GSE54983_RAW"

mkdir -p "$OUT_DIR"
tar -xf "$RAW_TAR" -C "$OUT_DIR"

echo "Extraction complete"
ls -1 "$OUT_DIR" | head -n 5
