rule trimmomatic: 
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
    benchmark: 
    	"benchmarks/RNAseq/{sample}_trimmomatic"
    shell: 
       """
       
       trimmomatic PE \
       -threads {threads} \
       {input}*R1*fastq \
       {input}*R2*fastq \
       {output.forward_paired} \
       {output.forward_unpaired} \
       {output.reverse_paired} \
       {output.reverse_unpaired} \
       {params.trim_params}
       
       """
	