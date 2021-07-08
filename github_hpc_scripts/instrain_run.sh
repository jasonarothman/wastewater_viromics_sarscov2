#!/bin/bash
#--------------------------SBATCH settings------

#SBATCH --job-name=instrain_run      ## job name
#SBATCH -A katrine_lab     ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=30    ## number of cores the job needs
#SBATCH --error=slurm-%J.err ## error log file
#SBATCH --output=slurm-%J.out ##output info file


module load anaconda/2020.07

eval "$(conda shell.bash hook)"

conda activate instrain
for f in $(ls *_sorted.bam | sed 's/_sorted.bam//' | sort -u)
do
inStrain profile ${f}_sorted.bam -l 0.9 -p 30 all_virus_genomes.fna -o ${f}_instrain 
done