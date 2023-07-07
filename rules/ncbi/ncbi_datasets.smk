def get_genomes(ncbi_genomes):
    genomes=config.get("ncbi_genomes")
    return expand(genomes)

checkpoint ncbi_download:
    output:
        directory("ncbi_dataset/data/")
    conda:
        config["environments"]["ncbi_datasets"]
    resources:
        resources=config["default_resources"]
    params: 
        ncbi_genomes=get_genomes
    benchmark:
        "benchmarks/ncbi_download"
    shell:
        """
        datasets download genome accession {params.ncbi_genomes} --include gff3,rna,cds,protein,genome,seq-report --filename ncbi_dataset.zip
        
        if [ -e README.md ]; then
        rm README.md
        fi
        
        unzip ncbi_dataset.zip

        rm ncbi_dataset.zip
  
        """

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
