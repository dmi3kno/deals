
<!-- README.md is generated from README.Rmd. Please edit that file -->

# deals <img src="man/figures/logo.png" align="right" />

<!-- badges: start -->

<!-- badges: end -->

The purpose of `deals` is to faclitiate operations with and presentation
of decisions under uncertainty.

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
library(magrittr)
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
    x=c(5e5), 
    p=c(1),
    stringsAsFactors = FALSE),
  data.frame(
    x=c(2.5e6, 5e5, 0), 
    p=c(0.1, 0.89, 0.01),
    stringsAsFactors = FALSE)
)

a1 %>% 
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL)
```

|     |         |                    |     |           |                       |
| :-- | :------ | :----------------- | :-- | :-------- | :-------------------- |
| G1: | 500,000 | with probability 1 | G2: | 2,500,000 | with probability 0.10 |
|     |         |                    |     | 500,000   | with probability 0.89 |
|     |         |                    |     | 0         | with probability 0.01 |

``` r

deal_is_transparent(a1)
#> [1] FALSE

deal_make_transparent(a1) %>% 
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL) 
```

|     |         |                       |     |           |                       |
| :-- | :------ | :-------------------- | :-- | :-------- | :-------------------- |
| G1: | 500,000 | with probability 0.89 | G2: | 500,000   | with probability 0.89 |
|     | 500,000 | with probability 0.10 |     | 2,500,000 | with probability 0.10 |
|     | 500,000 | with probability 0.01 |     | 0         | with probability 0.01 |

``` r

deal_is_transparent(deal_make_transparent(a1))
#> [1] TRUE
```

``` r
a2 <- list(
  data.frame(
    x=c(5e5,0), 
    p=c(0.11,0.89),
    stringsAsFactors = FALSE),
  data.frame(
    x=c(2.5e6,0), 
    p=c(0.10,0.90),
    stringsAsFactors = FALSE)
)
a2 %>% 
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL) 
```

|     |         |                       |     |           |                      |
| :-- | :------ | :-------------------- | :-- | :-------- | :------------------- |
| G1: | 500,000 | with probability 0.11 | G2: | 2,500,000 | with probability 0.1 |
|     | 0       | with probability 0.89 |     | 0         | with probability 0.9 |

``` r

deal_is_transparent(a2)
#> [1] FALSE

deal_make_transparent(a2) %>% 
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL) 
```

|     |         |                       |     |           |                       |
| :-- | :------ | :-------------------- | :-- | :-------- | :-------------------- |
| G1: | 0       | with probability 0.89 | G2: | 0         | with probability 0.89 |
|     | 500,000 | with probability 0.10 |     | 2,500,000 | with probability 0.10 |
|     | 500,000 | with probability 0.01 |     | 0         | with probability 0.01 |

``` r

deal_is_transparent(deal_make_transparent(a2))
#> [1] TRUE
```

``` r
a3 <- list(
  data.frame(
    x=c(0,  45, 30, -15, -15), 
    p=c(0.9, 0.06, 0.01, 0.01, 0.02),
    stringsAsFactors = FALSE),
  data.frame(
    x=c(0,  45, 45, -10, -15), 
    p=c(0.9, 0.06, 0.01, 0.01, 0.02),
    stringsAsFactors = FALSE)
)

a3 %>% 
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL) 
```

|     |      |                       |     |      |                       |
| :-- | :--- | :-------------------- | :-- | :--- | :-------------------- |
| G1: | 0    | with probability 0.90 | G2: | 0    | with probability 0.90 |
|     | 45   | with probability 0.06 |     | 45   | with probability 0.06 |
|     | 30   | with probability 0.01 |     | 45   | with probability 0.01 |
|     | \-15 | with probability 0.01 |     | \-10 | with probability 0.01 |
|     | \-15 | with probability 0.02 |     | \-15 | with probability 0.02 |

``` r

# this one is transparent
deal_is_transparent(a3)
#> [1] TRUE

deal_make_transparent(a3) %>% 
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL) 
```

|     |      |                       |     |      |                       |
| :-- | :--- | :-------------------- | :-- | :--- | :-------------------- |
| G1: | 0    | with probability 0.90 | G2: | 0    | with probability 0.90 |
|     | 45   | with probability 0.06 |     | 45   | with probability 0.06 |
|     | 30   | with probability 0.01 |     | 45   | with probability 0.01 |
|     | \-15 | with probability 0.01 |     | \-10 | with probability 0.01 |
|     | \-15 | with probability 0.02 |     | \-15 | with probability 0.02 |

``` r

