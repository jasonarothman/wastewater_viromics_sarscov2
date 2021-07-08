#!/bin/bash
#--------------------------SBATCH settings------

#SBATCH --job-name=bbduk_dedupe      ## job name
#SBATCH -A katrine_lab     ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=60    ## number of cores the job needs
#SBATCH --mem-per-cpu=5G	## requested memory (6G = max)
#SBATCH --error=slurm-%J.err ## error log file
#SBATCH --output=slurm-%J.out ##output info file

module load bbmap/38.87
for f in $(ls *_READ1.clean.fastq.gz | sed 's/_READ1.clean.fastq.gz//' | sort -u)
do
dedupe.sh \
in=${f}_READ1.clean.fastq.gz \
in2=${f}_READ2.clean.fastq.gz \
out=${f}.dedupe.fastq.gz \
threads=60
done