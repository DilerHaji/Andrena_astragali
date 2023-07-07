rule get_ont_model: 
    output: 
        directory(config["DNAont"]["nanopore_basecalling_model"])
    params:
        dorado=config["programs"]["dorado"],
    resources:
        resources=config["default_resources"]
    shell: 
        """
        
        {params.dorado} download --model {output}

        """



rule convert_ont_to_pod5: 
    input: 
        ONT_DATA
    output: 
        pod5_done="{sample}_DNAont/pod5_done"
    conda:
        config["environments"]["dorado"]
    params: 
        dorado=config["programs"]["dorado"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_convert_ont_to_pod5"
    shell: 
        """
        
        pod5 convert fast5 {input}/*.fast5 {wildcards.sample}_ont --output-one-to-one {input}
        
        ls -l {wildcards.sample}_ont > {output.pod5_done}        

        """


rule dorado_basecaller: 
    input: 
        pod5_done="{sample}_DNAont/pod5_done",
        model=config["DNAont"]["nanopore_basecalling_model"]
    output: 
        "{sample}_DNAont/{sample}_ont_basecalled.fastq"
    params: 
        dorado=config["programs"]["dorado"]
    conda:
        config["environments"]["dorado"]
    resources:
        resources=config["gpu_resources"]
    benchmark:
        "benchmarks/{sample}_dorado_basecaller"
    shell: 
        """
        
        {params.dorado} basecaller {input.model} {wildcards.sample}_ont --device 'cuda:all' --emit-fastq > {output}

        """

