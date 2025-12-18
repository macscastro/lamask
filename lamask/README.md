# lamask

`lamask` is an R function for masking genotypes in PED files based on ancestry probabilities from Forward-Backward or Viterbi outputs. It allows masking alleles below a given ancestry probability threshold or that do not match a specific ancestry state, producing a new PED file suitable for downstream analyses.

---

## Features

- Works with standard PLINK MAP and PED files.
- Supports Forward-Backward (probabilistic) or Viterbi (deterministic) ancestry outputs.
- Allows masking alleles based on a probability threshold.
- Handles multiple ancestries and subsets the ancestry of interest.
- Produces masked PED files with alleles replaced by "0".

---

## Requirements

- R ≥ 4.0
- `data.table` package

```r
install.packages("data.table")
```

---

## Function Signature

```r
lamask(
  map_file,
  ped_file,
  fb_file,
  output_file,
  num_ancestry = 3,
  ancestry = 1,
  threshold = 0.99,
  viterbi = FALSE
)
```

### Parameters

| Parameter      | Type    | Description                                                                 |
| -------------- | ------- | --------------------------------------------------------------------------- |
| `map_file`     | string  | Path to the MAP file.                                                       |
| `ped_file`     | string  | Path to the PED file.                                                       |
| `fb_file`      | string  | Path to the Forward-Backward or Viterbi file.                               |
| `output_file`  | string  | Path for the masked output PED file.                                        |
| `num_ancestry` | integer | Total number of ancestries in the Forward-Backward file (default: 3).       |
| `ancestry`     | integer | Ancestry to mask or extract (default: 1).                                   |
| `threshold`    | numeric | Probability threshold for masking in Forward-Backward mode (default: 0.99). |
| `viterbi`      | logical | Use Viterbi input instead of Forward-Backward (default: FALSE).            |

---

## Usage Example

```r
library(data.table)

source("scripts/lamask.R")

# Mask alleles for ancestry 1 using Forward-Backward probabilities
lamask(
  map_file = "example.map",
  ped_file = "example.ped",
  fb_file = "example.fb",
  output_file = "masked.ped",
  num_ancestry = 3,
  ancestry = 1,
  threshold = 0.99,
  viterbi = FALSE
)

# Mask using Viterbi ancestry states
lamask(
  map_file = "example.map",
  ped_file = "example.ped",
  fb_file = "example.viterbi",
  output_file = "masked_viterbi.ped",
  num_ancestry = 3,
  ancestry = 1,
  viterbi = TRUE
)
```

---

## Details

1. **Read MAP and PED files**: Verifies that PED genotype columns match the number of SNPs.
2. **Read Forward-Backward or Viterbi file**: Checks for compatibility with PED file.
3. **Subset ancestry columns** (Forward-Backward only).
4. **Build haplotype mask** based on threshold (FB) or ancestry state (Viterbi).
5. **Expand mask** to the allele level.
6. **Extract genotypes** from the PED file.
7. **Apply mask**: Replace masked alleles with `"0"`.
8. **Rebuild PED file** including masked genotypes.
9. **Write output** to file.

---

## Notes

* The output PED file preserves the original structure but with masked alleles replaced by `"0"`.
* Ensure that Forward-Backward or Viterbi outputs correspond exactly to the individuals and SNPs in the PED/MAP files.

---

## License

This code is open source and free to use.

