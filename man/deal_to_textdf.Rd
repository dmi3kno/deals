% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/deals.R
\name{deal_to_textdf}
\alias{deal_to_textdf}
\title{Convert deal to dataframe for pretty printing}
\usage{
deal_to_textdf(a, big.mark = ",")
}
\arguments{
\item{a}{deal}

\item{big.mark}{thousand separator. Default is comma.}
}
\value{
dataframe with 2 pairs of 3 columns: gamble number, outcome and corresponding probability
}
\description{
Convert deal to dataframe for pretty printing
}
\examples{
a <- list(
  data.frame(
   x=c(5e5),
   p=c(1)),
  data.frame(
   x=c(2.5e6, 5e5, 0),
   p=c(0.1, 0.89, 0.01))
)

deal_to_textdf(a)

}
