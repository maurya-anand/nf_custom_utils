# tRNAscan Workflow

This repository contains a Nextflow pipeline for running tRNAscan-SE and parsing the results. The workflow is designed to identify tRNA genes in a given genome sequence and filter high-confidence predictions.

## Requirements

- [Nextflow](https://www.nextflow.io/)
- [Docker](https://www.docker.com/)

## Pipeline Overview

The pipeline consists of two main processes:

1. **TRNASCAN**: Runs tRNAscan-SE to identify tRNA genes in the input genome sequence.
2. **PARSE_SS**: Parses the secondary structure output (`.ss`) file from tRNAscan-SE.

## Configuration

The pipeline is configured using the [`nextflow.config`](nextflow.config). Below are the default parameters and profiles:

```groovy
/*  Default input parameters  */
params {
    genome = "$baseDir/data/genome.fa"
    out_prefix = "smn1"
    outdir = "$baseDir/results"
}
/*  Workflow profiles  */
profiles {
  standard {
    process.executor = "local"
    docker.enabled = true
  }
}
/*  custom process level configuration  */
process {
  withName: TRNASCAN {
    container = "quay.io/biocontainers/trnascan-se:2.0.7--pl526h516909a_0"
  }
  withName: PARSE_SS {
    container = "perl:5.41"
  }
}
```

## Usage

```bash
nextflow run trnascan.nf \
    --genome genome.fa \
    --out_prefix smn1 \
    --outdir /opt/results
```

If declaring the params in the config file:

```bash
nextflow run trnascan.nf
```

## Output

The results will be saved in the specified output directory (`$params.outdir`). The main outputs include:

- tRNAscan results in `$params.outdir/tRNAscan_results`
- Filtered and parsed secondary structure results in `$params.outdir/filtered_tRNAscan_ss_tab`

## Conponents

- [Nextflow](https://www.nextflow.io/)
- [tRNAscan-SE](http://lowelab.ucsc.edu/tRNAscan-SE/)
- [Docker](https://www.docker.com/)
