rule quast: 
    input: 
        "{sample}_ont/flye_assembly/assembly.fasta"
    output: 
        directory("qc/{sample}_quast")
    conda: 
        config["environments"]["quast"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_quast"
    shell: 
        "quast -o {output} {input}"


################################################################################################################################################


rule quast_quickmerge: 
    input: 
         "{sample}_quickmerge.fasta"
    output: 
        directory("qc/{sample}_quast_quickmerge")
    conda: 
        config["environments"]["quast"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_quast_quickmerge"
    shell: 
        "quast -o {output} {input}"
