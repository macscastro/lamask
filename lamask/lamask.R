suppressPackageStartupMessages({
  library(data.table)
})

lamask <- function(map_file,
                   ped_file,
                   fb_file,
                   output_file,
                   num_ancestry = 3,
                   ancestry = 1,
                   threshold = 0.99,
                   viterbi = FALSE) {
  
  ## -------------------------------
  ## 1. Read MAP and PED
  ## -------------------------------
  map <- fread(map_file, header = FALSE, data.table = FALSE)
  ped <- fread(ped_file, header = FALSE, data.table = FALSE,
               colClasses = "character")
  
  n_snps <- nrow(map)
  n_ind  <- nrow(ped)
  
  if (ncol(ped) != 6 + 2 * n_snps)
    stop("PED file does not contain 2 genotype columns per SNP")
  
  ## -------------------------------
  ## 2. Read ForwardBackward / Viterbi 
  ## -------------------------------
  fb <- fread(fb_file, header = FALSE, data.table = FALSE)
  fb <- as.matrix(fb)
  
  if (nrow(fb) != n_snps) {
    stop("Number of SNPs in MAP and FB/Viterbi do not match")
  }
  
  if (viterbi) {
    if (ncol(fb) %% 2 != 0)
      stop("Viterbi file must contain haplotype pairs (even number of columns)")
  }
  
  if (!viterbi) {
    if (ncol(fb) / (2 * num_ancestry) != n_ind)
      stop(
        paste0(
          "Mismatch between individuals:\n",
          "  PED individuals: ", n_ind, "\n",
          "  FB/Viterbi haplotype pairs: ", ncol(fb) / (2 * num_ancestry)
        )
      )
  }
  
  ## -------------------------------
  ## 3. Subset ancestry columns (ForwardBackward only)
  ## -------------------------------
  if (!viterbi) {
    fb <- fb[, seq(ancestry, ncol(fb), by = num_ancestry), drop = FALSE]
  }
  
  ## -------------------------------
  ## 4. Build mask 
  ## -------------------------------
  hap1 <- fb[, seq(1, ncol(fb), by = 2), drop = FALSE]
  hap2 <- fb[, seq(2, ncol(fb), by = 2), drop = FALSE]
  
  if (!viterbi) {
    mask_hap <- (hap1 < threshold) | (hap2 < threshold)
  } else {
    mask_hap <- (hap1 != ancestry) | (hap2 != ancestry)
  }
  
  ## -------------------------------
  ## 5. Expand mask to allele level and transpose the matrix to ensure consistency with the genotype data
  ## -------------------------------
  mask_allele <- t(mask_hap[rep(seq_len(nrow(mask_hap)), each = 2), ])
  
  ## -------------------------------
  ## 6. Extract genotypes
  ## -------------------------------
  geno <- as.matrix(ped[, 7:ncol(ped)])
  
  ## Sanity check: allele integrity
  if (!all(geno %in% c("A","C","G","T","0"))) {
    stop("PED contains unexpected allele codes")
  }
  
  ## -------------------------------
  ## 7. Apply mask
  ## -------------------------------
  geno[mask_allele] <- "0"
  
  ## -------------------------------
  ## 8. Rebuild PED
  ## -------------------------------
  ped_out <- cbind(ped[, 1:6], geno)
  
  ## -------------------------------
  ## 9. Write output
  ## -------------------------------
  fwrite(
    ped_out,
    file = output_file,
    sep = " ",
    quote = FALSE,
    col.names = FALSE,
    row.names = FALSE
  )
  
  message("Masking completed successfully: ", output_file)
  invisible(ped_out) # Return the masked ped file
}
