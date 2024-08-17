process TRNASCAN {
    publishDir "$params.outdir/tRNAscan_results", mode:'copy'

    input:
    path sequence_fa

    output:
    path "*", emit: pred
    path "${sequence_fa.baseName}.filtered.ss", emit: filtered_ss

    script:
    """
    tRNAscan-SE -E -o ${sequence_fa.baseName} -f ${sequence_fa.baseName}.ss --breakdown --detail ${sequence_fa} --log log.${sequence_fa.baseName}.txt --stats stats.${sequence_fa.baseName}.txt
    EukHighConfidenceFilter -i ${sequence_fa.baseName} -s ${sequence_fa.baseName}.ss -p ${sequence_fa.baseName}.filtered -o .
    """
}

process PARSE_SS {
    publishDir "$params.outdir/filtered_tRNAscan_ss_tab", mode: 'copy'

    input:
    path ss_file

    output:
    path "${ss_file.baseName}.parsed.tab.txt", emit: ss_tab

    script:
    """
    parse.trnascan.ss.pl ${ss_file} .
    """
}

workflow {
    predictions = TRNASCAN(sequence_fa = params.genome)
    parsed_out = PARSE_SS(ss_file = predictions.filtered_ss)
}
