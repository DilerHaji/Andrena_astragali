rule dorado_pairs_basecaller: 
    input: 
        pod5_done="{sample}_DNAont/pod5_done",
        model=config["DNAont"]["nanopore_basecalling_model"]
    output: 
        main_pairs="{sample}_DNAont/{sample}_unmapped_reads_with_moves.sam",
    params: 
        dorado=config["programs"]["dorado"]
    conda:
        config["environments"]["dorado"]
    resources:
        resources=config["gpu_resources"]
    benchmark:
        "{sample}_benchmarks/{sample}_dorado_pairs_basecaller"
    shell: 
        """
        
        {params.dorado} basecaller {input.model} {wildcards.sample}_ont --device 'cuda:all' --emit-moves > {output.main_pairs}
        
        """



rule dorado_pairs_to_bam: 
    input: 
        main_pairs="{sample}_DNAont/{sample}_unmapped_reads_with_moves.sam"
    output: 
        main_pairs_bam="{sample}_DNAont/{sample}_unmapped_reads_with_moves.bam"
    conda:
        config["environments"]["samtools"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_dorado_pairs_to_bam"
    shell: 
        """
        
        samtools view -Sh {input.main_pairs} > {output.main_pairs_bam}

        """




rule dorado_pairs: 
    input: 
        pod5_done="{sample}_DNAont/pod5_done", 
        main_pairs_bam="{sample}_DNAont/{sample}_unmapped_reads_with_moves.bam",
        main_pairs="{sample}_DNAont/{sample}_unmapped_reads_with_moves.sam"
    output: 
        other_pairs="{sample}_DNAont/{sample}_split_duplex_pair_ids.txt",
        pairs_dir=directory("{sample}_DNAont/{sample}_pairs_from_bam/"),
        other_pairs_dir=directory("{sample}_DNAont/{sample}_pod5s_splitduplex/")
    conda:
        config["environments"]["dorado"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_dorado_pairs"
    shell: 
        """
        
        duplex_tools pair --output_dir {output.pairs_dir} {input.main_pairs_bam}

        duplex_tools split_pairs {input.main_pairs} {wildcards.sample}_ont {output.other_pairs_dir}
        
        cat {output.other_pairs_dir}/*_pair_ids.txt > {output.other_pairs}


        """



rule dorado_duplex_main_pairs: 
    input: 
        pairs_dir="{sample}_DNAont/{sample}_pairs_from_bam/",
        model=config["DNAont"]["nanopore_basecalling_model"]
    output: 
        duplex_main_pairing="{sample}_DNAont/{sample}_duplex_main_pairing.fastq"
    params: 
        dorado=config["programs"]["dorado"]
    conda:
        config["environments"]["dorado"]
    resources:
        resources=config["gpu_resources"]
    benchmark:
        "benchmarks/{sample}_dorado_duplex_main_pairs"
    shell: 
        """

        {params.dorado} duplex {input.model} {wildcards.sample}_ont --pairs {input.pairs_dir}/pair_ids.txt --device 'cuda:all' --emit-fastq > {output.duplex_main_pairing}

        """


rule dorado_duplex_other_pairs: 
    input: 
        other_pairs="{sample}_DNAont/{sample}_split_duplex_pair_ids.txt",
        other_pairs_dir="{sample}_DNAont/{sample}_pod5s_splitduplex/",
        model=config["DNAont"]["nanopore_basecalling_model"]
    output: 
        duplex_other_pairing="{sample}_ont/{sample}_duplex_splitduplex.fastq"
    params: 
        dorado=config["programs"]["dorado"]
    conda:
        config["environments"]["dorado"]
    resources:
        resources=config["gpu_resources"]
    benchmark:
        "benchmarks/{sample}_dorado_duplex_other_pairs"
    shell: 
        """

        {params.dorado} duplex {input.model} {input.other_pairs_dir} --pairs {input.other_pairs} --device 'cuda:all' --emit-fastq > {output.duplex_other_pairing}

        """