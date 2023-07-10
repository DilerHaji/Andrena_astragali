# quickmerge
# https://github.com/mahulchak/quickmerge

rule find_best_pilon_jasper:
    input:
        pilon="{sample}_genome/polish/{sample}_pilon.fasta",
        jasper="{sample}_genome/polish/{sample}_jasper.fasta", 
        pilon_busco="qc/{sample}_busco_pilon",
        jasper_busco="qc/{sample}_busco_jasper",
    output:
        directory("{sample}_genome/polish/{sample}_best_pilon_jasper")
    benchmark:
        "benchmarks/{sample}_find_best_racon"
    shell:
        """
        
        pilon=$(grep 'Complete BUSCOs' {input.pilon_busco}/short_summary.specific*.txt | awk '{{print $1}}')
        jasper=$(grep 'Complete BUSCOs' {input.jasper_busco}/short_summary.specific*.txt | awk '{{print $1}}')
        
        if [pilon -lt jasper]; then 
        	cp {input.jasper} {output}/{input.jasper}
        else
        	cp {input.pilon} {output}/{input.pilon}
        fi
        
    	"""

rule quickmerge:
    input:
        #long_assembly="{sample}_genome/polish/{sample}_best_pilon_jasper",
        long_assembly="{sample}_genome/polish/{sample}_pilon4.fasta",
        short_assembly="{sample}_DNAseq/masurca/CA/final.genome.scf.fasta"
    output:
        "{sample}_genome/quickmerge/merged_{sample}.fasta"
    params:
        nucmer_threads=config["genome"]["quickmerge"]["nucmer"]["threads"],
        hco=config["genome"]["quickmerge"]["quickmerge"]["hco"],
        c=config["genome"]["quickmerge"]["quickmerge"]["c"],
        l=config["genome"]["quickmerge"]["quickmerge"]["l"],
        nucmer_l=config["genome"]["quickmerge"]["nucmer"]["l"],
        delta_filter_l=config["genome"]["quickmerge"]["delta-filter"]["l"],
        ml=config["genome"]["quickmerge"]["quickmerge"]["ml"]
    conda:
        config["environments"]["quickmerge"]
    resources:
        resources=config["default_resources_24thread"]
    benchmark:
        "benchmarks/{sample}_quickmerge"
    shell:
        """
        
        if [ ! -d {wildcards.sample}_genome/quickmerge ]; then
        	mkdir -p {wildcards.sample}_genome/quickmerge;
        fi
        
        nucmer \
        -l {params.nucmer_l} \
        -t {params.nucmer_threads} \
        -p {wildcards.sample}_genome/quickmerge/{wildcards.sample} \
        {input.short_assembly} {input.long_assembly}
        
        delta-filter -r -q \
        -l {params.delta_filter_l} \
        {wildcards.sample}_genome/quickmerge/{wildcards.sample}.delta > {wildcards.sample}_genome/quickmerge/{wildcards.sample}.rq.delta
        
        cd {wildcards.sample}_genome/quickmerge
          
        quickmerge \
        -d {wildcards.sample}.rq.delta \
        -q ../{input.long_assembly} \
        -r ../{input.short_assembly} \
        -hco {params.hco} \
        -c {params.c} \
        -l {params.l} \
        -ml {params.ml} \
        -p {wildcards.sample}

        """



#quast the merged assembly 