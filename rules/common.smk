configfile: "config.yml"
SAMPLE=config["sample"]
NCBI_GENOMES=config["ncbi_genomes"]

ONT_DATA=os.path.join(config["path_to_data"], "{sample}_nanopore/fast5_all")
ONT_DIR=os.path.join(config["path_to_data"], "{sample}_nanopore/")
DNASEQ_DATA=os.path.join(config["path_to_data"], "{sample}1_DNAseq")
RNASEQ_DATA=os.path.join(config["path_to_data"], "{sample}2_RNAseq")

rule unpack_fastq_dnaseq: 
    input: 
       DNASEQ_DATA
    output: 
       forward_unpacked="{sample}_DNAseq/{sample}_R1.fastq",
       reverse_unpacked="{sample}_DNAseq/{sample}_R2.fastq"
    shell:
       """
       gunzip -c {input}/*R1*gz > {output.forward_unpacked}
       gunzip -c {input}/*R2*gz > {output.reverse_unpacked}
       """

rule unpack_fastq_rnaseq: 
    input: 
       RNASEQ_DATA
    output: 
       forward_unpacked="{sample}_RNAseq/{sample}_R1.fastq",
       reverse_unpacked="{sample}_RNAseq/{sample}_R2.fastq"
    shell:
       """
       gunzip -c {input}/*R1*gz > {output.forward_unpacked}
       gunzip -c {input}/*R2*gz > {output.reverse_unpacked}
       """
