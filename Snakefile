import os

include: "rules/common.smk"

################################################################################################################

include: "rules/DNAont/basecalling.smk"
include: "rules/DNAont/basecalling_duplex.smk"
include: "rules/DNAont/flye.smk"
include: "rules/DNAont/medaka.smk"
include: "rules/DNAont/racon.smk"

################################################################################################################

include: "rules/DNAseq/genomescope.smk"
include: "rules/DNAseq/merge.smk"
include: "rules/DNAseq/masurca.smk"

################################################################################################################

include: "rules/RNAseq/trimming.smk"
#include: "rules/RNAseq/trinity.smk"
include: "rules/RNAseq/error_correction.smk"
include: "rules/RNAseq/filtering.smk"
include: "rules/RNAseq/rRNA_database.smk"


################################################################################################################

include: "rules/qc/reads.smk"
include: "rules/qc/contiguity.smk"
include: "rules/qc/other.smk"
include: "rules/qc/busco.smk"

################################################################################################################

include: "rules/genome/pilon.smk"
#include: "rules/genome/jasper.smk"
include: "rules/genome/merge_assembly.smk"

################################################################################################################

include: "rules/phylogeny/get_genomes.smk"

################################################################################################################

#include: "rules/ncbi/ncbi_datasets.smk"


rule all:
    input:
        "all_done"

localrules: 
    all, 
    all_done,
    unpack_fastq_dnaseq,
    unpack_fastq_rnaseq,
    samtools_overlaps_pilon_index,
    samtools_overlaps_pilon2_index,
    samtools_overlaps_pilon3_index, 
    samtools_overlaps_pilon4_index,
    find_best_racon,
    find_best_pilon_jasper,
    cleanup_rRNA

rule all_done: 
    input: 
        genomescope=expand("{sample}_DNAseq/{sample}_genomescope_results/summary.txt", sample=SAMPLE),
        
        fastqc_ont=expand("qc/{sample}_ont_basecalled_fastqc.zip", sample=SAMPLE),

        fastqc_dna_short=expand( "qc/{sample}_fastqc_DNAseq", sample=SAMPLE),
             
        fastqc_rna_short=expand("qc/{sample}_fastqc_RNAseq", sample=SAMPLE),
                          
        basecalled=expand("{sample}_DNAont/{sample}_ont_basecalled.fastq", sample=SAMPLE),
       
    #	duplex_main_pairing=expand("{sample}_DNAont/{sample}_duplex_main_pairing.fastq", sample=SAMPLE),
       
    #	duplex_other_pairing=expand("{sample}_DNAont/{sample}_duplex_splitduplex.fastq", sample=SAMPLE),
       
        ont_qc=expand("qc/{sample}_ont_qc", sample=SAMPLE),
       
        basecalled_qc=expand("qc/{sample}_ont_basecalled_fastqc.zip", sample=SAMPLE),
       
        quast=expand("qc/{sample}_quast", sample=SAMPLE),
       
        busco=expand("qc/{sample}_busco", sample=SAMPLE),
              
        busco_masurca=expand("qc/{sample}_busco_masurca", sample=SAMPLE),
       
	#	masurca_hybrid=expand("{sample}_dnaseq/masurca_hybrid/final.genome.scf.fasta", sample=SAMPLE),
       
    #   busco_masurca_hybrid=expand("qc/{sample}_busco_masurca_hybrid", sample=SAMPLE),
                     
        busco_racon=expand("qc/{sample}_busco_racon", sample=SAMPLE),
        
        busco_racon2=expand("qc/{sample}_busco_racon2", sample=SAMPLE),
        
        busco_medaka=expand("qc/{sample}_busco_medaka", sample=SAMPLE),
                
        busco_pilon=expand("qc/{sample}_busco_pilon", sample=SAMPLE),
        
        busco_pilon2=expand("qc/{sample}_busco_pilon2", sample=SAMPLE),
        
        busco_pilon3=expand("qc/{sample}_busco_pilon3", sample=SAMPLE),
        
    #    busco_pilon4=expand("qc/{sample}_busco_pilon4", sample=SAMPLE),
        
    #   busco_jasper=expand("qc/{sample}_busco_jasper", sample=SAMPLE),
                
        quast_quickmerge=expand("qc/{sample}_quast_quickmerge", sample=SAMPLE),
        
        
        
    # RNA SEQ
    
    #   rnaseq_fastqc=expand("{sample}_RNAseq/trinity/Trinity.fasta", sample=SAMPLE),
        rnaseq_rcorrector=expand("{sample}_RNAseq/{sample}_R1.cor.fq", sample=SAMPLE),
        RNAseq_FilterUncorrectabledPEfastq=expand("{sample}_RNAseq/unfixrm_{sample}_R1.cor.fq", sample=SAMPLE),
        rnaseq_trim=expand("{sample}_RNAseq/{sample}_trimmed/reports/{sample}_R1_trimming_report.txt", sample=SAMPLE),
        fastqc_rna_short_filtered1=expand("qc/{sample}_fastqc_RNAseq_rRNA_filter1", sample=SAMPLE),
        fastqc_rna_short_filtered2=expand("qc/{sample}_fastqc_RNAseq_rRNA_filter2", sample=SAMPLE),


        ncbi1=expand("{sample}_phylogeny", sample=SAMPLE)


    output: 
        "all_done"
    run: 
        shell("touch {output}")


