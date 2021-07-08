#!/bin/bash
#--------------------------SBATCH settings------

#SBATCH --job-name=bbduk_clean      ## job name
#SBATCH -A katrine_lab     ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=30    ## number of cores the job needs
#SBATCH --error=slurm-%J.err ## error log file
#SBATCH --output=slurm-%J.out ##output info file

module load bbmap/38.87
for f in $(ls *_READ1.fastq.gz | sed 's/_READ1.fastq.gz//' | sort -u)
do
bbduk.sh \
in=${f}_READ1.fastq.gz \
in2=${f}_READ2.fastq.gz \
ref=adapters,phix \
ktrim=r \
mink=11 \
hdist=1 \
qtrim=rl \
trimq=10 \
out=${f}_READ1.clean.fastq.gz \
out2=${f}_READ2.clean.fastq.gz \
stats=${f}_bbduk_stats1.txt \
refstats=${f}_bbduk_ref_stats1.txt \
tpe \
tbo \
threads=30
done