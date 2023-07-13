rule get_rRNA_database: 
    output: 
        LSrRNA_database="SILVA_138.1_LSUParc_tax_silva.fasta",
        SSrRNA_database="SILVA_138.1_SSUParc_tax_silva.fasta"
    params:
    	LSrRNA_database=config["RNAseq"]["filtering"]["LSrRNA_database"],
    	SSrRNA_database=config["RNAseq"]["filtering"]["SSrRNA_database"]
    benchmark: 
    	"benchmarks/RNAseq/get_rRNA_database.txt"
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
    	"benchmarks/RNAseq/edit_rRNA_database.txt"
    resources:
        resources=config["default_resources"]
    log:
        "logs/RNAseq/get_rRNA_database.log"
    shell:
        """
        
        cat {input.LSrRNA_database} {input.SSrRNA_database} > rRNA_database.fasta
        awk '/^>/{{print; next}}{{gsub("U","T")}}1' rRNA_database.fasta > {output}
    
        """


rule rmdup_rRNA_database: 
    input: 
        "rRNA_DNA_database.fasta"
    output: 
        rmdup1="rRNA_DNA_database_rmdup1.fasta",
        rmdup2="rRNA_DNA_database_rmdup2.fasta"
    benchmark: 
    	"benchmarks/RNAseq/rmdup_rRNA_database.txt"
    resources:
        resources=config["default_resources"]
    conda: 
       config["environments"]["seqkit"]
    log:
        "logs/RNAseq/get_rRNA_database_seqkit.log"
    shell:
        """
        
        seqkit rmdup -s < {input} > {output.rmdup1}
        seqkit rmdup < {output.rmdup1} > {output.rmdup2}

        """



rule rRNA_index: 
    input:
        ref="rRNA_DNA_database_rmdup2.fasta"
    output:
        multiext(
            "rRNA_DNA_database_rmdup2",
            ".1.bt2l",
            ".2.bt2l",
            ".3.bt2l",
            ".4.bt2l",
            ".rev.1.bt2l",
            ".rev.2.bt2l",
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
        bt2l=multiext(
            "rRNA_DNA_database_rmdup2",
            ".1.bt2l",
            ".2.bt2l",
            ".3.bt2l",
            ".4.bt2l",
            ".rev.1.bt2l",
            ".rev.2.bt2l",
        ),
        rmdup_fasta2="rRNA_DNA_database_rmdup2.fasta",
        rmdup_fasta1="rRNA_DNA_database_rmdup1.fasta",
        database="rRNA_database.fasta",
        silva_ssu="SILVA_138.1_SSUParc_tax_silva.fasta",
        silva_lsu="SILVA_138.1_LSUParc_tax_silva.fasta",
    output: 
        multiext(
            "rRNA_database/rRNA_DNA_database_rmdup2",
            ".1.bt2l",
            ".2.bt2l",
            ".3.bt2l",
            ".4.bt2l",
            ".rev.1.bt2l",
            ".rev.2.bt2l",
        )
    log:
        "logs/RNAseq/cleanup_rRNA.log"
    shell:
        """
        
        if [ ! -d rRNA_database ]; then
        	mkdir -p rRNA_database;
        fi

        
        mv {input.bt2l} rRNA_database
        mv {input.rmdup_fasta2} rRNA_database
        mv {input.rmdup_fasta1} rRNA_database
        mv {input.database} rRNA_database
        mv {input.silva_ssu} rRNA_database
        mv {input.silva_lsu} rRNA_database
        
        """