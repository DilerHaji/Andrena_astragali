# quickmerge
# https://github.com/mahulchak/quickmerge

rule find_best_pilon_jasper:
    input:
        pilon="polish/{sample}_pilon.fasta",
        jasper="polish/{sample}_jasper.fasta", 
        pilon_busco="qc/{sample}_busco_pilon",
        jasper_busco="qc/{sample}_busco_jasper",
    output:
        directory("polish/{sample}_best_pilon_jasper")
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
        #long_assembly="polish/{sample}_best_pilon_jasper",
        long_assembly="polish/{sample}_pilon4.fasta",
        short_assembly="{sample}_DNAseq/masurca/CA/final.genome.scf.fasta"
    output:
        "{sample}_quickmerge.fasta"
    params:
        hco=config["genome"]["quickmerge"]["quickmerge"]["hco"],
        c=config["genome"]["quickmerge"]["quickmerge"]["c"],
        l=config["genome"]["quickmerge"]["quickmerge"]["l"],
        nucmer_l=config["genome"]["quickmerge"]["nucmer"]["l"],
        delta_filter_l=config["genome"]["quickmerge"]["delta-filter"]["l"],
        ml=config["genome"]["quickmerge"]["quickmerge"]["ml"]
    conda:
        config["environments"]["quickmerge"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_quickmerge"
    shell:
        """
        
        if [ ! -d quickmerge ]; then
        	mkdir -p quickmerge;
        fi
        
        nucmer \
    		-l {params.nucmer_l} \
    		-prefix quickmerge/{wildcards.sample} \
    		{input.short_assembly} {input.long_assembly}
    	
    	delta-filter -r -q \
    		-l {params.delta_filter_l} \
    		quickmerge/{wildcards.sample}.delta > quickmerge/{wildcards.sample}.rq.delta
    	
    	quickmerge \
    		-d quickmerge/{wildcards.sample}.rq.delta \
    		-q {input.long_assembly}/*fasta \
    		-r {input.short_assembly} \
    		-hco {params.hco} \
    		-c {params.c} \
    		-l {params.l} \
    		-ml {params.ml} \
    		-p quickmerge/{wildcards.sample}
        
        mv quickmerge/{wildcards.sample}/merge.fasta {output}

        """



#quast the merged assembly 