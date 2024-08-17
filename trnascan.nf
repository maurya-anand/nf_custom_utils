process TRNASCAN {
    publishDir "$params.outdir/tRNAscan_results", mode:'copy'

    input:
    path sequence_fa
    val out_name

    output:
    path "*", emit: pred
    path "${out_name}.filtered.ss", emit: filtered_ss

    script:
    """
    tRNAscan-SE -E -o ${out_name} -f ${out_name}.ss --breakdown --detail ${sequence_fa} --log log.${out_name}.txt --stats stats.${out_name}.txt
    EukHighConfidenceFilter -i ${out_name} -s ${out_name}.ss -p ${out_name}.filtered -o .
    """
}

process PARSE_SS {
    publishDir "$params.outdir/filtered_tRNAscan_ss_tab", mode: 'copy'

    input:
    path ss_file
    val out_name

    output:
    path "*", emit: pred
    path "${out_name}.filtered.ss.parsed.tab.txt", emit: ss_tab

    script:
    """
    parse.trnascan.ss.pl ${ss_file} .
    """
}

workflow {
    predictions = TRNASCAN(sequence_fa = params.genome, out_name = params.out_prefix)
    parsed_out = PARSE_SS(ss_file = predictions.filtered_ss, out_name = params.out_prefix)
}
