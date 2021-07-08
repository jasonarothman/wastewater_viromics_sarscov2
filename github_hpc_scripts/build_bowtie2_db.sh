#!/bin/bash
#--------------------------SBATCH settings------

#SBATCH --job-name=bowtie2_build      ## job name
#SBATCH -A katrine_lab     ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=30    ## number of cores the job needs
#SBATCH --error=slurm-%J.err ## error log file
#SBATCH --output=slurm-%J.out ##output info file

module load bowtie2

bowtie2-build all_virus_genomes.fna all_virus_genomes_bowtie_db -f --threads 30 