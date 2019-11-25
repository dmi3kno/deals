#' Convert deal to dataframe representation
#'
#' @param a deal
#' @param names_to column name for placing gamble identifiers
#'
#' @return dataframe with 3 columns: gamble number, outcome and corresponding probability.
#'
#' @examples
#'
#' a <- list(
#'   data.frame(
#'     x=c(5e5,0),
#'     p=c(0.11,0.89)),
#'   data.frame(
#'     x=c(2.5e6,0),
#'     p=c(0.10,0.90))
#' )
#'
#' deal_to_df(a)
#'
#' @export
deal_to_df <- function(a, names_to="g"){
  if(is.null(names(a))) names(a) <- paste0("G",seq.int(length(a)))
  lst <- mapply(function(df, i) {df[[names_to]] <- i; df}, a, names(a), SIMPLIFY = FALSE)
  Reduce(rbind, lst)
}

#' Convert data frame to deal
#'
#' @param df data frame of 3 columns: gamble id, outcome `x` and corresponding probability `p`
#' @param names_from character name of the column, containing gamble id. If missing, it will be a first column other than `p` and `x`
#'
#' @return deal
#'
#' @examples
#' df <- data.frame(g=c("G1","G2","G2"),
#'                  x=c(100, 200, 50),
#'                  p=c(1, 0.5, 0.5)
#' )
#' df_to_deal(df)
#'
#' @export
df_to_deal <- function(df, names_from=NULL){
  if(is.null(names_from)) names_from <- setdiff(names(df), c("p", "x"))[1]
  split(df[, setdiff(names(df), names_from)], df[[names_from]])
}

#' Check if the object is a valid deal
#'
#' @param a list
#'
#' @return logical value for whether a list is a deal
#'
#' @examples
#' a <- list(
#'   data.frame(
#'     x=c(2500, 0),
#'     p=c(0.33, 0.67)),
#'   data.frame(
#'     x=c(2400, 0),
#'     p=c(0.34, 0.66))
#' )
#'
#' is_deal(a)
#'
#' @export
is_deal <- function(a){
  is.list(a) &&
    Reduce(identical, lapply(lapply(a, names), sort)) &&
    identical(sort(names(a[[1]])), c("p", "x")) &&
    Reduce(identical, lapply(lapply(a, `[[`, "p"), sum))
}

#' Compact the deal
#'
#' @param a deal
#'
#' @return "compacted" deal, i.e. deal with distinct outcomes
#'
#' @examples
#'
#' a <- list(
#'   data.frame(
#'     x=c(2500,  2400, 0),
#'     p=c(0.33, 0.66, 0.01)),
#'   data.frame(
#'     x=c(2400,  2400, 2400),
#'     p=c(0.33, 0.66, 0.01))
#' )
#'
#' deal_compact(a)
#'
#' @importFrom stats aggregate
#' @export
deal_compact <- function(a){
  lapply(a, function(i) aggregate(p~x, data=i, FUN=sum))
}


get_decimalplaces <- function(x){
  ifelse(abs(x - round(x)) > .Machine$double.eps^0.5,
         nchar(sub('^\\d+\\.', '', sub('0+$', '', as.character(x)))),
         0)
}

as_pretty_char <- function(x, big.mark=",") {
  s <-get_decimalplaces(x)
  ms <-max(s, na.rm = TRUE)
  trimws(format(round(x, ms), nsmall=ms, big.mark=big.mark, scientific = FALSE))
}


