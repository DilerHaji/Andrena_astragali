rule bbmerge:
    input:
        forward_unpacked=os.path.join(DNASEQ_DATA, "{sample}_R1.fastq"),
        reverse_unpacked=os.path.join(DNASEQ_DATA, "{sample}_R2.fastq")
    output:
        merged=os.path.join(DNASEQ_DATA, "{sample}_merged.fq.gz"),
        unmerged_forward=os.path.join(DNASEQ_DATA, "{sample}_unmergedF.fq.gz"),
        unmerged_rev=os.path.join(DNASEQ_DATA, "{sample}_unmergedR.fq.gz")
    conda:
        config["environments"]["bbmap"]
    resources:
        resources=config["default_resources"]
    benchmark:
        "benchmarks/{sample}_bbmerge"
    shell:
        """
        bbmerge.sh in1={input.forward_unpacked} in2={input.reverse_unpacked} out={output.merged} outu1={output.unmerged_forward} outu2={output.unmerged_rev}
        """


rule allreadscombined:
    input:
        merged=os.path.join(DNASEQ_DATA, "{sample}_merged.fq.gz"),
        unmerged_forward=os.path.join(DNASEQ_DATA, "{sample}_unmergedF.fq.gz"),
        unmerged_rev=os.path.join(DNASEQ_DATA, "{sample}_unmergedR.fq.gz")
    output:
        single_reads=os.path.join(DNASEQ_DATA, "{sample}_allsinglereads.fq.gz"),
        all_reads=os.path.join(DNASEQ_DATA, "{sample}_allreads.fq.gz")
    resources:
        resources=config["default_resources"]
    shell:
        """
        cat {input.unmerged_forward} {input.unmerged_rev} > {output.single_reads}
        cat {input.merged} {output.single_reads} > {output.all_reads}
        """

