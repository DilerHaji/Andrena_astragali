rule genomescope:
    input:
       forward_unpacked=os.path.join(DNASEQ_DATA, "{sample}_R1.fastq"),
       reverse_unpacked=os.path.join(DNASEQ_DATA, "{sample}_R2.fastq")
    output:
       summary="{sample}_DNAseq/{sample}_genomescope_results/summary.txt",
       count_jf="{sample}_DNAseq/{sample}_genomescope_results/{sample}_count.jf",
       hist="{sample}_DNAseq/{sample}_genomescope_results/{sample}.histo"
    params: 
       threads=20,
       memory="50G",
       kmer_size=21,
       read_length=150
    resources:
       resources=config["default_resources"]
    conda:
       config["environments"]["jellyfish"]
    benchmark:
       "benchmarks/{sample}_genomescope"
    shell:
       """
       
       jellyfish count -C -m {params.kmer_size} -s {params.memory} -t {params.threads} {input.forward_unpacked} {input.reverse_unpacked} -o {output.count_jf}
       jellyfish histo -t {params.threads} {output.count_jf} > {output.hist}
       
       Rscript /global/scratch/users/diler/scripts/genomescope.R {output.hist} {params.kmer_size} {params.read_length} {wildcards.sample}_DNAseq/{wildcards.sample}_genomescope_results

       """