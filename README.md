
# Local Ancestry Masking (lamask)

Repository containing the in-house code used to perform local ancestry masking in the study "Indigenous American Genomes Harbor Unique Genetic Diversity and a Complex Evolutionary Past".

DOI: To be updated

Author: Marcos Araújo Castro e Silva

December 16, 2025

---

## Repository Structure

```

.
├── lamask/
│   └── lamask.R          # Function to mask alleles based on ancestry probabilities or Viterbi states
├── generate_data/
│   └── generate_data.R   # Function to generate example MAP, PED, FB, and Viterbi files
├── example/              # Directory where example data and masked outputs are stored
├── run_example_lamask.R  # Example workflow script demonstrating data generation and masking
├── run_iagdp_lamask.R    # Script used for masking the IAGDP data
└── README.md             # This file

```

---

## Overview

The workflow consists of three main steps:

1. **Generate synthetic data** using `generate_data()`.  
   - Produces **MAP**, **PED**, **Forward-Backward**, and **Viterbi** files.  
   - Haplotypes of the same individual mostly share ancestry blocks but allow minor variation.  
   - Forward-Backward probabilities for assigned ancestries are high (0.9–1.0).  

2. **Apply local ancestry masking** using `lamask()`.  
   - Can use either **Forward-Backward probabilities** (with a threshold) or **Viterbi states**.  
   - Masked alleles are replaced with `"0"` in the output PED file.  

3. **Inspect results**.  
   - Masked PED files can be loaded and inspected using standard R functions.

---

## Usage Example

```r
suppressPackageStartupMessages(library(data.table))

# 1. Source lamask function
source("./lamask/lamask.R")

# 2. Source generate_data function
source("./generate_data/generate_data.R")

# 3. Create output directory
system("mkdir -p ./example/")

# 4. Generate example data
example_files <- generate_data(
  n_ind = 5,
  n_snp = 10,
  n_ancestry = 3,
  map_file = "./example/example.map",
  ped_file = "./example/example.ped",
  fb_file = "./example/example.fb",
  viterbi_file = "./example/example.viterbi",
  seed = 42
)

# 5. Mask using Forward-Backward probabilities
lamask(
  map_file = "./example/example.map",
  ped_file = "./example/example.ped",
  fb_file = "./example/example.fb",
  output_file = "./example/masked_fb.ped",
  num_ancestry = 3,
  ancestry = 1,
  threshold = 0.9,
  viterbi = FALSE
)

# 6. Mask using Viterbi states
lamask(
  map_file = "./example/example.map",
  ped_file = "./example/example.ped",
  fb_file = "./example/example.viterbi",
  output_file = "./example/masked_viterbi.ped",
  num_ancestry = 3,
  ancestry = 1,
  viterbi = TRUE
)

# 7. Optional: Inspect masked files
masked_fb <- fread("./example/masked_fb.ped", header = FALSE, data.table = FALSE)
masked_viterbi <- fread("./example/masked_viterbi.ped", header = FALSE, data.table = FALSE)

print(head(masked_fb))
print(head(masked_viterbi))
```

---

## Generated Files

| File                         | Description                                          |
| ---------------------------- | ---------------------------------------------------- |
| `example.map`        | MAP file with SNP positions                          |
| `example.ped`        | PED file with individual genotypes                   |
| `example.fb`         | Forward-Backward probabilities for each haplotype    |
| `example.viterbi`    | Viterbi ancestry states for each haplotype           |
| `masked_fb.ped`      | PED file masked using Forward-Backward probabilities |
| `masked_viterbi.ped` | PED file masked using Viterbi states                 |

---

## Requirements

* R (≥ 4.0 recommended)
* Packages: `data.table`

---

## Notes

* Masking replaces alleles in the PED file with `"0"` based on Forward-Backward ancestry probabilities or Viterbi states.
* The provided `seed` ensures reproducibility of the example data.

---

## License

This code is open source and free to use.
