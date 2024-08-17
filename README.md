# Custom Nextflow utilities

This repository is a collection of custom Nextflow workflows for various analyses.

## Requirements

- [Nextflow](https://www.nextflow.io/)
- [Docker](https://www.docker.com/)

## Utilities

### [`trnascan.nf`](trnascan.nf)

The [`trnascan.nf`](trnascan.nf) workflow can be used for running tRNAscan-SE and parsing the results. The workflow is designed to identify tRNA genes in a given genome sequence and filter high-confidence predictions. It consists of two main processes:

1. **TRNASCAN**: Runs tRNAscan-SE to identify tRNA genes in the input genome sequence.
2. **PARSE_SS**: Parses the secondary structure output (`.ss`) file from tRNAscan-SE.

#### Usage

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

#### Output

The results will be saved in the specified output directory (`$params.outdir`). The main outputs include:

- tRNAscan results in `$params.outdir/tRNAscan_results`
- Filtered and parsed secondary structure results in `$params.outdir/filtered_tRNAscan_ss_tab`

### [`blastn.nf`](blastn.nf)

The [`blastn.nf`](blastn.nf) workflow is designed to create a BLAST nucleotide database from a given sequence and perform a BLASTN search against it. It consists of two main processes:

1. **CREATE_BLASTN_DB**: Creates a BLAST nucleotide database from the input sequence.
2. **BLASTN**: Performs a BLASTN search using the query sequence against the created BLAST database.

#### Usage

```bash
nextflow run blastn.nf \
    --blast_subject subject.fa \
    --blast_query query.fa \
    --outdir /opt/results
```

If declaring the params in the config file:

```bash
nextflow run blastn.nf
```

#### Output

The results will be saved in the specified output directory (`$params.outdir`). The main outputs include:

- BLAST database files in `$params.outdir/blastdb`
- BLASTN search results in `$params.outdir/blastn_output`

## Configuration

The pipeline is configured using the [`nextflow.config`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fmnt%2Fdata%2FDocuments%2Fnf_custom_utils%2Fnextflow.config%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%5D "/mnt/data/Documents/nf_custom_utils/nextflow.config"). Below are the default parameters and profiles:

```groovy
/*  Default input parameters  */
params {
    genome = "$baseDir/data/genome.fa"
    outdir = "$baseDir/results"
    blast_subject = "$baseDir/data/genes.fa"
    blast_query = "$baseDir/data/sequence.fa"
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
  withName: CREATE_BLASTN_DB {
    container = "ncbi/blast:2.16.0"
  }
  withName: BLASTN {
    container = "ncbi/blast:2.16.0"
  }
}
```

## Components

- [Nextflow](https://www.nextflow.io/)
- [tRNAscan-SE 2.0](http://lowelab.ucsc.edu/tRNAscan-SE/)
- [Docker](https://www.docker.com/)
- [NCBI Blastn](https://github.com/ncbi/blast_plus_docs)