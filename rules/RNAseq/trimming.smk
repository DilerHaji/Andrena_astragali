rule trim_galore: 
    input: 
    	forward_corrected="{sample}_RNAseq/unfixrm_{sample}_R1.cor.fq",
    	reverse_corrected="{sample}_RNAseq/unfixrm_{sample}_R2.cor.fq"
    output: 
        fasta_fwd="{sample}_RNAseq/{sample}_trimmed/{sample}_R1.fq.gz",
        report_fwd="{sample}_RNAseq/{sample}_trimmed/reports/{sample}_R1_trimming_report.txt",
        fasta_rev="{sample}_RNAseq/{sample}_trimmed/{sample}_R2.fq.gz",
        report_rev="{sample}_RNAseq/{sample}_trimmed/reports/{sample}_R2_trimming_report.txt",
    threads: 
    	config["RNAont"]["trim_galore"]["threads"]
    params:
    	extra=config["RNAont"]["trim_galore"]["extra"],
    benchmark: 
    	"benchmarks/RNAseq/{sample}_trim"
    log:
        "logs/RNAseq/{sample}_trim/{sample}.log"
    wrapper:
        "v2.2.0/bio/trim_galore/pe"
	