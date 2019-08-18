
# MASSパッケージの読み込み（ないならインストールする）
if(!require(MASS)) install.packages("MASS")
library(MASS)
# igraphパッケージの読み込み（ないならインストールする）
if(!require(igraph)) install.packages("igraph")
library(igraph)
# fdrtoolパッケージの読み込み（ないならインストールする）
if(!require(fdrtool)) install.packages("fdrtool")
library(fdrtool)

##########################################################################
generate_covariance_matrix <- function(nn=100,k_ave=4,type.network="random",sd.min=0.5,sd.max=1,positive.ratio=0.5){
  # @param nn number of nodes
  # @param k_ave average degree (number of edges per node)
  # @param type.network network structure
  #               random: random networks
  #                   sf: scale-free networks
  #                   sw: small-world networks
  #                   bipar: random bipartite networks
  # @param sd.min the minimum value for uniform distribution
  # @param sd.max the maximum value for uniform distribution
  # @param positive.ratio the occurence probability of positive covariance
  
  nl <- round(k_ave * nn / 2)
  if(type.network == "random"){
    g <- erdos.renyi.game(nn,nl,type="gnm")
  } else if(type.network == "sf"){
    g <- static.power.law.game(nn,nl,2.1,-1,loops = F,multiple = F,finite.size.correction = T)
  } else if(type.network == "sw") {
    g <- sample_smallworld(1, nn, round(k_ave / 2), 0.05, loops=F, multiple=F)
  } else if(type.network == "bipar") {
    g <- sample_bipartite(nn/2,nn/2,type="gnm",m=nl,directed=F)
  } else {
    stop("netwotk type is invalid")
  }
  # get edge list
  edgelist <- get.edgelist(g)

  # generate A
  A <- matrix(0,nrow=nn,ncol = nn)
  for(i in 1:nl){
    if(runif(1) < positive.ratio){
      val <- runif(1,min=sd.min, max=sd.max)
    } else {
      val <- -runif(1,min=sd.min, max=sd.max)
    }
    A[edgelist[i,1],edgelist[i,2]] <- val
    A[edgelist[i,2],edgelist[i,1]] <- val
  }

  return(list(g, A))
}

##########################################################################
random.rewiring.correlation.mtx <- function(x.cor, niter = 10, sd.min=0.3, sd.max=1, positive.ratio=0.5){
  # x.cor the original covariance matrix
  # @param niter number of edge rewiring
  # @param sd.min the minimum value for uniform distribution
  # @param sd.max the maximum value for uniform distribution
  # @param positive.ratio the occurence probability of positive covariance

	diag(x.cor) <- 0
  x.cor.original <- x.cor
	nn <- dim(x.cor)[[1]]
  x.cor.mod <- matrix(0, nn, nn)

	for(n in 1:niter){
		flag <- 0
		while(flag == 0){
			source_id <- sample(1:nn, 1)
			target_id_set <- which(abs(x.cor[source_id,]) > 0)
			if(length(target_id_set) > 0){
				flag <- 1
			}
		}
    if(length(target_id_set) == 1){
      target_id <- target_id_set[[1]]
    } else {
      target_id <- sample(target_id_set, 1)
    }
		x.cor[source_id, target_id] <- 0
		x.cor[target_id, source_id] <- 0

		flag <- 0
		while(flag == 0){
			new_target_id <- sample(1:nn, 1)
			if(x.cor.mod[source_id, new_target_id] == 0 && new_target_id != source_id && x.cor.original[source_id, new_target_id] == 0){
				flag <- 1
			}
		}

		if(runif(1) < positive.ratio){
			val <- runif(1,min=sd.min, max=sd.max)
		} else {
			val <- -runif(1,min=sd.min, max=sd.max)
		}
    x.cor.mod[source_id, new_target_id] <- val
		x.cor.mod[new_target_id, source_id] <- val
	}

  x.cor.mod <- x.cor.mod + x.cor

	net <- ifelse(abs(x.cor.mod) > 0, 1, 0)
	diag(x.cor.mod) <- 1
	return(list(net, x.cor.mod))
}

############################################################################
network_prediction_performance <- function(g_real,g_pred){
    aij_real <- get.adjacency(g_real, type="both", sparse=F)
    aij_pred <- get.adjacency(g_pred, type="both", sparse=F)

    aij_real <- aij_real[lower.tri(aij_real)]
    aij_pred <- aij_pred[lower.tri(aij_pred)]

    table <- table(aij_real,aij_pred)
    accuracy <- sum(diag(table)) / sum(table)
    precision <- table[2,2] / (table[2,2] + table[1,2])
    recall <- table[2,2] / (table[2,2] + table[2,1])
    sum <- list(table,accuracy,precision,recall)
    names(sum) <- c("confusion matrix","accuracy","precision","recall")
    return(sum)
}