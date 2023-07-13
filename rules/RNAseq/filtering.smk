rule filter_rRNA: 
    input: 
        idx=multiext(
            "rRNA_database/rRNA_DNA_database_rmdup2",
            ".1.bt2l",
            ".2.bt2l",
            ".3.bt2l",
            ".4.bt2l",
            ".rev.1.bt2l",
            ".rev.2.bt2l"
        ), 
        forward_reads="{sample}_RNAseq/{sample}_trimmed/{sample}_R1.fq.gz", 
        reverse_reads="{sample}_RNAseq/{sample}_trimmed/{sample}_R2.fq.gz", 
    output:
        bam="{sample}_RNAseq/{sample}_filtering/{sample}_rRNA.bam", 
        unconcordant1="{sample}_RNAseq/{sample}_filtering/{sample}_rRNA_unconcordant.fq.1.gz",
        unconcordant2="{sample}_RNAseq/{sample}_filtering/{sample}_rRNA_unconcordant.fq.2.gz",
        concordant1="{sample}_RNAseq/{sample}_filtering/{sample}_rRNA_concordant.fq.1.gz",
        concordant2="{sample}_RNAseq/{sample}_filtering/{sample}_rRNA_concordant.fq.2.gz"
    params: 
        extra=config["RNAseq"]["filtering"]["bowtie2"]["extra"],
        threads=config["RNAseq"]["filtering"]["bowtie2"]["threads"],
        #idx="{sample}_RNAseq/{sample}_filtering/{sample}_rRNA.bam.bai",
        metrics="{sample}_RNAseq/{sample}_filtering/{sample}_rRNA_metrics.txt",
        unaligned="{sample}_RNAseq/{sample}_filtering/{sample}_rRNA_unaligned.fq.gz",
        unpaired="{sample}_RNAseq/{sample}_filtering/{sample}_rRNA_unpaired.fq.gz",
        unconcordant="{sample}_RNAseq/{sample}_filtering/{sample}_rRNA_unconcordant.fq.gz",
        concordant="{sample}_RNAseq/{sample}_filtering/{sample}_rRNA_concordant.fq.gz"
    benchmark: 
        "benchmarks/RNAseq/{sample}_filtering/{sample}_bowtie2.txt"
    conda: 
    	config["environments"]["bowtie2"]
    threads: 
        config["RNAseq"]["filtering"]["bowtie2"]["threads"]
    resources:
        resources=config["default_resources_24thread"]  
    log: 
        "logs/RNAseq/{sample}_filtering/{sample}_bowtie2/{sample}.log"
    shell: 
    	"""
        bowtie2 {params.extra}  \
        -x rRNA_database/rRNA_DNA_database_rmdup2 \
        -1 {input.forward_reads} \
        -2 {input.reverse_reads} \
        --threads {params.threads} \
        --met-file {params.metrics} \
        --al-conc-gz {params.concordant} \
        --un-conc-gz {params.unconcordant} \
        --al-gz {params.unpaired} \
        --un-gz {params.unaligned} > {output.bam}
    	""" 
    	

