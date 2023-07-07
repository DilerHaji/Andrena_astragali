rule medaka:
    input:
        racon_assembly_contigs="polish/{sample}_best_racon",
        fastq="{sample}_DNAont/{sample}_ont_basecalled.fastq"
    output:
        "polish/{sample}_medaka.fasta"
    params:
        threads=config["DNAont"]["medaka"]["threads"],
        model=config["DNAont"]["medaka"]["model"]        
    container:
        config["environments"]["medaka"]
    resources:
        resources=config["gpu_resources"]
    benchmark:
        "benchmarks/{sample}_medaka"
    shell:
        """
       
        medaka_consensus -i {input.fastq} -d {input.racon_assembly_contigs} -o polish/ -t {params.threads} -m {params.model}
		cp polish/consensus.fasta {output}
       
        """