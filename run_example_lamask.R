# -----------------------------------------
# Example script: generate data and mask
# -----------------------------------------

suppressPackageStartupMessages(library(data.table))

# -------------------------
# 1. Source lamask function
# -------------------------
# Make sure your lamask function is defined in this script
# or sourced from another file:
source("./lamask/lamask.R")

# -------------------------
# 2. Source generate_example_data function
# -------------------------
source("./generate_data/generate_data.R")

# -------------------------
# 3. Generate example data
# -------------------------
system("mkdir -p ./example/")

example_files <- generate_data(
  n_ind = 5,
  n_snp = 10,
  n_ancestry = 3,
  map_file = "./example/example.map",
  ped_file = "./example/example.ped",
  fb_file = "./example/example.fb",
  viterbi_file = "./example/example.viterbi",
  seed = 42 # set a seed to make results reproducible
)

# -------------------------
# 4. Masking using Forward-Backward probabilities
# -------------------------
lamask(
  map_file = "./example/example.map",
  ped_file = "./example/example.ped",
  fb_file = "./example/example.fb",
  output_file = "./example/masked_fb.ped",
  num_ancestry = 3,
  ancestry = 1,     # mask ancestry 1
  threshold = 0.9,  # alleles with < 90% probability will be masked
  viterbi = FALSE
)

# -------------------------
# 5. Masking using Viterbi states
# -------------------------
lamask(
  map_file = "./example/example.map",
  ped_file = "./example/example.ped",
  fb_file = "./example/example.viterbi",
  output_file = "./example/masked_viterbi.ped",
  num_ancestry = 3,
  ancestry = 1,     # mask ancestry 1
  viterbi = TRUE
)

# -------------------------
# 6. Optional: read results to inspect
# -------------------------
masked_fb <- fread("./example/masked_fb.ped", header = FALSE, data.table = FALSE)
masked_viterbi <- fread("./example/masked_viterbi.ped", header = FALSE, data.table = FALSE)

# Print first few rows
cat("\nMasked PED using Forward-Backward:\n")
print(masked_fb[1:5, ])

cat("\nMasked PED using Viterbi:\n")
print(masked_viterbi[1:5, ])
