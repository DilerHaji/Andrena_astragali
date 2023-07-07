rule masurca:
    input:
        DNASEQ_DATA
    output:
        "{sample}_DNAseq/masurca/CA/final.genome.scf.fasta"
    params:
        configs=config["configs"]["masurca"],
        pe_size=500,
        pe_overlap=50
    resources:
        resources=config["highmem_resources"]
    conda:
        config["environments"]["masurca"]
    benchmark:
        "benchmarks/{sample}_masurca"
    shell:
        """

        cd {wildcards.sample}_DNAseq/masurca

        cp {params.configs} masurca_config.txt

        sed -i 's/PE_SIZE/{params.pe_size}/g' masurca_config.txt
        sed -i 's/PE_OVERLAP/{params.pe_overlap}/g' masurca_config.txt

        path1=({input}/*R1*gz)
        path2=({input}/*R2*gz)
        
        sed -i "s|PE_PATH1|$path1|g" masurca_config.txt
        sed -i "s|PE_PATH2|$path2|g" masurca_config.txt

        masurca masurca_config.txt

        ./assemble.sh

        """

rule masurca_hybrid: 
    input:
        dna_seq=DNASEQ_DATA, 
        ont_basecalled="{sample}_DNAont/{sample}_ont_basecalled.fastq"
    output:
        "{sample}_DNAseq/masurca_hybrid/CA/final.genome.scf.fasta"
    params:
        configs=config["configs"]["masurca"],
        pe_size=500,
        pe_overlap=50
    resources:
        resources=config["highmem_resources"]
    conda:
        config["environments"]["masurca"]
    benchmark:
        "benchmarks/{sample}_masurca_hybrid"
    shell:
        """

        cd {wildcards.sample}_DNAseq/masurca_hybrid

        cp {params.configs} masurca_config.txt

        sed -i 's/PE_SIZE/{params.pe_size}/g' masurca_config.txt
        sed -i 's/PE_OVERLAP/{params.pe_overlap}/g' masurca_config.txt

        path1=({input.dna_seq}/*R1*gz)
        path2=({input.dna_seq}/*R2*gz)
        ont="NANOPORE=$(realpath ../../{input.ont_basecalled})"

        sed -i "s|PE_PATH1|$path1|g" masurca_config.txt
        sed -i "s|PE_PATH2|$path2|g" masurca_config.txt
        sed -i "s|#NANOPORE=ONT_PATH|$ont|g" masurca_config.txt

        masurca masurca_config.txt

        ./assemble.sh

        """