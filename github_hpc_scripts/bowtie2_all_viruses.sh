#!/bin/bash
#--------------------------SBATCH settings------

#SBATCH --job-name=bowtie2_all_viruses      ## job name
#SBATCH -A katrine_lab     ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=60    ## number of cores the job needs
#SBATCH --error=slurm-%J.err ## error log file
#SBATCH --output=slurm-%J.out ##output info file

module load bowtie2

for f in $(ls *.nohuman.fastq.1.gz | sed 's/.nohuman.fastq.1.gz//' | sort -u)
do
bowtie2 -x all_virus_genomes_bowtie_db -1 ${f}.nohuman.fastq.1.gz -2 ${f}.nohuman.fastq.2.gz -p 60 -S ${f}_all_viruses.sam --no-unal
done