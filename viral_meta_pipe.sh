#!/bin/bash
set -e

# =========================================================
# Viral Metagenomics Pipeline for Nanopore Sequencing Data
# =========================================================
#
# Description:
# This pipeline performs viral metagenomic analysis from
# Nanopore sequencing reads obtained from clinical samples.
#
# Workflow:
# 1. Create Conda environments
# 2. Raw read quality control
# 3. Adapter trimming and read filtering
# 4. Kraken2 database setup
# 5. Taxonomic classification with Kraken2
# 6. Interactive visualization with Krona
#
# =========================================================

echo "Starting viral metagenomics pipeline..."

# =========================================================
# 1. Create Conda environments
# =========================================================

echo "Creating Conda environments..."

source ~/opt/anaconda3/etc/profile.d/conda.sh
conda create -y -n nanopore_qc -c bioconda -c conda-forge nanoplot porechop nanofilt

conda create -y -n kraken_krona -c bioconda -c conda-forge kraken2 krona

!mamba install -y -c bioconda sra-tools --quiet

# =========================================================
# 2. Create directory structure
# =========================================================

echo "Creating directory structure..."

mkdir -p analysis/{input,fastqc_pretrim,trimmed,fastqc_posttrim,kraken,krona}

# Move FASTQ file to input directory
fasterq-dump ERR14817851
gzip ERR14817851.fastq
mv ERR14817851.fastq.gz analysis/input/

RAW_FASTQ="analysis/input/ERR14817851.fastq.gz"

# =========================================================
# 3. Initial quality control with NanoPlot
# =========================================================

echo "Running initial quality analysis with NanoPlot..."

conda activate nanopore_qc

NanoPlot --fastq "$RAW_FASTQ" -o analysis/fastqc_pretrim -t 5

# =========================================================
# 4. Adapter trimming and read filtering
# =========================================================

echo "Running adapter trimming with Porechop..."

porechop -i "$RAW_FASTQ" --threads 5 \
    -o analysis/trimmed/reads_trimmed.fastq.gz

echo "Running read filtering with NanoFilt..."

zcat analysis/trimmed/reads_trimmed.fastq.gz | \
NanoFilt --quality 10 --length 900 --maxlength 1700 | \
gzip > analysis/trimmed/ERR14817851_filtered.fastq.gz

#Note: zcat or gunzip -c

# =========================================================
# 5. Final quality control with NanoPlot
# =========================================================

echo "Running post-filter quality analysis..."

NanoPlot --fastq analysis/trimmed/ERR14817851_filtered.fastq.gz \
    -o analysis/fastqc_posttrim  -t 5

conda deactivate

# =========================================================
# 6. Kraken2 database setup
# =========================================================

echo "Setting up Kraken2 viral database..."

source ~/opt/anaconda3/etc/profile.d/conda.sh
conda activate kraken_krona

# Update Krona taxonomy
ktUpdateTaxonomy.sh

# Download Kraken2 taxonomy
kraken2-build --download-taxonomy viral --db viral_DB --use-ftp

KRAKEN_DB="viral_DB"

# =========================================================
# 7. Taxonomic classification with Kraken2
# =========================================================

echo "Running taxonomic classification with Kraken2..."

kraken2 \
    --db $KRAKEN_DB \
    --report analysis/kraken/kraken_report.txt \
    analysis/trimmed/ERR14817851_filtered.fastq.gz \
    --gzip \
    --output analysis/kraken/kraken_output.txt \
    --threads 4 \
    --confidence 0.1

# =========================================================
# 8. Interactive visualization with Krona
# =========================================================

echo "Generating interactive Krona visualization..."

cut -f2,3 analysis/kraken/kraken_output.txt > \
analysis/krona/kraken_krona_input.txt

ktImportTaxonomy \
    analysis/krona/kraken_krona_input.txt \
    -o analysis/krona/krona_report.html

conda deactivate

# Fim.
