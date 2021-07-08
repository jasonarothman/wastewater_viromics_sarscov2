#!/bin/bash
#--------------------------SBATCH settings------

#SBATCH --job-name=bam_to_sorted_bam_converter      ## job name
#SBATCH -A katrine_lab     ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=30    ## number of cores the job needs
#SBATCH --error=slurm-%J.err ## error log file
#SBATCH --output=slurm-%J.out ##output info file

module load samtools

for f in $(ls *.bam | sed 's/.bam//' | sort -u)
do
samtools sort ${f}.bam -@ 30 > ${f}_sorted.bam 
done
