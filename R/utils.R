#' Title
#'
#' @param a
#'
#' @return
#' @export
#'
#' @examples
deal_to_df <- function(a, names_to="g"){
  if(is.null(names(a))) names(a) <- paste0("G",seq.int(length(a)))
  lst <- mapply(function(df, i) {df[[names_to]] <- i; df}, a, names(a), SIMPLIFY = FALSE)
  Reduce(rbind, lst)
}

#' Title
#'
#' @param a
#'
#' @return
#' @export
#'
#' @examples
df_to_deal <- function(df, names_from="g"){
  split(df[, setdiff(names(df), names_from)], df[[names_from]])
}

#' Title
#'
#' @param a
#'
#' @return
#' @export
#'
#' @examples
is_deal <- function(a){
  is.list(a) &&
    Reduce(identical, lapply(lapply(a, names), sort)) &&
    identical(sort(names(a[[1]])), c("p", "x")) &&
    Reduce(identical, lapply(lapply(a, `[[`, "p"), sum))
}

#' Title
#'
#' @param a
#'
#' @return
#' @export
#'
#' @examples
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


