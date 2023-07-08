rule get_overlaps_racon:
    input:
        assembly_contigs="{sample}_DNAont/flye_assembly/assembly.fasta",
        fastq="{sample}_DNAont/{sample}_ont_basecalled.fastq"
    output:
        "minimap/{sample}_ont_overlaps.sam"
    params:
        threads=config["DNAont"]["minimap"]["threads"]
    conda:
        config["environments"]["minimap"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_get_overlaps_ont"
    shell:
        """
        
        minimap2 -a -t {params.threads} {input.assembly_contigs} {input.fastq} > {output}
        
        """
             
rule racon:
    input:
        assembly_contigs="{sample}_DNAont/flye_assembly/assembly.fasta",
        fastq="{sample}_DNAont/{sample}_ont_basecalled.fastq",
        sam="minimap/{sample}_ont_overlaps.sam"
    output:
        "polish/{sample}_racon.fasta"
    params:
        threads=config["DNAont"]["racon"]["threads"],
        match=config["DNAont"]["racon"]["match"],
        mismatch=config["DNAont"]["racon"]["mismatch"],
        gap=config["DNAont"]["racon"]["gap"],
        window_length=config["DNAont"]["racon"]["window_length"],
        extra=config["DNAont"]["racon"]["extra"]
    conda:
        config["environments"]["racon"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_racon"
    shell:
        """
        
        racon -m {params.match} -x {params.mismatch} -g {params.gap} -w {params.window_length} -t {params.threads} {params.extra} {input.fastq} {input.sam} {input.assembly_contigs} > {output}
        
        """

################################################################################################################################################################

rule get_overlaps_racon2:
    input:
        assembly_contigs="polish/{sample}_racon.fasta",
        fastq="{sample}_DNAont/{sample}_ont_basecalled.fastq"
    output:
        "minimap/{sample}_ont_overlaps2.sam"
    params:
        threads=config["DNAont"]["minimap"]["threads"]
    conda:
        config["environments"]["minimap"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_get_overlaps_racon2"
    shell:
        """
        
        minimap2 -a -t {params.threads} {input.assembly_contigs} {input.fastq} > {output}
        
        """

rule racon2:
    input:
        assembly_contigs="polish/{sample}_racon.fasta",
        fastq="{sample}_DNAont/{sample}_ont_basecalled.fastq",
        sam="minimap/{sample}_ont_overlaps2.sam"
    output:
        "polish/{sample}_racon2.fasta"
    params:
        threads=config["DNAont"]["racon"]["threads"],
        match=config["DNAont"]["racon"]["match"],
        mismatch=config["DNAont"]["racon"]["mismatch"],
        gap=config["DNAont"]["racon"]["gap"],
        window_length=config["DNAont"]["racon"]["window_length"],
        extra=config["DNAont"]["racon"]["extra"]
    conda:
        config["environments"]["racon"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_racon2"
    shell:
        """
       
        racon -m {params.match} -x {params.mismatch} -g {params.gap} -w {params.window_length} -t {params.threads} {params.extra} {input.fastq} {input.sam} {input.assembly_contigs} > {output}
        
        """

################################################################################################################################################################

rule find_best_racon:
    input:
        racon2="polish/{sample}_racon2.fasta",
        racon1="polish/{sample}_racon.fasta", 
        racon2_busco="qc/{sample}_busco_racon2",
        racon1_busco="qc/{sample}_busco_racon"
    output:
        "polish/{sample}_best_racon"
    benchmark:
        "benchmarks/{sample}_find_best_racon"
    shell:
        """
        
        racon1=$(grep 'Complete BUSCOs' {input.racon1_busco}/short_summary.specific*.txt | awk '{{print $1}}')
        racon2=$(grep 'Complete BUSCOs' {input.racon2_busco}/short_summary.specific*.txt | awk '{{print $1}}')
        
        if [racon2 -lt racon1]; then 
        	cp {input.racon1} {output}
        else
        	cp {input.racon2} {output}
        fi
        
    	"""