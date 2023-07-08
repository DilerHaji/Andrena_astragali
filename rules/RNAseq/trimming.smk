rule trim_galore: 
    input: 
    	RNASEQ_DATA
    output: 
    	forward_paired="{sample}_R1_P.fq.gz",
    	forward_unpaired="{sample}_R1_UP.fq.gz",
    	reverse_paired="{sample}_R2_P.fq.gz",
    	reverse_unpaired="{sample}_R2_UP.fq.gz"
    params:
    	threads= config["RNAseq"]["trimmomatic"]["threads"],
    	trim_params=config["RNAseq"]["trimmomatic"]["trim_params"]
    conda:
       config["environments"]["trim_galore"]
    benchmark: 
    	"benchmarks/RNAseq/{sample}_trimmomatic"
    shell: 
       """
       
       trim_galore --paired --retain_unpaired --phred33 \
       --output_dir trimmed_reads \
       --length 36 \
       -q 5 \
       --stringency 1 \
       -e 0.1 $1 $2

       """
	