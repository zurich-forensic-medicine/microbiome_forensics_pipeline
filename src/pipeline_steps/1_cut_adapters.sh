# catadapt must be installed:: source activate py3.6_twins
#  chmod +x 0_cut_adapters.sh

# INPUT: 
# folder with RAW reads
RAW_FOLDER=$1
PATH_TO_CUTADAPT="/Users/alex/anaconda3/envs/py3.6_twins/bin/python /Users/alex/anaconda3/envs/py3.6_twins/bin/cutadapt"


#cutadapt -a ADAPTER_FWD -A ADAPTER_REV -o out.1.fastq -p out.2.fastq reads.1.fastq reads.2.fastq
# -q 20,20 - quality trimming
# -e - error filtering
# -o - output / -p - paired output
# -a - 3’ adapter, forwardPrimer1InverseSequence
# -g - 5’ adapter  (front), forwardPrimer


echo "--- Start cutting adapters with cutadapt version ------"
# catadapt must be installed, change py3.6_twins to you conda environment
${PATH_TO_CUTADAPT} --version

for SAMPLE_F in ${RAW_FOLDER}/*R1.fastq;
do
  SAMPLE_R=$(echo ${SAMPLE_F} | sed "s/R1/R2/") # substitute R1 to R2 for reverse read
  echo ${SAMPLE_F}
  echo ${SAMPLE_R}
  
  # form output path
  OUT_F=$(echo ${SAMPLE_F} | sed "s/raw/no_primers/") # change the output folder
  OUT_R=$(echo ${SAMPLE_R} | sed "s/raw/no_primers/") 
  echo ${OUT_F}
  echo ${OUT_R}
  
  echo ${PATH_TO_CUTADAPT} \
  -g "CCAGCAGCYGCGGTAAN"
  
  ${PATH_TO_CUTADAPT} \
  -g "CCAGCAGCYGCGGTAAN" \
  -G "CCGTCAATTCNTTTRAGT" -G "CCGTCAATTTCTTTGAGT"  -G "CCGTCTATTCCTTTGANT" \
  -o ${OUT_F} -p ${OUT_R} \
  ${SAMPLE_F} ${SAMPLE_R}

done
