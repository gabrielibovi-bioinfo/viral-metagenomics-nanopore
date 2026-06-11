# viral-metagenomics-nanopore
> This repository contains a Bash/Colab pipeline for viral metagenomic analysis using Nanopore sequencing data from clinical samples. 

![Platform](https://img.shields.io/badge/platform_-macOS_-blue)
![Platform](https://img.shields.io/badge/platform-Google%20Colab-F9AB00?logo=googlecolab)

---

The workflow includes quality control, read trimming, filtering, taxonomic classification, and interactive visualization.

The analyzed dataset was obtained from the NCBI’s public Sequence Read Archive (SRA), under accession number ERR14817851.

## Workflow Overview

The pipeline performs the following steps:

1. Creation of Conda environments
2. Quality control using NanoPlot
3. Adapter trimming with Porechop
4. Read filtering with NanoFilt
5. Kraken2 viral database setup
6. Taxonomic classification with Kraken2
7. Interactive visualization with Krona

---

## Tools Used

- NanoPlot
- Porechop
- NanoFilt
- Kraken2
- Krona

---

## Requirements

- Linux or macOS
- Conda / Miniconda / Anaconda installed
- Bash shell
