rule busco:
    input:
        "{sample}_ont/flye_assembly/assembly.fasta"
    output:
        directory("qc/{sample}_busco")
    params:
        MODE= "genome"
    conda:
        config["environments"]["busco"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_busco"
    shell:
        """

        cd qc
        sample="{output}"
        sample_trimmed=${{sample#qc/}}
        busco -m {params.MODE} -i ../{input} -o ${{sample_trimmed}} --auto-lineage-euk

        """

################################################################################################################################################################

rule busco_masurca: 
    input: 
        "{sample}_dnaseq/masurca/CA/final.genome.scf.fasta"
    output: 
        directory("qc/{sample}_busco_masurca")
    params:
        MODE= "genome"
    conda:
        config["environments"]["busco"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_busco_masurka"
    shell:
        """

        cd qc
        sample="{output}"
        sample_trimmed=${{sample#qc/}}
        busco -m {params.MODE} -i ../{input} -o ${{sample_trimmed}} --auto-lineage-euk

        """
################################################################################################################################################################

rule busco_masurca_hybrid: 
    input: 
        "{sample}_dnaseq/masurca_hybrid/final.genome.scf.fasta"
    output: 
        directory("qc/{sample}_busco_masurca_hybrid")
    params:
        MODE= "genome"
    conda:
        config["environments"]["busco"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_busco_masurka_hybrid"
    shell:
        """

        cd qc
        sample="{output}"
        sample_trimmed=${{sample#qc/}}
        busco -m {params.MODE} -i ../{input} -o ${{sample_trimmed}} --auto-lineage-euk

        """

################################################################################################################################################################

rule busco_racon: 
    input: 
        "polish/{sample}_racon.fasta"
    output: 
        directory("qc/{sample}_busco_racon")
    params:
        MODE= "genome"
    conda:
        config["environments"]["busco"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_busco_racon"
    shell:
        """

        cd qc
        sample="{output}"
        sample_trimmed=${{sample#qc/}}
        busco -m {params.MODE} -i ../{input} -o ${{sample_trimmed}} --auto-lineage-euk

        """

################################################################################################################################################################

rule busco_racon2: 
    input: 
        "polish/{sample}_racon2.fasta"
    output: 
        directory("qc/{sample}_busco_racon2")
    params:
        MODE= "genome"
    conda:
        config["environments"]["busco"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_busco_racon2"
    shell:
        """

        cd qc
        sample="{output}"
        sample_trimmed=${{sample#qc/}}
        busco -m {params.MODE} -i ../{input} -o ${{sample_trimmed}} --auto-lineage-euk

        """

################################################################################################################################################################

rule busco_medaka: 
    input: 
        "polish/{sample}_medaka.fasta"
    output: 
        directory("qc/{sample}_busco_medaka")
    params:
        MODE= "genome"
    conda:
        config["environments"]["busco"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_busco_medaka"
    shell:
        """

        cd qc
        sample="{output}"
        sample_trimmed=${{sample#qc/}}
        busco -m {params.MODE} -i ../{input} -o ${{sample_trimmed}} --auto-lineage-euk

        """
        
################################################################################################################################################################

rule busco_pilon: 
    input: 
        "polish/{sample}_pilon.fasta"
    output: 
        directory("qc/{sample}_busco_pilon")
    params:
        MODE= "genome"
    conda:
        config["environments"]["busco"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_busco_pilon"
    shell:
        """

        cd qc
        sample="{output}"
        sample_trimmed=${{sample#qc/}}
        busco -m {params.MODE} -i ../{input} -o ${{sample_trimmed}} --auto-lineage-euk

        """

rule busco_pilon2: 
    input: 
        "polish/{sample}_pilon2.fasta"
    output: 
        directory("qc/{sample}_busco_pilon2")
    params:
        MODE= "genome"
    conda:
        config["environments"]["busco"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_busco_pilon2"
    shell:
        """

        cd qc
        sample="{output}"
        sample_trimmed=${{sample#qc/}}
        busco -m {params.MODE} -i ../{input} -o ${{sample_trimmed}} --auto-lineage-euk

        """

rule busco_pilon3: 
    input: 
        "polish/{sample}_pilon3.fasta"
    output: 
        directory("qc/{sample}_busco_pilon3")
    params:
        MODE= "genome"
    conda:
        config["environments"]["busco"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_busco_pilon3"
    shell:
        """

        cd qc
        sample="{output}"
        sample_trimmed=${{sample#qc/}}
        busco -m {params.MODE} -i ../{input} -o ${{sample_trimmed}} --auto-lineage-euk

        """

rule busco_pilon4: 
    input: 
        "polish/{sample}_pilon4.fasta"
    output: 
        directory("qc/{sample}_busco_pilon4")
    params:
        MODE= "genome"
    conda:
        config["environments"]["busco"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_busco_pilon4"
    shell:
        """

        cd qc
        sample="{output}"
        sample_trimmed=${{sample#qc/}}
        busco -m {params.MODE} -i ../{input} -o ${{sample_trimmed}} --auto-lineage-euk

        """

################################################################################################################################################################

rule busco_jasper: 
    input: 
        "polish/{sample}_jasper.fasta"
    output: 
        directory("qc/{sample}_busco_jasper")
    params:
        MODE= "genome"
    conda:
        config["environments"]["busco"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_busco_jasper"
    shell:
        """

        cd qc
        sample="{output}"
        sample_trimmed=${{sample#qc/}}
        busco -m {params.MODE} -i ../{input} -o ${{sample_trimmed}} --auto-lineage-euk

        """
        
################################################################################################################################################################

rule busco_quickmerge: 
    input: 
        "{sample}_quickmerge.fasta"
    output: 
        directory("qc/{sample}_busco_quickmerge")
    params:
        MODE= "genome"
    conda:
        config["environments"]["busco"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_busco_quickmerge"
    shell:
        """

        cd qc
        sample="{output}"
        sample_trimmed=${{sample#qc/}}
        busco -m {params.MODE} -i ../{input} -o ${{sample_trimmed}} --auto-lineage-euk

        """