deal_is_transparent(deal_make_transparent(a3))
#> [1] TRUE
```

``` r
a4 <- list(
  data.frame(
    x=c(0,  45, 30, -15), 
    p=c(0.9, 0.06, 0.01, 0.03),
    stringsAsFactors = FALSE),
  data.frame(
    x=c(0,  45, -10, -15), 
    p=c(0.9, 0.07, 0.01, 0.02),
    stringsAsFactors = FALSE)
)
a4 %>% 
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL) 
```

|     |      |                       |     |      |                       |
| :-- | :--- | :-------------------- | :-- | :--- | :-------------------- |
| G1: | 0    | with probability 0.90 | G2: | 0    | with probability 0.90 |
|     | 45   | with probability 0.06 |     | 45   | with probability 0.07 |
|     | 30   | with probability 0.01 |     | \-10 | with probability 0.01 |
|     | \-15 | with probability 0.03 |     | \-15 | with probability 0.02 |

``` r

deal_is_transparent(a4)
#> [1] FALSE

deal_make_transparent(a4) %>% 
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL) 
```

|     |      |                       |     |      |                       |
| :-- | :--- | :-------------------- | :-- | :--- | :-------------------- |
| G1: | 0    | with probability 0.90 | G2: | 0    | with probability 0.90 |
|     | 45   | with probability 0.06 |     | 45   | with probability 0.06 |
|     | \-15 | with probability 0.02 |     | \-15 | with probability 0.02 |
|     | 30   | with probability 0.01 |     | 45   | with probability 0.01 |
|     | 0    | with probability 0.00 |     | 0    | with probability 0.00 |
|     | \-15 | with probability 0.01 |     | \-10 | with probability 0.01 |

``` r

deal_is_transparent(deal_make_transparent(a4))
#> [1] TRUE
```

``` r
a5 <- list(
  data.frame(
    x=c(2500,  2400, 0), 
    p=c(0.33, 0.66, 0.01),
    stringsAsFactors = FALSE),
  data.frame(
    x=c(2400,  2400, 2400), 
    p=c(0.33, 0.66, 0.01),
    stringsAsFactors = FALSE)
)
a5 %>% 
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL) 
```

|     |       |                       |     |       |                       |
| :-- | :---- | :-------------------- | :-- | :---- | :-------------------- |
| G1: | 2,500 | with probability 0.33 | G2: | 2,400 | with probability 0.33 |
|     | 2,400 | with probability 0.66 |     | 2,400 | with probability 0.66 |
|     | 0     | with probability 0.01 |     | 2,400 | with probability 0.01 |

``` r

deal_is_transparent(a5)
#> [1] TRUE
deal_make_transparent(a5) %>% 
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL) 
```

|     |       |                       |     |       |                       |
| :-- | :---- | :-------------------- | :-- | :---- | :-------------------- |
| G1: | 2,500 | with probability 0.33 | G2: | 2,400 | with probability 0.33 |
|     | 2,400 | with probability 0.66 |     | 2,400 | with probability 0.66 |
|     | 0     | with probability 0.01 |     | 2,400 | with probability 0.01 |

``` r

deal_is_transparent(deal_make_transparent(a5))
#> [1] TRUE
```

``` r
a6 <- list(
  data.frame(
    x=c(2500, 0), 
    p=c(0.33, 0.67),
    stringsAsFactors = FALSE),
  data.frame(
    x=c(2400, 0), 
    p=c(0.34, 0.66),
    stringsAsFactors = FALSE)
)
a6 %>% 
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL) 
```

|     |       |                       |     |       |                       |
| :-- | :---- | :-------------------- | :-- | :---- | :-------------------- |
| G1: | 2,500 | with probability 0.33 | G2: | 2,400 | with probability 0.34 |
|     | 0     | with probability 0.67 |     | 0     | with probability 0.66 |

``` r

deal_is_transparent(a6)
#> [1] FALSE

deal_make_transparent(a6) %>% 
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL) 
```

|     |       |                       |     |       |                       |
| :-- | :---- | :-------------------- | :-- | :---- | :-------------------- |
| G1: | 0     | with probability 0.66 | G2: | 0     | with probability 0.66 |
|     | 2,500 | with probability 0.33 |     | 2,400 | with probability 0.33 |
|     | 0     | with probability 0.01 |     | 2,400 | with probability 0.01 |

``` r

deal_is_transparent(deal_make_transparent(a6))
#> [1] TRUE
```

The following pair of deals constitute Allais Paradox. Second deal is
proportionate copy of the first one.

``` r
a7 <- list(
  data.frame(
    x=c(4000, 0), 
    p=c(0.8, 0.2),
    stringsAsFactors=FALSE),
  data.frame(
    x=c(3000), 
    p=c(1),
    stringsAsFactors = FALSE)
)
a7 %>% 
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL) 
```

|     |       |                      |     |       |                    |
| :-- | :---- | :------------------- | :-- | :---- | :----------------- |
| G1: | 4,000 | with probability 0.8 | G2: | 3,000 | with probability 1 |
|     | 0     | with probability 0.2 |     |       |                    |

``` r

