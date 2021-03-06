# 16S amplicon microbiome processing pipeline
A Bioinformatics pipeline for processing 16S amplicon raw Illumina reads

INPUTS: raw Illumina data, meta information (age, sex etc)

OUTPUT: a Phyloseq object with inferred: ASV table, taxonomy, phylo-tree and meta information about samples


## Pipeline
All calculation is organized as a pipeline. An entry point to run this pipeline is run_bf_dada_pipeline.R script.
Execute run_bf_dada_pipeline.R file to run the entire pipeline.

The general principle of this pipeline is modularity and flexibility.

As a preliminary pipeline step three global data structures are initialized:
- conf : names(conf) <- c("location", "dataset", "pipeline")
- dada_param : names(dada_param) <- c("QUALITY_THRESHOLD", "maxEE", "trimLeft", "trimRight", "truncLen")
- tools_param : c("MSA_aligner", "tree_method", "tax_db", "tax_method")

which are self-explanatory. They are used inside every script to set up tools parameters and to form a final Phyloseq object file name.

Then, subsequently all steps of the pipeline are ran.

All individual steps of this pipeline (adapter trimming, merging etc) are in /pipeline_steps folder

load.R  - load all neccesary R packages
configure.R - initialize all paths to data/intermediate folders and bioinformatics tools


TODO: create a docker image to be able to run everything without any installations


### Step 1: Cutadapt [ src/pipeline_steps/1_cut_adapters.R  ]
Note: cutadapt must be installed and path to python and cutadapt must be hardcoded into 1_cut_adapters.R


### Step 4: [ src/pipeline_steps/4_BIG_dada_SV_table.R ]

WARNING: most computationally demanding script! ~1 day on 4 core server with 32G memory

This script inplements dada2 pipeline to convert RAW Illumina reads into Single Variants (SV) table (analogous to OTU, but on variant level, not species).

The pipeline is desribed here - https://www.bioconductor.org/packages/devel/bioc/vignettes/dada2/inst/doc/dada2-intro.html

RESULTS: the result is a seqtab abandance matrix (3288 samples[ERR138, ...] x 8299 sequence variants) with abundancies in every cell.
saved into "seqtab_q15.RData" (q means trim parameter used during run)


### Step 5: [ src/pipeline_steps/5_MSA.R ]
  
  
  
### Step 6. [ src/pipeline_steps/6_Phylogeny.R ]

Create a phylogeny out of all deduced sequence 8299 variants as follows
  - MSA with Muscle or ClustalW (seems very slow, need to investigate its advantages if any)
  - create a guide tree with NJ
  - build a tree with Phangorn, and parameters : model="GTR", optInv=TRUE, optGamma=TRUE (fast option)
  - Run  RAxML (slow, but accurate option) - need to be installed on local machine!
  
  
### Step 7. [ src/pipeline_steps/4_Tax_Assign.R ]

For each sequence variant deduced during previous step assign a taxomomy


   
   

  
  
### Step 8. [ src/pipeline_steps/6_Create_Phyloseq_obj.R ]

Combine everithing in one place.
Create and save Phyloseq object for further manipulation and visulization of microbiome data
https://vaulot.github.io/tutorials/Phyloseq_tutorial.html#aim



  
  
## References and packages
- ape - Analyses of Phylogenetics and Evolution
- RAxML - create a phylo tree for big abount of short sequnces (16S)
- phangorn - phylo tree building package
- Phyloseq - package to analyse microbial communities



