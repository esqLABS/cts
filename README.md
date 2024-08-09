
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cts

<!-- badges: start -->
<!-- badges: end -->

The goal of cts is to …

## Installation

You can install the development version of cts from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("esqLABS/cts")
```

## Example

### List available compounds building blocks

``` r
library(cts)

# List available compounds building blocks
list_compounds()
```

### Import compound snapshot

#### From OSP qualified building blocks

``` r
rifampicin <- compound("Rifampicin")

midazolam <- compound("Midazolam")
```

#### From URL

``` r
compound("https://raw.githubusercontent.com/Open-Systems-Pharmacology/Alfentanil-Model/v2.2/Alfentanil-Model.json")
```

#### From File

``` r
compound("path/to/Alfentanil-Model.json")
```

### Explore Compound

``` r
rifampicin$Formulations
#> [[1]]
#> [[1]]$Name
#> [1] "Oral solution"
#> 
#> [[1]]$FormulationType
#> [1] "Formulation_Dissolved"
```
