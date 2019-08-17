thresholding.RMT <- function(mtx, cutVector = seq(0.05,0.95,by = 0.05)){
    mtx <- abs(mtx)
    diag(mtx) <- 0
    
    rc_opt <- 0
    ks_opt <- 1
    for(rc in cutVector){
        mtx_tmp <- ifelse(mtx > rc,mtx,0)
        ei <- eigen(mtx_tmp)
        
        diff_eigenvalue <- diff(sort(ei$values))
        mean_diff_eigenvalue <- mean(diff_eigenvalue)
        
        if(mean_diff_eigenvalue > 0){
            diff_eigenvalue <- diff_eigenvalue / mean_diff_eigenvalue
            
            # calc. Kolmogorov-Smirnov distance
            res.ks <- ks.test(diff_eigenvalue,"pexp")
            
            if(res.ks$statistic < ks_opt){
                rc_opt <- rc
                ks_opt <- res.ks$statistic
                p.value_opt <- res.ks$p.value
            }
        }
    }
    
    cat("Optimal threshold value = ",rc_opt,"\nKS distance = ",ks_opt," (p = ",p.value_opt,")\n",sep="")
    
    mtx_opt <- ifelse(mtx > rc_opt,1,0)
	diag(mtx_opt) <- 0
    g <- graph.adjacency(mtx_opt,mode="undirected",weighted=NULL)
    
    return(g)
}