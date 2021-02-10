print(paste("########   Configuration set for : ", conf, " ###############" ))


###### 1: Set Paths to folders and files ###############################
# TODO create if they dont exists
#if(!file_test("-d", filt_path)) dir.create(result_path)
#if(!file_test("-d", filt_path)) dir.create(filt_path)  # create filetered folder


# Easily swith between local / server cofiguration 

# paths to bioinformatic tools and home folder
if(conf$location == "LOCAL"){
  project_path <- "~/Projects_R/twins_microbiome_pipeline"
  raxm.exec.path <- "/Users/alex/bioinf_tools/RAxML/raxmlHPC-PTHREADS-AVX"
  fastqc.path = "/Applications/BIOINF/FastQC.app/Contents/MacOS/fastqc"

} else if(conf$location == "HOMESERVER") {
  project_path <- "/media/alex/db5547c3-1ac1-4ec5-aac9-29a383a87978"
  raxm.exec.path <- "/home/alex/installed/BIOINF_tools/RAxML/raxmlHPC-PTHREADS-AVX"
  fastqc.path = ""

} else {
  stop(" WRONG SERVER CONFIGURATION")
}

# generate path to all external taxonomy DBs
taxonomy_db_path <- file.path(project_path, "16S_taxonomy_db")

# set path to a dataset
if(conf$dataset == "TWIN"){
  dataset_path <- "data_set_twin"  # TODO: if HOMESERVER,  "BIOINF_DATA/TwinUK_Full"
} else if (conf$dataset == "BFL"){
  dataset_path <- "data_set_bodyfl"
} else{
  stop("no such configuration exists yet")
}

metadata_path   <- file.path(project_path, dataset_path, "metadata")
data_path <- file.path(project_path, dataset_path, "fastq")
filt_path <- file.path(project_path, dataset_path, "fastq/filtered")
raw_path <- file.path(project_path, dataset_path, "fastq/raw")

qiime_qza_path <- file.path(project_path, dataset_path, "fastq/qza")
files_intermediate_dada  <- file.path(project_path, dataset_path, "files_intermediate_dada")
files_intermediate_qiime <- file.path(project_path, dataset_path, "files_intermediate_qiime")



##### Set intermediate file names 
metadata.file <- "metadata.RData"
dada.err.file <- "dada_err_data.RData"
mergers.file <- "mergers.RData"
seqtab.file <- "seqtab.RData"   
seqtab.snames.file <- "seqtab_snames.RData"  
msa.file <- "msa.RData"
phylo.file <- "phylo_trees.RData"





