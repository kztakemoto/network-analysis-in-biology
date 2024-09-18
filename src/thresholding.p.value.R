thresholding.p.value <- function(pmtx, p.th=0.05, method="lfdr"){
    n <- dim(pmtx)[[1]]
    pmtx <- pmtx[lower.tri(pmtx)]
    if(method == "lfdr"){
        pmtx <- fdrtool(pmtx, statistic="pvalue")$lfdr
    } else if(method %in% p.adjust.methods){
        pmtx <- p.adjust(pmtx, method=method)
    } else {
        stop("method is invalid")
    }
    pmtx_bin <- ifelse(pmtx < p.th, 1, 0)

    mtx_bin <- matrix(0, n, n)
    mtx_bin[lower.tri(mtx_bin)] <- pmtx_bin

    g <- graph_from_adjacency_matrix(mtx_bin, mode="max")
    return(g)
}