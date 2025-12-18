suppressPackageStartupMessages(library(data.table))

generate_data <- function(n_ind = 5, n_snp = 10, n_ancestry = 3, seed = NULL,
                          map_file = "example.map",
                          ped_file = "example.ped",
                          fb_file = "example.fb",
                          viterbi_file = "example.viterbi") {
  
  set.seed(seed)
  
  # -------------------------
  # 1. MAP file
  # -------------------------
  map <- data.frame(
    chromosome = 1,
    snp = paste0("rs", 1:n_snp),
    gen_dist = 0,
    position = seq(100, 100 * n_snp, by = 100)
  )
  fwrite(map, map_file, col.names = FALSE, sep = " ")
  
  # -------------------------
  # 2. PED file
  # -------------------------
  ped_meta <- data.frame(
    FID = paste0("F", 1:n_ind),
    IID = paste0("I", 1:n_ind),
    PID = 0,
    MID = 0,
    SEX = sample(1:2, n_ind, replace = TRUE),
    PHENOTYPE = 1
  )
  
  alleles <- c("A", "C", "G", "T")
  geno <- matrix(nrow = n_ind, ncol = 2 * n_snp)
  for (i in 1:(2 * n_snp)) {
    geno[, i] <- sample(alleles, n_ind, replace = TRUE)
  }
  ped <- cbind(ped_meta, geno)
  fwrite(ped, ped_file, col.names = FALSE, sep = " ")
  
  # -------------------------
  # 3. Forward-Backward and Viterbi
  # -------------------------
  fb <- matrix(nrow = n_snp, ncol = 2 * n_ancestry * n_ind)
  viterbi <- matrix(nrow = n_snp, ncol = 2 * n_ind)
  
  for (ind in 1:n_ind) {
    # haplotype backbone to make hap1 and hap2 share ancestry mostly
    hap_backbone <- sample(1:n_ancestry, n_snp, replace = TRUE)
    
    for (hap in 1:2) {
      for (s in 1:n_snp) {
        anc <- hap_backbone[s]
        if (runif(1) < 0.1) {  # 10% chance to switch ancestry
          anc <- sample(setdiff(1:n_ancestry, anc), 1)
        }
        
        # Forward-Backward probabilities
        probs <- rep(0.01, n_ancestry) # small probability for non-ancestry
        probs[anc] <- runif(1, 0.9, 1.0) # high probability for assigned ancestry
        probs <- probs / sum(probs) # normalize to sum to 1
        
        col_start <- ((ind - 1) * 2 + (hap - 1)) * n_ancestry + 1
        fb[s, col_start:(col_start + n_ancestry - 1)] <- probs
        
        # Viterbi = ancestry with max probability
        viterbi[s, (ind - 1) * 2 + hap] <- which.max(probs)
      }
    }
  }
  
  fwrite(as.data.frame(fb), fb_file, col.names = FALSE, sep = " ")
  fwrite(as.data.frame(viterbi), viterbi_file, col.names = FALSE, sep = " ")
  
  message("Example data files generated successfully:")
  message("  MAP: ", map_file)
  message("  PED: ", ped_file)
  message("  Forward-Backward: ", fb_file)
  message("  Viterbi: ", viterbi_file)
  
  invisible(list(map = map, ped = ped, fb = fb, viterbi = viterbi))
}

# -------------------------
# Example usage
# -------------------------
# example_files <- generate_example_data(n_ind = 5, n_snp = 10, n_ancestry = 3)
