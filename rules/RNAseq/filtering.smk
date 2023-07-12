rule get_rRNA_database: 
    output: 
        LSrRNA_database="SILVA_138.1_LSUParc_tax_silva.fasta",
        SSrRNA_database="SILVA_138.1_SSUParc_tax_silva.fasta"
    params:
    	LSrRNA_database=config["RNAseq"]["filtering"]["LSrRNA_database"],
    	SSrRNA_database=config["RNAseq"]["filtering"]["SSrRNA_database"]
    benchmark: 
    	"benchmarks/RNAseq/get_rRNA_database"
    resources:
        resources=config["default_resources"]
    log:
        "logs/RNAseq/get_rRNA_database.log"
    shell:
        """
        
        wget {params.LSrRNA_database}
        gunzip {output.LSrRNA_database}
        
        wget {params.SSrRNA_database}
        gunzip {output.SSrRNA_database} 
        
        """

rule edit_rRNA_database: 
    input: 
        LSrRNA_database="SILVA_138.1_LSUParc_tax_silva.fasta",
        SSrRNA_database="SILVA_138.1_SSUParc_tax_silva.fasta"
    output: 
        "rRNA_DNA_database.fasta"
    benchmark: 
    	"benchmarks/RNAseq/get_rRNA_database"
    resources:
        resources=config["default_resources"]
    log:
        "logs/RNAseq/get_rRNA_database.log"
    shell:
        """
        
        cat {input.LSrRNA_database} {input.SSrRNA_database} > rRNA_database.fasta
        awk '/^>/{{print; next}}{{gsub("U","T")}}1' rRNA_database.fasta > {output}
    
        """

rule remove_rRNA_index: 
    input:
    	ref="rRNA_DNA_database.fasta"    	 
    output:
        multiext(
            "rRNA_DNA_database",
            ".1.bt2",
            ".2.bt2",
            ".3.bt2",
            ".4.bt2",
            ".rev.1.bt2",
            ".rev.2.bt2",
        )
    log:
        "logs/RNAseq/rRNA_bowtie2_build/build.log",
    params:
        extra=config["RNAseq"]["filtering"]["bowtie2_build"]["extra"]
    threads: 
        config["RNAseq"]["filtering"]["bowtie2_build"]["threads"]
    resources:
        resources=config["highmem_resources"]  
    wrapper:
        "v2.2.0/bio/bowtie2/build"
	
rule cleanup_rRNA: 
    input: 
        multiext(
            "rRNA_DNA_database",
            ".1.bt2",
            ".2.bt2",
            ".3.bt2",
            ".4.bt2",
            ".rev.1.bt2",
            ".rev.2.bt2",
        )
    output: 
        multiext(
            "rRNA_database/rRNA_DNA_database",
            ".1.bt2",
            ".2.bt2",
            ".3.bt2",
            ".4.bt2",
            ".rev.1.bt2",
            ".rev.2.bt2",
        )
    log:
        "logs/RNAseq/cleanup_rRNA.log"
    shell:
        """
        
        if [ ! -d rRNA_database ]; then
        	mkdir -p rRNA_database;
        fi

        
        mv (input) rRNA_database
    
        """


rule remove_rRNA: 
    input: 
        multiext(
            "rRNA_database/rRNA_DNA_database",
            ".1.bt2",
            ".2.bt2",
            ".3.bt2",
            ".4.bt2",
            ".rev.1.bt2",
            ".rev.2.bt2",
        ),
        sample=["{sample}_RNAseq/{sample}_trimmed/{sample}_R1.fq.gz", "{sample}_RNAseq/{sample}_trimmed/{sample}_R2.fq.gz"],
    output: 
        "{sample}_RNAseq/{sample}_filtering/{sample}_rRNA.bam",
        idx="{sample}_RNAseq/{sample}_filtering/{sample}_rRNA.bam.bai",
        metrics="{sample}_RNAseq/{sample}_filtering/{sample}_rRNA_metrics.txt",
        unconcordant="{sample}_RNAseq/{sample}_filtering/{sample}_rRNA_unconcordant.fq.gz",
        concordant="{sample}_RNAseq/{sample}_filtering/{sample}_rRNA_concordant.fq.gz",
        unaligned="{sample}_RNAseq/{sample}_filtering/{sample}_rRNA_unaligned.fq.gz",
        unpaired="{sample}_RNAseq/{sample}_filtering/{sample}_rRNA_unpaired.fq.gz",
    params: 
        extra=config["RNAseq"]["filtering"]["bowtie2"]["extra"]
    resources:
        resources=config["default_resources"]
    benchmark: 
        "benchmarks/RNAseq/{sample}_filtering/{sample}_bowtie2"
    threads: 
        config["RNAseq"]["filtering"]["bowtie2"]["threads"]
    resources:
        resources=config["default_resources_24thread"]  
    log: 
        "logs/RNAseq/{sample}_filtering/{sample}_bowtie2/{sample}.log"
    wrapper: 
    	"v2.2.0/bio/bowtie2/align" 
    	

