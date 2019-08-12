######################################
# ネットワーク可制御性解析に必要な関数の定義
######################################

# lpSolveパッケージの読み込み（ないならインストールする）
# 混合整数線形計画法ためのパッケージ
if(!require(lpSolve)) install.packages("lpSolve")
library(lpSolve)

# finding minimum driver node set (network controllability based on matching)
get_mds_matching <- function(g, relax = F){
	if(length(E(g)$weight) != ecount(g)){
		E(g)$weight <- numeric(ecount(g)) + 1
	}
	if(length(V(g)$name) != vcount(g)){
		V(g)$name <- 1:vcount(g)
	}

	edge_list <- get.edgelist(g)

	n_col <- nrow(edge_list)
	f.con <- matrix(0,nrow=vcount(g)*2,ncol=n_col)
	for(i in 1:vcount(g)){
		idx <- which(edge_list[,1] == V(g)$name[[i]])
		f.con[i,idx] <- 1
	}
	for(i in 1:vcount(g)){
		idx <- which(edge_list[,2] == V(g)$name[[i]])
		f.con[i+vcount(g),idx] <- 1
	}

	f.dir <- rep("<=", vcount(g)*2)
	f.rhs <- rep(1, vcount(g)*2)
	f.obj <- E(g)$weight

	# find the maximum matching using 0-1 integer or linear programming
	if(relax == T){
		res <- lp("max", f.obj, f.con, f.dir, f.rhs)
	} else {
		res <- lp("max", f.obj, f.con, f.dir, f.rhs, all.bin=T)
	}

	# find driver nodes
	driver_nodes <- ifelse(V(g)$name %in% edge_list[res$solution==1,2] ==T,0,1)

	sum <- list(round(sum(driver_nodes),0),driver_nodes,res$solution)
	names(sum) <- c("minimum diriver node set size","driver node (1) or not (0)","maching links (1) or not (0)")
	return(sum)
}

# finding minimum dominating set (network controllability based on domination)
get_mds_domination <- function(g, relax = F){
	#　generate a matrix for integer programming
	m_g <- t(as.matrix(get.adjacency(g)))
	diag(m_g) <- 1

	f.dir <- rep(">=", vcount(g))
	f.rhs <- rep(1, vcount(g))
	f.obj <- rep(1, vcount(g))

	# find the minimum dominating set using 0-1 integer or linear programming
	if(relax == T){
		res <- lp("min", f.obj, m_g, f.dir, f.rhs)
	} else {
		res <- lp("min", f.obj, m_g, f.dir, f.rhs, all.bin=T)
	}

	sum <- list(round(sum(res$solution),0), res$solution)
	names(sum) <- c("minimum dominating set size","dominator (1) or not (0)")
	return(sum)
}

# node classifoication based on controllability analysis
node_classification_controllability <- function(g, get_mds = get_med_matching, relax = F){
	node_class <- c()
	mds_original <- get_mds(g, relax)[[1]]
	for(v in 1:vcount(g)){
		g_del <- delete_vertices(g, v)
		mds_del <- get_mds(g_del, relax)[[1]]
		if(mds_original == mds_del){
			node_class <- c(node_class, "neutral")
		} else if(mds_original < mds_del){
			node_class <- c(node_class, "indispensable")
		} else if(mds_original > mds_del){
			node_class <- c(node_class, "dispensable")
		}
	}
	return(node_class)
}
