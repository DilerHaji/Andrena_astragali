rule masurca:
    input:
       forward_unpacked="{sample}_DNAseq/{sample}_R1.fastq",
       reverse_unpacked="{sample}_DNAseq/{sample}_R2.fastq"
    output:
        "{sample}_DNAseq/{sample}_masurca/CA/final.genome.scf.fasta"
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
		
		if [ ! -d {wildcards.sample}_DNAseq/{wildcards.sample}_masurca ]; then
        	mkdir -p {wildcards.sample}_DNAseq/{wildcards.sample}_masurca;
        fi
		
        cd {wildcards.sample}_DNAseq/{wildcards.sample}_masurca

        cp {params.configs} masurca_config.txt

        sed -i 's/PE_SIZE/{params.pe_size}/g' masurca_config.txt
        sed -i 's/PE_OVERLAP/{params.pe_overlap}/g' masurca_config.txt

        path1=({input.forward_unpacked})
        path2=({input.reverse_unpacked})
        
        sed -i "s|PE_PATH1|$path1|g" masurca_config.txt
        sed -i "s|PE_PATH2|$path2|g" masurca_config.txt

        masurca masurca_config.txt

        ./assemble.sh

        """

rule masurca_hybrid: 
    input:
        forward_unpacked="{sample}_DNAseq/{sample}_R1.fastq",
        reverse_unpacked="{sample}_DNAseq/{sample}_R2.fastq",
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

		if [ ! -d {wildcards.sample}_DNAseq/{wildcards.sample}_masurca_hybrid ]; then
        	mkdir -p {wildcards.sample}_DNAseq/{wildcards.sample}_masurca_hybrids;
        fi

        cd {wildcards.sample}_DNAseq/{wildcards.sample}_masurca_hybrid

        cp {params.configs} masurca_config.txt

        sed -i 's/PE_SIZE/{params.pe_size}/g' masurca_config.txt
        sed -i 's/PE_OVERLAP/{params.pe_overlap}/g' masurca_config.txt

        path1=({input.forward_unpacked})
        path2=({input.reverse_unpacked})
        ont="NANOPORE=$(realpath ../../{input.ont_basecalled})"

        sed -i "s|PE_PATH1|$path1|g" masurca_config.txt
        sed -i "s|PE_PATH2|$path2|g" masurca_config.txt
        sed -i "s|#NANOPORE=ONT_PATH|$ont|g" masurca_config.txt

        masurca masurca_config.txt

        ./assemble.sh

        """