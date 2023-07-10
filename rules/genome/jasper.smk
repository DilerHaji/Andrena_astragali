# https://github.com/alguoo314/JASPER

rule jasper:
    input:
        assembly="{sample}_genome/polish/{sample}_pilon.fasta",
        short_fastq=DNASEQ_DATA
    output:
        "{sample}_genome/polish/{sample}_jasper.fasta"
    params:
        threads=config["pilon"]["threads"],
        jasper=config["programs"]["jasper"],
        path_to_jellyfish=config["jasper"]["jellyfish_binding_path"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_pilon"
    shell:
        """
    	
    	export PYTHONPATH={params.path_to_jellyfish} 
        {params.jasper} --reads '{input.short_fastq}/*R1*gz {input.short_fastq}/*R2*gz' -a {input.assembly} -k 25 -t 16 -p 4 1>{output} 2>&1

        """
