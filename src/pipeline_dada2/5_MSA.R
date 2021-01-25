##############  MSA Construction ##############
# note: msa package provides a unified R/Bioconductor interface to MSA (ClustalW, ClustalOmega, Muscle)

# extract DNA seq from seqtab object
seqs <- asv_sequences  # NOTE: names of this vector will propagate to the tip labels of the tree



# option 1:  AlignSeqsfrom the DECIPHER
if (tools_param$MSA_aligner=="DECIPHER"){
  print("--> run MSA by DECIPHER")
  microbiome.msa.decipher <- DECIPHER::AlignSeqs( DNAStringSet(seqs) )
  Biostrings::writeXStringSet(microbiome.msa.decipher, file=file.path(result_path, "msa_decipher.fasta"))
  save(microbiome.msa.decipher, file=file.path(files_intermediate_dada, msa.file)) 
}



# option 2: generate MSA with Muscle
# TODO: check for Muscle specific parameters
# 5 hours
if (tools_param$MSA_aligner=="MUSCLE"){
  print("--> run MSA by MUSCLE")
  tic()
  microbiome.msa.muscle <- msa::msaMuscle(seqs, type="dna", order="input")
  cat("msa (muscle) took: ")
  toc()  # 1972.561sec
  print(microbiome.msa.muscle)
  rownames(microbiome.msa.muscle)
  
  # save MSA as a fasta file for possible vizualization with UGene browser
  Biostrings::writeXStringSet(unmasked(microbiome.msa.muscle), file=file.path(result_path, "msa_muscle.fasta"))
  save(microbiome.msa.muscle, file=file.path(files_intermediate_dada, msa.file)) 
}



# option 3: generate MSA with clustalW
# TODO: check for ClustalW specific parameters
# microbiome.msa.clustalW <- msa::msa(seqs, method="ClustalW", type="dna", order="input")
# 6 hours
if (tools_param$MSA_aligner=="clustalw"){
  print("--> run MSA by clustalw")
  tic()
  microbiome.msa.clustalw <- msa::msaClustalW(seqs, type="dna", order="input")
  cat("msa (clustalw) took: ")
  toc() 
  print(microbiome.msa.clustalw)
  Biostrings::writeXStringSet(unmasked(microbiome.msa.clustalw), file=file.path(result_path, "msa_clustalw.fasta"))
  
  # save objects for reusing late in pipeline 
  save(microbiome.msa.clustalw,  file=file.path(files_intermediate_dada, msa.file)) 
}


