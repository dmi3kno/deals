
#' Title
#'
#' @param a
#'
#' @return
#' @export
#'
#' @examples
deal_is_transparent <- function(a, precision=6){
  ar <- lapply(a, function(x) {x[["p"]] <- round(x[["p"]], precision); x})
  df <- deal_to_df(ar)
  df$v <- 1
  df <- unique(df)
  dfr <- reshape(df, direction = "wide", idvar = c("x", "p"), timevar = "i")
  dfr <- dfr[!complete.cases(dfr),]
  dfr[is.na(dfr)] <- 0
  dfra <- aggregate(p~., data=dfr, FUN="sum", na.action = )

  ps <- lapply(ar, `[[`, "p")
  xs <- lapply(ar, `[[`, "x")

  Reduce(identical, lapply(ps, length)) &
  Reduce(identical, lapply(ps, sort)) &
  sum(duplicated(dfra[["x"]]))==0
}

#' Title
#'
#' @param a
#'
#' @return
#' @export
#'
#' @examples
deal_make_transparent <- function(a){

  stopifnot(is_deal(a))

  if(deal_is_transparent(a)) return(a)

  a_compacted <- deal_compact(a)
  unmatched_dfs <- a_compacted
  ax_intersected <- intersect(a[[1]][["x"]], a[[2]][["x"]])
  if(length(ax_intersected)>0){
    match_indices <- lapply(a_compacted, function(i) match(ax_intersected, i$x))
    matched <- mapply(function(df, i){df[i,]}, a_compacted, match_indices, SIMPLIFY = FALSE)
    unmatched <-mapply(function(df, i){df[-i,]}, a_compacted, match_indices, SIMPLIFY = FALSE)
    p_new <- matched[[1]][["p"]] - matched[[2]][["p"]]

    matched_df <- data.frame(x=matched[[1]][["x"]], p=pmin(matched[[1]][["p"]],matched[[2]][["p"]]))

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

    if(abs(p_diff)>1e-6){
      if(p_diff>0){
        targets_lst[[1]] <- data.frame(x=rep.int(unmatched_dfs[[1]][["x"]][i],2),
                                     p=c(unmatched_dfs[[2]][["p"]][i], p_diff),
                                     stringsAsFactors = FALSE)
      } else {
        targets_lst[[2]] <- data.frame(x=rep.int(unmatched_dfs[[2]][["x"]][i],2),
                                     p=c(unmatched_dfs[[1]][["p"]][i], -p_diff),
                                     stringsAsFactors = FALSE)
      }
    }
    unmatched_dfs <- mapply(rbind, headers_lst, targets_lst, footers_lst, SIMPLIFY = FALSE)


    theres_more <- nrow(unmatched_dfs[[1]])>i || nrow(unmatched_dfs[[2]])>i
    i <- i+1
  }  # end while

  lapply(unmatched_dfs, function(x) rbind(matched_df, x)[, c("p", "x")])
}
