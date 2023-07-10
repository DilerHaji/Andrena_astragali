#!/bin/bash
#SBATCH --job-name=chat
#SBATCH --account=fc_flyminer
#SBATCH --partition=savio3_htc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=72:00:00
#SBATCH --qos=savio_normal
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=diler@berkeley.edu

. ~/.bashrc
conda config --set channel_priority strict 
conda activate snakemake

snakemake --unlock
snakemake --cluster "sbatch {resources.resources}" -j 1 --use-conda --rerun-incomplete --rerun-triggers mtime --use-singularity --singularity-args "--nv --disable-cache"