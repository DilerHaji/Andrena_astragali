rule trinity: 
    input:
        left=["reads/reads.left.fq.gz", "reads/reads2.left.fq.gz"],
        right=["reads/reads.right.fq.gz", "reads/reads2.right.fq.gz"],
    output:
        dir=temp(directory("trinity_out_dir/")),
        fas="trinity_out_dir.Trinity.fasta",
        map="trinity_out_dir.Trinity.fasta.gene_trans_map",
    log:
        'logs/trinity/trinity.log',
    params:
        extra=config["RNAseq"]["trinity"]["extra"],
    threads: config["RNAseq"]["trinity"]["threads"]
    resources:
        resources=config["highmem_resources"]  
    wrapper:
        "v2.2.0/bio/trinity"


# rule trinity_inchworm_chrysalis:
#   input:
#     left=
#     right=
#   output:
#     "{sample}_RNAseq/trinity/recursive_trinity.cmds"
#   log:
#     "logs/{sample}_trinity_inchworm_chrysalis.log"
#   conda:
#     "envs/trinity_utils.yaml"
#   params:
#     memory=config["RNAseq"]["trinity"]["memory1"],
#     threads=config["RNAseq"]["trinity"]["threads"],
#     trinity_params=config["RNAseq"]["trinity"]["trinity_params"],
#     strand=config["RNAseq"]["trinity"]["strand"].
#     trim_params=config["RNAseq"]["trimmomatic"]["trim_params"]
#   threads:
#     16
#   shell:
#     """
#     
#     Trinity --no_distributed_trinity_exec \
#     --trimmomatic \
#     --max_memory {params.memory1} \
#     --CPU {params.threads} \
#     --left {input.left} \
#     --right {input.right} \
#     --quality_trimming_params {params.trim_params} \
#     {params.trinity_params} \
#     {params.strand} &> {log}
#    
#     """
# 
# checkpoint trinity_butterfly_split:
#   input:
#     "{sample}_RNAseq/trinity/recursive_trinity.cmds"
#   output:
#     directory("{sample}_RNAseq/trinity/parallel_jobs")
#   log:
#     "logs/{sample}_trinity_split.log"
#   shell:
#     """
#    
#     mkdir -p {output} &> {log}
#     split -n l/1000 -e -d {input} {output}/job_ &>> {log}
#    
#     """
# 
# 
# rule trinity_butterfly_parallel:
#   input:
#     "{sample}_RNAseq/trinity/parallel_jobs/job_{job_index}"
#   output:
#     "{sample}_RNAseq/trinity/parallel_jobs/completed_{job_index}"
#   log:
#     "logs/{sample}_trinity_parallel{job_index}.log"
#   conda:
#     "envs/trinity_utils.yaml"
#   params:
#     memory=config["RNAseq"]["trinity"]["memory2"]
#   threads:
#     1
#   shell:
#     """
#     bash {input} &> {log}
#     cp -p {input} {output} &>> {log}
#     """
# 
# 
# def trinity_completed_parallel_jobs(wildcards):
#   parallel_dir = checkpoints.trinity_butterfly_split.get(**wildcards).output[0]
#   job_ids = glob_wildcards(os.path.join(parallel_dir, "job_{job_index}")).job_index
#   completed_ids = expand(os.path.join(parallel_dir,"completed_{job_index}"), job_index=job_ids)
#   return completed_ids
# 
# 
# rule trinity_butterfly_parallel_merge:
#   input:
#     jobs=trinity_completed_parallel_jobs,
#     cmds="{sample}_RNAseq/trinity/recursive_trinity.cmds"
#   output:
#     cmds_completed="{sample}_RNAseq/trinity/recursive_trinity.cmds.completed"
#   log:
#     "logs/{sample}_trinity_butterfly_parallel_merge.log"
#   params:
#     memory=config["RNAseq"]["trinity"]["memory1"]
#   threads:
#     config["RNAseq"]["trinity"]["threads"]
#   shell:
#     """
#     # Can crash if there are too many parallel jobs
#     # See https://bitbucket.org/snakemake/snakemake/issues/878/errno-7-argument-list-too-long-path-to-bin 
#     cat {input.jobs} > {output.cmds_completed} 2> {log}
#     """
# 
# 
# rule trinity_final:
#   input:
#     cmds_completed="{sample}_RNAseq/trinity/recursive_trinity.cmds.completed",
#     samples="samples_trimmed.txt"
#   output:
#     transcriptome="{sample}_RNAseq/trinity/Trinity.fasta", #new output files live in base directory now, not trinity_out_dir.
#     gene_trans_map="{sample}_RNAseq/trinity/Trinity.fasta.gene_trans_map" #according to trinity dev, this is a feature, not a bug
#   log:
#     "logs/{sample}_trinity_final.log"
#   conda:
#     "envs/trinity_utils.yaml"
#   params:
#     memory=config["RNAseq"]["trinity"]["memory1"],
#     threads=config["RNAseq"]["trinity"]["threads"],
#     trinity_params=config["RNAseq"]["trinity"]["trinity_params"],
#     strand=config["RNAseq"]["trinity"]["strand"]
#   threads:
#     config["RNAseq"]["trinity"]["threads"]
#   shell:
#     """
#     Trinity --max_memory {params.memory} --CPU {threads} --samples_file {input.samples} {params.trinity_params} {params.strand} &>> {log}
#     """
