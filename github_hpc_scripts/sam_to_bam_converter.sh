#!/bin/bash
#--------------------------SBATCH settings------

#SBATCH --job-name=sam_to_bam_converter      ## job name
#SBATCH -A katrine_lab     ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=30    ## number of cores the job needs
#SBATCH --error=slurm-%J.err ## error log file
#SBATCH --output=slurm-%J.out ##output info file

module load samtools

for f in $(ls *.sam | sed 's/.sam//' | sort -u)
do
samtools view -S ${f}.sam -@ 30 -b > ${f}.bam 
done