deal_is_transparent(a7)
#> [1] FALSE

deal_make_transparent(a7) %>% 
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL) 
```

|     |       |                      |     |       |                      |
| :-- | :---- | :------------------- | :-- | :---- | :------------------- |
| G1: | 0     | with probability 0.2 | G2: | 3,000 | with probability 0.2 |
|     | 4,000 | with probability 0.8 |     | 3,000 | with probability 0.8 |

``` r

deal_is_transparent(deal_make_transparent(a7))
#> [1] TRUE
```

``` r
a8 <- list(
  data.frame(
    x=c(4000, 0), 
    p=c(0.2, 0.8),
    stringsAsFactors=FALSE),
  data.frame(
    x=c(3000, 0), 
    p=c(0.25, 0.75),
    stringsAsFactors = FALSE)
)
a8 %>% 
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL) 
```

|     |       |                      |     |       |                       |
| :-- | :---- | :------------------- | :-- | :---- | :-------------------- |
| G1: | 4,000 | with probability 0.2 | G2: | 3,000 | with probability 0.25 |
|     | 0     | with probability 0.8 |     | 0     | with probability 0.75 |

``` r

deal_is_transparent(a8)
#> [1] FALSE

deal_make_transparent(a8) %>% 
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL) 
```

|     |       |                       |     |       |                       |
| :-- | :---- | :-------------------- | :-- | :---- | :-------------------- |
| G1: | 0     | with probability 0.75 | G2: | 0     | with probability 0.75 |
|     | 4,000 | with probability 0.20 |     | 3,000 | with probability 0.20 |
|     | 0     | with probability 0.05 |     | 3,000 | with probability 0.05 |

``` r

deal_is_transparent(deal_make_transparent(a8))
#> [1] TRUE
```

The following pair of deals exemplify Ellsberg Paradox.

``` r
a9r <- list(
  data.frame(
    x=c(8, 0), 
    p=c(0.1, 0.9),
    stringsAsFactors=FALSE),
  data.frame(
    x=c(20, 0),
    p=c(0.05, 0.95),
    stringsAsFactors = FALSE)
)
a9r %>%
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL) 
```

|     |   |                      |     |    |                       |
| :-- | :- | :------------------- | :-- | :- | :-------------------- |
| G1: | 8 | with probability 0.1 | G2: | 20 | with probability 0.05 |
|     | 0 | with probability 0.9 |     | 0  | with probability 0.95 |

``` r

deal_is_transparent(a9r)
#> [1] FALSE

deal_make_transparent(a9r) %>% 
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL) 
```

|     |   |                       |     |    |                       |
| :-- | :- | :-------------------- | :-- | :- | :-------------------- |
| G1: | 0 | with probability 0.90 | G2: | 0  | with probability 0.90 |
|     | 8 | with probability 0.05 |     | 20 | with probability 0.05 |
|     | 8 | with probability 0.05 |     | 0  | with probability 0.05 |

``` r

deal_is_transparent(deal_make_transparent(a9r))
#> [1] TRUE

a9b <- list(
  data.frame(
    x=c(8, 0), 
    p=c(0.6, 0.4),
    stringsAsFactors=FALSE),
  data.frame(
    x=c(20, 0),
    p=c(0.3, 0.7),
    stringsAsFactors = FALSE)
)
a9b %>% 
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL) 
```

|     |   |                      |     |    |                      |
| :-- | :- | :------------------- | :-- | :- | :------------------- |
| G1: | 8 | with probability 0.6 | G2: | 20 | with probability 0.3 |
|     | 0 | with probability 0.4 |     | 0  | with probability 0.7 |

``` r

deal_is_transparent(a9b)
#> [1] FALSE

deal_make_transparent(a9b) %>% 
  deal_to_textdf() %>% 
  knitr::kable(col.names = NULL) 
```

|     |   |                      |     |    |                      |
| :-- | :- | :------------------- | :-- | :- | :------------------- |
| G1: | 0 | with probability 0.4 | G2: | 0  | with probability 0.4 |
|     | 8 | with probability 0.3 |     | 20 | with probability 0.3 |
|     | 8 | with probability 0.3 |     | 0  | with probability 0.3 |

``` r

deal_is_transparent(deal_make_transparent(a9b))
#> [1] TRUE
```

References:

Leland, J. W., Schneider, M., & Wilcox, N. T. (2019). Minimal Frames and
Transparent Frames for Risk, Time, and Uncertainty. Management Science.

Stochastic dominance:
<http://nejchladnik.com/blog/2015/11/14/the-concept-of-stochastic-dominance/>
