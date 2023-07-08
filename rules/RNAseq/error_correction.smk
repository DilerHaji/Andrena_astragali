rule RNAseq_rcorrector: 
    input: 
       forward_unpacked="{sample}_RNAseq/{sample}_R1.fastq",
       reverse_unpacked="{sample}_RNAseq/{sample}_R2.fastq"
    output: 
       forward_corrected="{sample}_RNAseq/{sample}_R1.cor.fq",
       reverse_corrected="{sample}_RNAseq/{sample}_R2.cor.fq"
    params:
       threads= config["RNAseq"]["rcorrector"]["threads"],
       rcorrector=config["programs"]["rcorrector"]
    conda:
       config["environments"]["rcorrector"]
    resources:
        resources=config["default_resources_10thread"]
    benchmark: 
       "benchmarks/RNAseq/{sample}_rcorrector"
    shell: 
       """
       perl {params.rcorrector} -t {params.threads} -p {input.forward_unpacked} {input.reverse_unpacked} -od {wildcards.sample}_RNAseq
       
       """

rule RNAseq_FilterUncorrectabledPEfastq:
    input: 
       forward_corrected="{sample}_RNAseq/{sample}_R1.cor.fq",
       reverse_corrected="{sample}_RNAseq/{sample}_R2.cor.fq"
    output: 
       forward_corrected="{sample}_RNAseq/unfixrm_{sample}_R1.cor.fq",
       reverse_corrected="{sample}_RNAseq/unfixrm_{sample}_R2.cor.fq"
    conda:
       config["environments"]["python2.7.8"]
    params: 
    	FilterUncorrectabledPEfastq=config["scripts"]["FilterUncorrectabledPEfastq"]
    resources:
        resources=config["default_resources"]    
    benchmark: 
       "benchmarks/RNAseq/{sample}_RNAseq_FilterUncorrectabledPEfastq"
    shell: 
       """
 
       python FilterUncorrectabledPEfastq -1 {input.forward_corrected} -2 {input.reverse_corrected} -s {wildcards.sample}       
      
       """
