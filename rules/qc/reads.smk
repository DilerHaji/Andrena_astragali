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
        "{sample}_ont/{sample}_ont_basecalled.fastq"
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
        fastqc -t 150 -o qc {input}

        """

rule fastqc_rna_short:
    input: 
        forward_unpacked=os.path.join(RNASEQ_DATA, "{sample}_R1.fastq"),
        reverse_unpacked=os.path.join(RNASEQ_DATA, "{sample}_R2.fastq")
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
        fastqc -t 150 -o qc {input}

        """



	
