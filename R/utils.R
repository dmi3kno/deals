#' Title
#'
#' @param a
#'
#' @return
#' @export
#'
#' @examples
deal_to_df <- function(a, names_to="i"){
  if(is.null(names(a))) names(a) <- paste0("option",seq.int(length(a)))
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
df_to_deal <- function(df, names_from="i"){
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
