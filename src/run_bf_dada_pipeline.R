# A microbiome pipleine based on dada2, this is an entry point
# @AlexY, 2021


################## Configure pipeline
# load R packages
source("src/load.R")


#### initialize a configuration (parameters, location etc)
conf <- vector(mode="list", length=3)
names(conf) <- c("location", "dataset", "pipeline")

dada_param <- vector(mode="list", length=5)
names(dada_param) <- c("QUALITY_THRESHOLD", "maxEE", "trimLeft", "trimRight", "truncLen")

tools_param <- vector(mode="list", length=4)
names(tools_param) <- c("MSA_aligner", "tree_method", "tax_db", "tax_method")


# set the name of the server to easily switсh between server and dataset to analyse
conf$location <- "LOCAL"  # LOCAL / HOMESERVER
conf$dataset <- "BFL"    #   TWIN / "BFL"
conf$pipeline <- "DADA2"   # QIIME / DADA2


# generate abs paths to bioinformatics tools and intermediate files
source("src/configure.R")
setwd(project_path)



########### Start pipeline #############
# load metadata
df.metadata <- read.table(file.path(metadata_path,"metadata.txt"))

# STEP 1: cutdapt
# cutadapt must be installed 
# check inside script to set up direct path to python and cutadapt
source("src/pipeline_steps/1_cut_adapters.R")


# STEP 2: generate a list of raw data file names
source("src/pipeline_steps/2_file_names_parsing.R")


# STEP 4: 
print("==================> long dada2 analysis has started...")
dada_param$QUALITY_THRESHOLD <- 2
dada_param$maxEE <- c(2,4)

# trim If primers are at the start of your reads and are a constant length
dada_param$trimLeft <- c(0,0)
dada_param$trimRight <- c(0,0)

# be carefull, reads less then that are discarded!
dada_param$truncLen <-c(210,220)   # 230 / 210
# INPUT:
# the following files shall be loaded here
source("src/pipeline_steps/4_BIG_dada_SV_table.R")
# OUTPUT:


# STEP 5:
print("==================> MSA construction has started...")
# INPUT:
tools_param$MSA_aligner <- "DECIPHER"   # DECIPHER / MUSCLE / clustalw 
# files: seqtab, samples.names, asv_sequences, filter.log,
load(file=file.path(files_intermediate_dada, seqtab.file)) 
#load(file=file.path(files_intermediate_dada, seqtab.snames.file)) 
source("src/pipeline_steps/5_MSA.R")
# OUTPUT: 
my.msa <- microbiome.msa



# STEP 6:
print("==================> Phylogeny reconstraction has started...")
# INPUT:
tools_param$tree_method <- "FastTree"    # PHANGORN  / FastTree / RAXML
source("src/pipeline_steps/6_Phylogeny.R")
# OUTPUT:


# STEP 7:
print("==================> Taxonomy assignment has started...")
# INPUT:
#tools_param$tax_db <- "silva/silva_nr99_v138_train_set.fa.gz"  # "green_genes/gg_13_8_train_set_97.fa.gz"
tools_param$tax_db <- "ncbi"
tools_param$tax_method <- "mapseq"
#source("src/pipeline_steps/7_Tax_Assign_dada2_RDP.R")
source("src/pipeline_steps/7_Tax_Assign_MapSeq.R")
# OUTPUT


# STEP 8:
print("==================> Creating the final results file...")
source("src/pipeline_steps/8_Create_Phyloseq_obj.R")



print(" >>>>>>>  END  >>>>>>> PhyloSeq object has been created and now you can run your analysis ")




