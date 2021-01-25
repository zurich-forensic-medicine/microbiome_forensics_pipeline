#### INFER A PHYLOGENY TREE with
# Phangorn (NJ, ML Felsenstein)
# RAxML (TODO)
# ape - Analyses of Phylogenetics and Evolution
##############################################
# http://www.metagenomics.wiki/tools/phylogenetic-tree

# INPUT: the following files must be here



########### OPTION 1:  fast NJ tree, can be used as guide tree as well

# infer a tree with fast NJ method 
# 40 min
if (tools_param$tree_method=="PHANGORN"){
  print("-------> Tree inference by PHANGORN")
  tic()
  phang.align <- phangorn::as.phyDat(my.msa, type="DNA", names=samples.names)
  dm <- dist.ml(phang.align)  #distance matrix
  treeNJ <- phangorn::NJ(dm) # "phylo" object (a tree)
  toc()
  save(treeNJ, file=file.path(files_intermediate_dada, phylo.file)) 
  
  ####### refine NJ tree with nt substitution model by Felsenstein ML mehod
  ## WARNING! Might take a lot of time
  # infer ML tree with Jukes-Cantor model (JC69, default one), usin NJ as a guide tree
  # fitJC is "pml" object, tree can be extracted as fitJC$tree, also has logLik etc parameters
  # 55 min
  tic()
  fitJC <- phangorn::pml(tree=treeNJ, data=phang.align)   # pmlcomputes  the  likelihood  of  a  phylogenetic  tree 
  fitJC <- optim.pml(fitJC)    # optimize edge length etc parameters
  toc()
  save(treeNJ, fitJC, file=file.path(files_intermediate_dada, phylo.file))
  
  # futher refine ML tree with GTR+G+I model
  tic()
  # change parameters of pml: k=Number of intervals of the discrete gamma distribution, inv=Proportion of invariable sites
  # What is that parameters?!
  fitGTR <- update(fitJC, k=4, inv=0.2)  
  fitGTR <- phangorn::optim.pml(fitGTR, model="GTR", optInv=TRUE, optGamma=TRUE,
                      rearrangement = "stochastic", control = pml.control(trace = 0))
  toc()
  
  # save the tree to file
  save(treeNJ, fitJC, fitGTR, file=file.path(files_intermediate_dada, phylo.file)) 
  
  my.tree <- fitGTR
}



############### OPTION 2 :  ML tree with RAxML: ML tree for species >1000 with fast heuristics
####  NOTE: need to install raxml on local MAC first
#exec.path.mac <- "/Users/alex/bioinf_tools/RAxML/raxmlHPC-PTHREADS-AVX"
#exec.path.ubuntu <- "/home/alex/installed/BIOINF_tools/RAxML/raxmlHPC-PTHREADS-AVX"

# convert msa::MsaDNAMultipleAlignment data into ips::DNAbin (ape::DNAbim) format!
msa.dnabin <- ape::as.DNAbin(my.msa, check.names=TRUE)


# vizual control of MSA
labels(msa.dnabin)
print(msa.dnabin)   # Base composition: acgt = NaN! why?

save(my.msa, msa.dnabin, file=file.path(files_intermediate_dada, msa.file)) 

if (tools_param$tree_method=="RAXML"){
  print("-------> Tree inference by RAXML")
  # Parameters:
  # f - RAxML algorithm
  # N - Integers give the number of independent searches on different starting tree or replicates in bootstrapping. 
  # p - Integer, setting a random seed for the parsimony starting trees.
  # return tr is a list of tr[1] - info, tr[2] - best tree (rooted)
  
  # 5.5h
  tic()
  tree.raxml <- ips::raxml(
    as.matrix(msa.dnabin), 
    m = "GTRGAMMA",
    f = "d",   # d - new rapid hill-climbing / "a", # best tree and bootstrap
    N = 10, # number of bootstrap replicates
    p = 2234, # random number seed
    exec = raxm.exec.path, 
    threads=6,
    file="RAxML_tree"
  ) # , file="RAxMLtwin_tree",  m = "GTRGAMMA",
  
  cat("RAXML elapsed time: ")
  toc() # 3045.909 sec = 0.8 h om 6 core server - very fast
  
  my.tree <- tree.raxml
  save(my.tree, file=file.path(files_intermediate_dada, phylo.file)) 
  
}



############### OPTION 3 : FastTree
# http://www.microbesonline.org/fasttree/





