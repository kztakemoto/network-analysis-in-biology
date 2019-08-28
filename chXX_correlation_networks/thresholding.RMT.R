thresholding.RMT <- function(mtx, cutVector = seq(0.05,1.0,by = 0.05)){
    mtx <- abs(mtx)
    n <- dim(mtx)[[1]]

    vec <- mtx[lower.tri(mtx)]
    idx <- order(vec)
    mtx_opt <- mtx
    ks_opt <- 1
    
    for(i in idx){
        vec[i] <- 0

        mtx <- matrix(0, n, n)
        mtx[lower.tri(mtx)] <- vec
        mtx <- mtx + t(mtx)
        diag(mtx) <- 0
        ei <- eigen(mtx)
        
        diff_eigenvalue <- diff(sort(ei$values))
        mean_diff_eigenvalue <- mean(diff_eigenvalue)
        
        if(mean_diff_eigenvalue > 0){
            diff_eigenvalue <- diff_eigenvalue / mean_diff_eigenvalue
            
            # calc. Kolmogorov-Smirnov distance
            res.ks <- ks.test(diff_eigenvalue,"pexp")
            
            if(res.ks$statistic < ks_opt){
                ks_opt <- res.ks$statistic
                p.value_opt <- res.ks$p.value
                mtx_opt <- mtx
            }
        }
    }
    
    cat("KS distance = ",ks_opt," (p = ",p.value_opt,")\n",sep="")
    mtx_opt <- ifelse(mtx_opt > 0,1,0)
    g <- graph.adjacency(mtx_opt,mode="undirected",weighted=NULL)
    
    return(g)
}