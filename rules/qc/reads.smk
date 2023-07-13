rule minionqc: 
    input: 
        ONT_DIR
    output:
        directory("qc/{sample}_ont_qc") 
    conda:
        config["environments"]["r-base"]
    params: 
        minionqc=config["scripts"]["minionqc"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_minionqc"
    shell: 
        """
        
        Rscript {params.minionqc} -i {input} -o {output} -s TRUE -p 4

        """
        
################################################################################################################################################

rule fastqc_basecalled:
    input: 
        "{sample}_DNAont/{sample}_ont_basecalled.fastq"
    output: 
        "qc/{sample}_ont_basecalled_fastqc.zip"
    conda: 
        config["environments"]["fastqc"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_fastqc_basecalled"
    shell: 
        """
        
        module load java
        fastqc -o qc {input}

        """

rule fastqc_dna_short:
    input: 
        forward_unpacked="{sample}_DNAseq/{sample}_R1.fastq",
        reverse_unpacked="{sample}_DNAseq/{sample}_R2.fastq"
    output: 
        directory("qc/{sample}_fastqc_DNAseq")
    conda: 
        config["environments"]["fastqc"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_fastqc_dna_short"
    shell: 
        """
        
        module load java
        fastqc -o {output} {input}

        """


rule fastqc_rna_short:
    input: 
        forward_unpacked="{sample}_RNAseq/{sample}_R1.fastq",
        reverse_unpacked="{sample}_RNAseq/{sample}_R2.fastq"
    output: 
        directory("qc/{sample}_fastqc_RNAseq")
    conda: 
        config["environments"]["fastqc"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_fastqc_rna_short"
    shell: 
        """
        
        module load java
        fastqc -o {output} {input}

        """

rule fastqc_rna_short_filtered1:
    input: 
        "{sample}_RNAseq/{sample}_filtering/{sample}_rRNA_unconcordant.fq.1.gz"
    output: 
        directory("qc/{sample}_fastqc_RNAseq_rRNA_filter1/")
    conda: 
        config["environments"]["fastqc"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_fastqc_RNAseq_rRNA_filter"
    shell: 
        """
        
        module load java
        fastqc -o {output} {input}

        """

rule fastqc_rna_short_filtered2:
    input: 
        "{sample}_RNAseq/{sample}_filtering/{sample}_rRNA_unconcordant.fq.2.gz"
    output: 
        directory("qc/{sample}_fastqc_RNAseq_rRNA_filter2/")
    conda: 
        config["environments"]["fastqc"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_fastqc_RNAseq_rRNA_filter"
    shell: 
        """
        
        module load java
        fastqc -o {output} {input}

        """