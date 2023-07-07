# https://github.com/broadinstitute/pilon/wiki/Requirements-&-Usage
# https://github.com/flyseq/drosophila_assembly_pipelines/blob/master/assembly/polish_pilon.sh

rule get_overlaps_pilon:
    input:
        assembly="polish/{sample}_medaka.fasta",
        short_fastq=DNASEQ_DATA,
    output:
        "minimap/{sample}_overlaps_for_pilon.bam"
    params:
        threads=config["genome"]["minimap"]["threads"]
    conda:
        config["environments"]["minimap"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_get_overlaps_pilon"
    shell:
        """
        
        minimap2 -ax sr -t {params.threads} {input.assembly} {input.short_fastq}/*R1*gz {input.short_fastq}/*R2*gz > {output}
        
        """

rule samtools_overlaps_pilon: 
    input:
        "minimap/{sample}_overlaps_for_pilon.bam"
    output:
        "minimap/{sample}_overlaps_for_pilon_sorted.bam"
    params:
        threads=config["genome"]["samtools"]["threads"]
    conda:
        config["environments"]["samtools"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_get_overlaps_racon2"
    shell:
        """
        
        samtools sort -o {output} --threads {params.threads} {input}
        
        """

rule samtools_overlaps_pilon_index: 
    input:
        "minimap/{sample}_overlaps_for_pilon_sorted.bam"
    output:
        "minimap/{sample}_overlaps_for_pilon_sorted.bam.bai"
    params:
        threads=config["genome"]["samtools"]["threads"]
    conda:
        config["environments"]["samtools"]
    benchmark:
        "benchmarks/{sample}_get_overlaps_racon2"
    shell:
        """
        
        samtools index {input}
        
        """

rule pilon:
    input:
        assembly="polish/{sample}_medaka.fasta",
        overlaps="minimap/{sample}_overlaps_for_pilon_sorted.bam",
        fai="minimap/{sample}_overlaps_for_pilon_sorted.bam.bai"
    output:
        pilon_folder=directory("polish/{sample}_pilon"),
        pilon="polish/{sample}_pilon.fasta"
    params:
        threads=config["genome"]["pilon"]["threads"]
    conda:
        config["environments"]["pilon"]
    resources:
        resources=config["highmem_resources"]
    benchmark:
        "benchmarks/{sample}_pilon"
    shell:
        """
    
        pilon -Xmx380G --genome {input.assembly} --frags {input.overlaps} --outdir {output.pilon_folder} --threads {params.threads}
        cp {output.pilon_folder}/pilon.fasta {output.pilon}

        """



######################################################################################################################################################################################################################################################################################################################################################
### 2nd round



rule get_overlaps_pilon2:
    input:
        assembly="polish/{sample}_pilon.fasta",
        short_fastq=DNASEQ_DATA,
    output:
        "minimap/{sample}_overlaps_for_pilon2.bam"
    params:
        threads=config["genome"]["minimap"]["threads"]
    conda:
        config["environments"]["minimap"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_get_overlaps_pilon2"
    shell:
        """
        
        minimap2 -ax sr -t {params.threads} {input.assembly} {input.short_fastq}/*R1*gz {input.short_fastq}/*R2*gz > {output}
        
        """

rule samtools_overlaps_pilon2: 
    input:
        "minimap/{sample}_overlaps_for_pilon2.bam"
    output:
        "minimap/{sample}_overlaps_for_pilon2_sorted.bam"
    params:
        threads=config["genome"]["samtools"]["threads"]
    conda:
        config["environments"]["samtools"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_samtools_overlaps_pilon2"
    shell:
        """
        
        samtools sort -o {output} --threads {params.threads} {input}
        
        """

rule samtools_overlaps_pilon2_index: 
    input:
        "minimap/{sample}_overlaps_for_pilon2_sorted.bam"
    output:
        "minimap/{sample}_overlaps_for_pilon2_sorted.bam.bai"
    params:
        threads=config["genome"]["samtools"]["threads"]
    conda:
        config["environments"]["samtools"]
    benchmark:
        "benchmarks/{sample}_samtools_overlaps_pilon2_index"
    shell:
        """
        
        samtools index {input}
        
        """

rule pilon2:
    input:
        assembly="polish/{sample}_pilon.fasta",
        overlaps="minimap/{sample}_overlaps_for_pilon2_sorted.bam",
        fai="minimap/{sample}_overlaps_for_pilon2_sorted.bam.bai"
    output:
        pilon_folder=directory("polish/{sample}_pilon2"),
        pilon="polish/{sample}_pilon2.fasta"
    params:
        threads=config["genome"]["pilon"]["threads"]
    conda:
        config["environments"]["pilon"]
    resources:
        resources=config["highmem_resources"]
    benchmark:
        "benchmarks/{sample}_pilon2"
    shell:
        """
    
        pilon -Xmx380G --genome {input.assembly} --frags {input.overlaps} --outdir {output.pilon_folder} --threads {params.threads}
        cp {output.pilon_folder}/pilon.fasta {output.pilon}

        """


######################################################################################################################################################################################################################################################################################################################################################
### 3rd round

rule get_overlaps_pilon3:
    input:
        assembly="polish/{sample}_pilon2.fasta",
        short_fastq=DNASEQ_DATA,
    output:
        "minimap/{sample}_overlaps_for_pilon3.bam"
    params:
        threads=config["genome"]["minimap"]["threads"]
    conda:
        config["environments"]["minimap"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_get_overlaps_pilon3"
    shell:
        """
        
        minimap2 -ax sr -t {params.threads} {input.assembly} {input.short_fastq}/*R1*gz {input.short_fastq}/*R2*gz > {output}
        
        """

rule samtools_overlaps_pilon3: 
    input:
        "minimap/{sample}_overlaps_for_pilon3.bam"
    output:
        "minimap/{sample}_overlaps_for_pilon3_sorted.bam"
    params:
        threads=config["genome"]["samtools"]["threads"]
    conda:
        config["environments"]["samtools"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_samtools_overlaps_pilon3"
    shell:
        """
        
        samtools sort -o {output} --threads {params.threads} {input}
        
        """

rule samtools_overlaps_pilon3_index: 
    input:
        "minimap/{sample}_overlaps_for_pilon3_sorted.bam"
    output:
        "minimap/{sample}_overlaps_for_pilon3_sorted.bam.bai"
    params:
        threads=config["genome"]["samtools"]["threads"]
    conda:
        config["environments"]["samtools"]
    benchmark:
        "benchmarks/{sample}_samtools_overlaps_pilon3_index"
    shell:
        """
        
        samtools index {input}
        
        """

rule pilon3:
    input:
        assembly="polish/{sample}_pilon2.fasta",
        overlaps="minimap/{sample}_overlaps_for_pilon3_sorted.bam",
        fai="minimap/{sample}_overlaps_for_pilon3_sorted.bam.bai"
    output:
        pilon_folder=directory("polish/{sample}_pilon3"),
        pilon="polish/{sample}_pilon3.fasta"
    params:
        threads=config["genome"]["pilon"]["threads"]
    conda:
        config["environments"]["pilon"]
    resources:
        resources=config["highmem_resources"]
    benchmark:
        "benchmarks/{sample}_pilon3"
    shell:
        """
    
        pilon -Xmx380G --genome {input.assembly} --frags {input.overlaps} --outdir {output.pilon_folder} --threads {params.threads}
        cp {output.pilon_folder}/pilon.fasta {output.pilon}

        """

######################################################################################################################################################################################################################################################################################################################################################
### 4rd round

rule get_overlaps_pilon4:
    input:
        assembly="polish/{sample}_pilon3.fasta",
        short_fastq=DNASEQ_DATA,
    output:
        "minimap/{sample}_overlaps_for_pilon4.bam"
    params:
        threads=config["genome"]["minimap"]["threads"]
    conda:
        config["environments"]["minimap"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_get_overlaps4_pilon"
    shell:
        """
        
        minimap2 -ax sr -t {params.threads} {input.assembly} {input.short_fastq}/*R1*gz {input.short_fastq}/*R2*gz > {output}
        
        """

rule samtools_overlaps4_pilon: 
    input:
        "minimap/{sample}_overlaps_for_pilon4.bam"
    output:
        "minimap/{sample}_overlaps_for_pilon4_sorted.bam"
    params:
        threads=config["genome"]["samtools"]["threads"]
    conda:
        config["environments"]["samtools"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_samtools_overlaps4_pilon"
    shell:
        """
        
        samtools sort -o {output} --threads {params.threads} {input}
        
        """

rule samtools_overlaps_pilon4_index: 
    input:
        "minimap/{sample}_overlaps_for_pilon4_sorted.bam"
    output:
        "minimap/{sample}_overlaps_for_pilon4_sorted.bam.bai"
    params:
        threads=config["genome"]["samtools"]["threads"]
    conda:
        config["environments"]["samtools"]
    benchmark:
        "benchmarks/{sample}_samtools_overlaps_pilon4_index"
    shell:
        """
        
        samtools index {input}
        
        """

rule pilon4:
    input:
        assembly="polish/{sample}_pilon3.fasta",
        overlaps="minimap/{sample}_overlaps_for_pilon4_sorted.bam",
        fai="minimap/{sample}_overlaps_for_pilon4_sorted.bam.bai"
    output:
        pilon_folder=directory("polish/{sample}_pilon4"),
        pilon="polish/{sample}_pilon4.fasta"
    params:
        threads=config["genome"]["pilon"]["threads"]
    conda:
        config["environments"]["pilon"]
    resources:
        resources=config["highmem_resources"]
    benchmark:
        "benchmarks/{sample}_pilon4"
    shell:
        """
    
        pilon -Xmx380G --genome {input.assembly} --frags {input.overlaps} --outdir {output.pilon_folder} --threads {params.threads}
        cp {output.pilon_folder}/pilon.fasta {output.pilon}

        """