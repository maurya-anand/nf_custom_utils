process CREATE_BLASTN_DB {
    publishDir "$params.outdir/blastdb", mode: 'copy'

    input:
    path dbseq

    output:
    path "blastdb/*", emit: db
    val "${dbseq.baseName}", emit: db_name

    script:
    """
    mkdir -p blastdb
    makeblastdb -in ${dbseq} -dbtype 'nucl' -hash_index -out blastdb/${dbseq.baseName}
    """
}

process BLASTN {
    publishDir "$params.outdir/blastn_output", mode: 'copy'

    input:
    path qseq
    path blastdb_dir
    val db_id

    output:
    path("${qseq.baseName}.blast.results.txt"), emit: blast_out

    script:
    """
    mkdir db_files
    mv ${blastdb_dir} db_files/
    blastn -db db_files/${db_id} \
        -query ${qseq} \
        -out ${qseq.baseName}.blast.results.txt \
        -perc_identity 100 \
        -qcov_hsp_perc 100 \
        -outfmt "6 qseqid qstart qend length nident qlen qseq sseqid sstart send slen sstrand sseq pident bitscore evalue"
    """
}

workflow {
    db_files = CREATE_BLASTN_DB(dbseq = params.blast_subject)
    blast_result = BLASTN(qseq = params.blast_query, blastdb_dir = db_files.db, db_id = db_files.db_name)
}