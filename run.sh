#!/bin/bash
#SBATCH --job-name=chat
#SBATCH --account=co_rosalind
#SBATCH --partition=savio2
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --time=72:00:00
#SBATCH --qos=savio_lowprio
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=diler@berkeley.edu

. ~/.bashrc
conda config --set channel_priority strict 
conda activate snakemake

snakemake --cluster "sbatch {resources.resources}" -j 2 --use-conda --rerun-incomplete --rerun-triggers mtime --use-singularity --singularity-args "--nv --disable-cache"