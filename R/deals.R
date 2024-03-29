#' Check if the deal is transparent
#'
#' @param a deal to check
#'
#' @return logical value of whether the deal is transparent
#'
#' @examples
#' a <- list(
#'   data.frame(
#'    x=c(5e5),
#'    p=c(1)),
#'   data.frame(
#'    x=c(2.5e6, 5e5, 0),
#'    p=c(0.1, 0.89, 0.01))
#' )
#'
#' deal_is_transparent(a)
#' @importFrom stats aggregate complete.cases reshape
#' @export
deal_is_transparent <- function(a){

  max_p_decimalplaces <- max(get_decimalplaces(Reduce(c, lapply(a, `[[`, "p"))), na.rm = TRUE)
  ar <- lapply(a, function(x) {x[["p"]] <- round(x[["p"]], max_p_decimalplaces); x})
  df <- deal_to_df(ar)
  df$v <- 1
  df <- unique(df)
  dfr <- reshape(df, direction = "wide", idvar = c("x", "p"), timevar = "g")
  dfr <- dfr[!complete.cases(dfr),]
  dfr[is.na(dfr)] <- 0
  dfra <- stats::aggregate(p~., data=dfr, FUN="sum")

  ps <- lapply(ar, `[[`, "p")
  xs <- lapply(ar, `[[`, "x")

  Reduce(identical, lapply(ps, length)) &
  Reduce(identical, lapply(ps, sort)) &
  sum(duplicated(dfra[["x"]]))==0
}

#' Make the deal transparent
#'
#' @param a deal
#'
#' @return transparent deal
#'
#' @examples
#' a <- list(
#'   data.frame(
#'    x=c(5e5),
#'    p=c(1)),
#'   data.frame(
#'    x=c(2.5e6, 5e5, 0),
#'    p=c(0.1, 0.89, 0.01))
#' )
#'
#' deal_make_transparent(a)
#'
#' @importFrom utils head tail
#' @export
deal_make_transparent <- function(a){

  stopifnot(is_deal(a))

  if(deal_is_transparent(a)) return(a)

  max_p_decimalplaces <- max(get_decimalplaces(Reduce(c, lapply(a, `[[`, "p"))), na.rm = TRUE)
  max_x_decimalplaces <- max(get_decimalplaces(Reduce(c, lapply(a, `[[`, "x"))), na.rm = TRUE)

  a_compacted <- deal_compact(a)
  unmatched_dfs <- a_compacted
  matched_df <- NULL
  ax_intersected <- intersect(a[[1]][["x"]], a[[2]][["x"]])
  if(length(ax_intersected)>0){
    match_indices <- lapply(a_compacted, function(i) match(ax_intersected, i$x))
    matched <- mapply(function(df, i){df[i,]}, a_compacted, match_indices, SIMPLIFY = FALSE)
    unmatched <-mapply(function(df, i){df[-i,]}, a_compacted, match_indices, SIMPLIFY = FALSE)
    p_new <- round(matched[[1]][["p"]] - matched[[2]][["p"]], max_p_decimalplaces)

    matched_df <- data.frame(x=matched[[1]][["x"]],
                             p=pmin(matched[[1]][["p"]], matched[[2]][["p"]]))

    matched[[1]][["p"]] <- p_new
    matched[[2]][["p"]] <- -p_new
    unmatched_dfs <- mapply(rbind, matched, unmatched, SIMPLIFY = FALSE)
    unmatched_dfs <- lapply(unmatched_dfs, function(df) df[df$p>=0,] )
    unmatched_dfs <- lapply(unmatched_dfs, function(df) df[order(df$x, decreasing = TRUE),] )
  }
  i <- 1
  theres_more <- TRUE
  while(theres_more){
    headers_lst <- lapply(unmatched_dfs, head, i-1)
    footers_lst <- lapply(unmatched_dfs, tail, -i)

    targets_lst <- lapply(unmatched_dfs, function(x){tgt <- x[i, ]
                          tgt[is.na(tgt)] <- 0
                          tgt} )

    p_diff <-targets_lst[[1]][["p"]] - targets_lst[[2]][["p"]]
    p_diff <- round(p_diff, get_decimalplaces(p_diff))

    if(abs(p_diff)>0){
      if(p_diff>0){
        targets_lst[[1]] <- data.frame(x=rep.int(unmatched_dfs[[1]][["x"]][i],2),
                                       p=round(c(unmatched_dfs[[2]][["p"]][i], p_diff), max_p_decimalplaces),
                                       stringsAsFactors = FALSE)
      } else {
        targets_lst[[2]] <- data.frame(x=rep.int(unmatched_dfs[[2]][["x"]][i],2),
                                       p=round(c(unmatched_dfs[[1]][["p"]][i], -p_diff), max_p_decimalplaces),
                                       stringsAsFactors = FALSE)
      }
    }
    unmatched_dfs <- mapply(rbind, headers_lst, targets_lst, footers_lst, SIMPLIFY = FALSE)


    theres_more <- nrow(unmatched_dfs[[1]])>i || nrow(unmatched_dfs[[2]])>i
    i <- i+1
  }  # end while

  lapply(unmatched_dfs, function(x) rbind(matched_df, x)[, c("x", "p")])
}

#' Convert deal to dataframe for pretty printing
#'
#' @param a deal
#' @param big.mark thousand separator. Default is comma.
#'
#' @return dataframe with 2 pairs of 3 columns: gamble number, outcome and corresponding probability
#'
#' @examples
#' a <- list(
#'   data.frame(
#'    x=c(5e5),
#'    p=c(1)),
#'   data.frame(
#'    x=c(2.5e6, 5e5, 0),
#'    p=c(0.1, 0.89, 0.01))
#' )
#'
#' deal_to_textdf(a)
#'
#' @export
deal_to_textdf <- function(a, big.mark=","){
  maxrow <- Reduce(max, lapply(a, nrow))
  ar <- lapply(a, function(df){df[[".rownum"]] <- seq.int(nrow(df));df})
  rowidx <- data.frame(.rownum=seq.int(maxrow))
  gidx <- data.frame(.rownum=1L, g="G", stringsAsFactors = FALSE)
  ar <- lapply(ar, merge, rowidx, all.y=TRUE, by=".rownum")
  ar <- lapply(ar, merge, gidx, all.x=TRUE, by=".rownum")
  ar <- mapply(function(df, i){
    df[["g"]] <- ifelse(is.na(df[["g"]]),"",
                        paste0(df[["g"]], i, ":")); df},
    ar, seq.int(length(ar)), SIMPLIFY = FALSE)
  ar <- lapply(ar, function(df){
    df[["p"]] <- ifelse(is.na(df[["p"]]), "",
                        paste("with probability", as_pretty_char(df[["p"]],big.mark=big.mark)));
    df[["x"]] <- ifelse(is.na(df[["x"]]), "",
                        as_pretty_char(df[["x"]], big.mark=big.mark));
    df[,c(".rownum", "g", "x", "p")]})
  ar
  pretty_df <- Reduce(function(x,y) merge(x,y, all=TRUE, by=".rownum"), ar)
  pretty_df[,!(names(pretty_df)==".rownum")]
}

