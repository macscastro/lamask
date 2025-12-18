# -----------------------------------------
# Masking real data from the Indigenous American Genomic Diversity Project (IAGDP)
# -----------------------------------------

suppressPackageStartupMessages(library(data.table))

# -------------------------
# 1. Sourcing lamask function
# -------------------------
source("./lamask/lamask.R")

# -------------------------
# 2. Masking data from all chromosomes using Forward-Backward probabilities
# -------------------------
for(CHR in 1:22){
  lamask(
    map_file = paste0("./data/iagdp.chr",CHR,".map"),
    ped_file = paste0("./data/iagdp.chr",CHR,".ped"),
    fb_file = paste0("./rfmix/output/iagdp.chr",CHR,".ForwardBackward.txt"),
    output_file = paste0("./masked_data/iagdp.chr",CHR,".ped"),
    num_ancestry = 3, # 3 ancestries were included in the local ancestry inference (African, European, and Indigenous American)
    ancestry = 3, # ancestry 3 was selected (all positions not inferred to be of Indigenous American origin were set as missing data)
    threshold = 0.99, # alleles with < 99% inferred probability of having Indigenous American origin where masked
    viterbi = FALSE
  )
}



