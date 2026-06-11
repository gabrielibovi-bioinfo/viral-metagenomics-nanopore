# viral-metagenomics-nanopore

![Platform](https://img.shields.io/badge/platform_-macOS_-blue)
![Platform](https://img.shields.io/badge/platform-Google%20Colab-F9AB00?logo=googlecolab)

This repository contains a Bash pipeline for viral metagenomic analysis using Nanopore sequencing data from clinical samples. The workflow includes quality control, read trimming, filtering, taxonomic classification, and interactive visualization.

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
