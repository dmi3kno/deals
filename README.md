
<!-- README.md is generated from README.Rmd. Please edit that file -->

# deals <img src="man/figures/logo.png" align="right" />

<!-- badges: start -->

<!-- badges: end -->

The goal of deals is to faclitiate operations with and presentation of
decisions under uncertainty.

## Installation

You can install the released version of deals from
[Github](https://www.github.com) with:

``` r
remotes::install_github("dmi3kno/deals")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(deals)
## basic example code
```

## Transparent deals

Leland, Schneider, & Wilcox (2019) introduced definition of “transparent
frames” for decisions under uncertainty (hereafter, “deals”). In this
package a `deal` is a list of two dataframes, each with two columns `p`
(probability of a given outcome) and `x` (the outcome itself). Decision
maker is offered a choice between two uncertain prospects and can choose
one of them.

``` r
# Allais paradox
a1 <- list(
  data.frame(
    p=c(0.995, 0.005),
    x=c(5e5, 5), stringsAsFactors = FALSE),
  data.frame(
    p=c(0.1, 0.89, 0.01),
    x=c(2.5e6, 5e5, 0), stringsAsFactors = FALSE)
)
a1
#> [[1]]
#>       p     x
#> 1 0.995 5e+05
#> 2 0.005 5e+00
#> 
#> [[2]]
#>      p       x
#> 1 0.10 2500000
#> 2 0.89  500000
#> 3 0.01       0
deal_is_transparent(a1)
#> [1] FALSE
deal_make_transparent(a1)
#> [[1]]
#>       p     x
#> 1 0.890 5e+05
#> 2 0.100 5e+05
#> 3 0.005 5e+05
#> 4 0.005 5e+00
#> 
#> [[2]]
#>        p       x
#> 1  0.890  500000
#> 3  0.100 2500000
#> 11 0.005       0
#> 2  0.005       0
deal_is_transparent(deal_make_transparent(a1))
#> [1] TRUE

a2 <- list(
  data.frame(
    p=c(0.11,0.89),
    x=c(5e5,0), stringsAsFactors = FALSE),
  data.frame(
    p=c(0.10,0.90),
    x=c(2.5e6,0), stringsAsFactors = FALSE)
)
a2
#> [[1]]
#>      p     x
#> 1 0.11 5e+05
#> 2 0.89 0e+00
#> 
#> [[2]]
#>     p       x
#> 1 0.1 2500000
#> 2 0.9       0
deal_is_transparent(a2)
#> [1] FALSE
deal_make_transparent(a2)
#> [[1]]
#>      p     x
#> 1 0.89 0e+00
#> 2 0.10 5e+05
#> 3 0.01 5e+05
#> 
#> [[2]]
#>       p       x
#> 1  0.89       0
#> 2  0.10 2500000
#> 11 0.01       0
deal_is_transparent(deal_make_transparent(a2))
#> [1] TRUE

a3 <- list(
  data.frame(
    p=c(0.9, 0.06, 0.01, 0.01, 0.02),
    x=c(0,  45, 30, -15, -15), stringsAsFactors = FALSE),
  data.frame(
    p=c(0.9, 0.06, 0.01, 0.01, 0.02),
    x=c(0,  45, 45, -10, -15), stringsAsFactors = FALSE)
)
a3
#> [[1]]
#>      p   x
#> 1 0.90   0
#> 2 0.06  45
#> 3 0.01  30
#> 4 0.01 -15
#> 5 0.02 -15
#> 
#> [[2]]
#>      p   x
#> 1 0.90   0
#> 2 0.06  45
#> 3 0.01  45
#> 4 0.01 -10
#> 5 0.02 -15
# this one is transparent
deal_is_transparent(a3)
#> [1] TRUE
deal_make_transparent(a3)
#> [[1]]
#>      p   x
#> 1 0.90   0
#> 2 0.06  45
#> 3 0.01  30
#> 4 0.01 -15
#> 5 0.02 -15
#> 
#> [[2]]
#>      p   x
#> 1 0.90   0
#> 2 0.06  45
#> 3 0.01  45
#> 4 0.01 -10
#> 5 0.02 -15
deal_is_transparent(deal_make_transparent(a3))
#> [1] TRUE

a4 <- list(
  data.frame(
    p=c(0.9, 0.06, 0.01, 0.03),
    x=c(0,  45, 30, -15), stringsAsFactors = FALSE),
  data.frame(
    p=c(0.9, 0.07, 0.01, 0.02),
    x=c(0,  45, -10, -15), stringsAsFactors = FALSE)
)
a4
#> [[1]]
#>      p   x
#> 1 0.90   0
#> 2 0.06  45
#> 3 0.01  30
#> 4 0.03 -15
#> 
#> [[2]]
#>      p   x
#> 1 0.90   0
#> 2 0.07  45
#> 3 0.01 -10
#> 4 0.02 -15
deal_is_transparent(a4)
#> [1] FALSE
deal_make_transparent(a4)
#> [[1]]
#>       p   x
#> 1  0.90   0
#> 2  0.06  45
#> 3  0.02 -15
#> 31 0.01  30
#> 21 0.00   0
#> 11 0.01 -15
#> 
#> [[2]]
#>       p   x
#> 1  0.90   0
#> 2  0.06  45
#> 3  0.02 -15
#> 4  0.01  45
#> 31 0.00   0
#> 21 0.01 -10
deal_is_transparent(deal_make_transparent(a4))
#> [1] TRUE

a5 <- list(
  data.frame(
    p=c(0.33, 0.66, 0.01),
    x=c(2500,  2400, 0), stringsAsFactors = FALSE),
  data.frame(
    p=c(0.33, 0.66, 0.01),
    x=c(2400,  2400, 2400), stringsAsFactors = FALSE)
)
a5
#> [[1]]
#>      p    x
#> 1 0.33 2500
#> 2 0.66 2400
#> 3 0.01    0
#> 
#> [[2]]
#>      p    x
#> 1 0.33 2400
#> 2 0.66 2400
#> 3 0.01 2400
deal_is_transparent(a5)
#> [1] TRUE
deal_make_transparent(a5)
#> [[1]]
#>      p    x
#> 1 0.33 2500
#> 2 0.66 2400
#> 3 0.01    0
#> 
#> [[2]]
#>      p    x
#> 1 0.33 2400
#> 2 0.66 2400
#> 3 0.01 2400
deal_is_transparent(deal_make_transparent(a5))
#> [1] TRUE

a6 <- list(
  data.frame(
    p=c(0.33, 0.67),
    x=c(2500, 0), stringsAsFactors = FALSE),
  data.frame(
    p=c(0.34, 0.66),
    x=c(2400, 0), stringsAsFactors = FALSE)
)
a6
#> [[1]]
#>      p    x
#> 1 0.33 2500
#> 2 0.67    0
#> 
#> [[2]]
#>      p    x
#> 1 0.34 2400
#> 2 0.66    0
deal_is_transparent(a6)
#> [1] FALSE
deal_make_transparent(a6)
#> [[1]]
#>       p    x
#> 1  0.66    0
#> 2  0.33 2500
#> 11 0.01    0
#> 
#> [[2]]
#>      p    x
#> 1 0.66    0
#> 2 0.33 2400
#> 3 0.01 2400
deal_is_transparent(deal_make_transparent(a6))
#> [1] TRUE

a7 <- list(
  data.frame(
    p=c(0.8, 0.2),
    x=c(4000, 0), stringsAsFactors=FALSE),
  data.frame(
    p=c(0.8, 0.2),
    x=c(3000,3000),stringsAsFactors = FALSE)
)
a7
#> [[1]]
#>     p    x
#> 1 0.8 4000
#> 2 0.2    0
#> 
#> [[2]]
#>     p    x
#> 1 0.8 3000
#> 2 0.2 3000
deal_is_transparent(a7)
#> [1] TRUE
deal_make_transparent(a7)
#> [[1]]
#>     p    x
#> 1 0.8 4000
#> 2 0.2    0
#> 
#> [[2]]
#>     p    x
#> 1 0.8 3000
#> 2 0.2 3000
deal_is_transparent(deal_make_transparent(a7))
#> [1] TRUE


a8 <- list(
  data.frame(
    p=c(0.2, 0.8),
    x=c(4000, 0), stringsAsFactors=FALSE),
  data.frame(
    p=c(0.25, 0.75),
    x=c(3000, 0),stringsAsFactors = FALSE)
)
a8
#> [[1]]
#>     p    x
#> 1 0.2 4000
#> 2 0.8    0
#> 
#> [[2]]
#>      p    x
#> 1 0.25 3000
#> 2 0.75    0
deal_is_transparent(a8)
#> [1] FALSE
deal_make_transparent(a8)
#> [[1]]
#>       p    x
#> 1  0.75    0
#> 2  0.20 4000
#> 11 0.05    0
#> 
#> [[2]]
#>      p    x
#> 1 0.75    0
#> 2 0.20 3000
#> 3 0.05 3000
deal_is_transparent(deal_make_transparent(a8))
#> [1] TRUE

a9r <- list(
  data.frame(
    p=c(0.1, 0.9),
    x=c(8, 0), stringsAsFactors=FALSE),
  data.frame(
    p=c(0.05, 0.95),
    x=c(20, 0),stringsAsFactors = FALSE)
)
a9r
#> [[1]]
#>     p x
#> 1 0.1 8
#> 2 0.9 0
#> 
#> [[2]]
#>      p  x
#> 1 0.05 20
#> 2 0.95  0
deal_is_transparent(a9r)
#> [1] FALSE
deal_make_transparent(a9r)
#> [[1]]
#>      p x
#> 1 0.90 0
#> 2 0.05 8
#> 3 0.05 8
#> 
#> [[2]]
#>       p  x
#> 1  0.90  0
#> 2  0.05 20
#> 11 0.05  0
deal_is_transparent(deal_make_transparent(a9r))
#> [1] TRUE

a9b <- list(
  data.frame(
    p=c(0.6, 0.4),
    x=c(8, 0), stringsAsFactors=FALSE),
  data.frame(
    p=c(0.3, 0.7),
    x=c(20, 0),stringsAsFactors = FALSE)
)
a9b
#> [[1]]
#>     p x
#> 1 0.6 8
#> 2 0.4 0
#> 
#> [[2]]
#>     p  x
#> 1 0.3 20
#> 2 0.7  0
deal_is_transparent(a9b)
#> [1] FALSE
deal_make_transparent(a9b)
#> [[1]]
#>     p x
#> 1 0.4 0
#> 2 0.3 8
#> 3 0.3 8
#> 
#> [[2]]
#>      p  x
#> 1  0.4  0
#> 2  0.3 20
#> 11 0.3  0
deal_is_transparent(deal_make_transparent(a9b))
#> [1] TRUE
```

References: Leland, J. W., Schneider, M., & Wilcox, N. T. (2019).
Minimal Frames and Transparent Frames for Risk, Time, and Uncertainty.
Management Science.
