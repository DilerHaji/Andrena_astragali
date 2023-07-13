def get_sample_genomes( sample ):
    res = list()
    for genome in config["global"]["samples"].loc[sample].genome:
        if genome not in res:
            res.append(genome)
    return res


rule get_genomes_phylogeny:
    output:
        directory("{sample}_phylogeny"),
    conda:
        config["environments"]["ncbi_datasets"]
    resources:
        resources=config["default_resources"]
    params: 
    	genomes=lambda wildcards: get_sample_genomes(wildcards.sample)
    benchmark:
        "benchmarks/{sample}_ncbi_download"
    shell:
        """
        
        if [ ! -d {wildcards.sample}_phylogeny ]; then
        	mkdir -p {wildcards.sample}_phylogeny;
        fi
        
        cd {output}
        
        datasets download genome accession {params.genomes} --include gff3,rna,cds,protein,genome,seq-report --filename ncbi_dataset.zip
        
        if [ -e README.md ]; then
        rm README.md
        fi
        
        unzip ncbi_dataset.zip
        rm ncbi_dataset.zip
  
        """

# rule collect_busco_outputs: 
# 
# shell:
# 	"""
# 	cp genome/*_busco busco_outputs -r
# 	cp transcriptome/*_busco busco_outputs -r
# 
# 	"""
# 
# 
# rule 
# 
# 

def aggregate_input(wildcards):
      checkpoint_output = checkpoints.ncbi_download.get(**wildcards).output[0]
      return expand("ncbi_dataset/data/{i}.fa",
                  i=glob_wildcards(os.path.join(checkpoint_output, "ncbi_dataset/data/{i}.fa")).i)

rule busco_ncbi:
    input:
        aggregate_input
    output:
        directory("ncbi_busco")
    params:
        MODE= "genome"
    conda:
        config["environments"]["busco"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/ncbi_busco"
    shell:
        """

        busco -m {params.MODE} -i {input} -o {output} --auto-lineage-euk

        """
