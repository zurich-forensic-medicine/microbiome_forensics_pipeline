##############  MSA Construction ##############
# note: msa package provides a unified R/Bioconductor interface to MSA (ClustalW, ClustalOmega, Muscle)

# extract DNA seq from seqtab object
seqs <- asv_sequences  # NOTE: names of this vector will propagate to the tip labels of the tree



# option 1:  AlignSeqsfrom the DECIPHER
if (tools_param$MSA_aligner=="DECIPHER"){
  print("--> run MSA by DECIPHER:")
  tic()
  microbiome.msa <- DECIPHER::AlignSeqs( DNAStringSet(seqs) )
  cat("msa (DECIPHER) took: ")
  toc()
}



# option 2: generate MSA with Muscle
# TODO: check for Muscle specific parameters
# 5 hours
if (tools_param$MSA_aligner=="MUSCLE"){
  print("--> run MSA by MUSCLE")
  tic()
  microbiome.msa <- msa::msaMuscle(seqs, type="dna", order="input")
  cat("msa (muscle) took: ")
  toc()  # 1972.561sec
}



# option 3: generate MSA with clustalW
# TODO: check for ClustalW specific parameters
# microbiome.msa.clustalW <- msa::msa(seqs, method="ClustalW", type="dna", order="input")
# 6 hours
if (tools_param$MSA_aligner=="clustalw"){
  print("--> run MSA by clustalw")
  tic()
  microbiome.msa <- msa::msaClustalW(seqs, type="dna", order="input")
  cat("msa (clustalw) took: ")
  toc() 
}


# save MSA as a fasta file 
# NOTE: in case of NOT DECIPHER there should be (unmasked(microbiome.msa)
Biostrings::writeXStringSet(microbiome.msa, file=file.path(files_intermediate_dada, "msa.fasta"))
save(microbiome.msa, file=file.path(files_intermediate_dada, msa.file)) 
