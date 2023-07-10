rule flye: 
    input: 
        reads="{sample}_DNAont/{sample}_ont_basecalled.fastq",
        genome_size="{sample}_DNAseq/{sample}_genomescope_results/summary.txt"
    output: 
        "{sample}_DNAont/flye_assembly/assembly.fasta"
    params: 
        get_genome_size=config["scripts"]["get_genome_size"],
    conda:
        config["environments"]["flye"]
    resources:
        resources=config["highmem_resources"]
    benchmark:
        "benchmarks/{sample}_flye"
    shell: 
        """
        
        genome_size=$(python {params.get_genome_size} {input.genome_size})

        echo $genome_size > {wildcards.sample}_DNAseq/{wildcards.sample}_genome_size.txt

        flye --nano-raw {input.reads} --out-dir {wildcards.sample}_ont/flye_assembly -g $genome_size --asm-coverage 40

        """

