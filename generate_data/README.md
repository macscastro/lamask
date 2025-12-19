# generate_data

`generate_data` is an R function to generate synthetic example files for testing local ancestry masking workflows. It creates **PED, MAP, Forward-Backward (FB), and Viterbi files** for a specified number of individuals, SNPs, and ancestries. The files are coherent: the Viterbi states match the haplotype with the highest probability in the Forward-Backward matrix, and haplotypes within the same individual mostly share ancestry blocks.

---

## Features

- Generates example **MAP**, **PED**, **Forward-Backward**, and **Viterbi** files.
- Supports any number of **individuals**, **SNPs**, and **ancestries**.
- Forward-Backward probabilities are mostly high (0.9–1.0) for the assigned ancestry.
- Haplotypes of the same individual mostly share ancestry, with optional minor variation.
- Viterbi states automatically correspond to the highest probability ancestry for each haplotype (from the Forward-Backward probabilities).

---

## Function Signature

```r
generate_data(
  n_ind = 5,
  n_snp = 10,
  n_ancestry = 3,
  map_file = "example.map",
  ped_file = "example.ped",
  fb_file = "example.fb",
  viterbi_file = "example.viterbi"
)
```

### Arguments

| Argument       | Type   | Description                                                              |
| -------------- | ------ | ------------------------------------------------------------------------ |
| `n_ind`        | int    | Number of individuals to simulate (default: 5).                          |
| `n_snp`        | int    | Number of SNPs (genetic positions) to simulate (default: 10).            |
| `n_ancestry`   | int    | Number of ancestries to simulate (default: 3).                           |
| `map_file`     | string | Output filename for the MAP file (default: `"example.map"`).             |
| `ped_file`     | string | Output filename for the PED file (default: `"example.ped"`).             |
| `fb_file`      | string | Output filename for the Forward-Backward file (default: `"example.fb"`). |
| `viterbi_file` | string | Output filename for the Viterbi file (default: `"example.viterbi"`).     |

### Returns

* Invisibly returns a list with four data frames:

  * `map` – the MAP file content
  * `ped` – the PED file content
  * `fb` – the Forward-Backward matrix
  * `viterbi` – the Viterbi matrix

---

## Example Usage

```r
# Load required library
library(data.table)

# Generate example data for 5 individuals, 10 SNPs, 3 ancestries
example_files <- generate_data(
  n_ind = 5,
  n_snp = 10,
  n_ancestry = 3,
  map_file = "example.map",
  ped_file = "example.ped",
  fb_file = "example.fb",
  viterbi_file = "example.viterbi"
)

# Access returned data frames inside R (please note data is also written to disk)
map_df <- example_files$map
ped_df <- example_files$ped
fb_df <- example_files$fb
viterbi_df <- example_files$viterbi
```

---

## Notes

* The function ensures that **Viterbi states match the maximum probability ancestry** in the Forward-Backward file.
* Haplotypes of the same individual share most of their ancestry assignments, but with **minor variation** to simulate recombination.
* Forward-Backward probabilities for the assigned ancestry are mostly high (0.9–1.0) to allow testing of more realistic masking thresholds.
* PED alleles are randomly generated and do not necessarily correspond to ancestry-specific alleles.

---

## Example Files Generated

| File              | Description                                            |
| ----------------- | ------------------------------------------------------ |
| `example.map`     | MAP file with SNP positions.                           |
| `example.ped`     | PED file with individual genotypes.                    |
| `example.fb`      | Forward-Backward probabilities for each haplotype.     |
| `example.viterbi` | Viterbi states for each haplotype, matching FB maxima. |

---

## License

This code is open source and free to use.

