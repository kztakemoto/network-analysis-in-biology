
# MASSパッケージの読み込み（ないならインストールする）
if(!require(MASS)) install.packages("MASS")
library(MASS)

##########################################################################
generate_covariance_matrix <- function(nn,k_ave,type.network="random",sd.min=0.5,sd.max=1,positive.ratio=0.5){
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

  #get adjacency matrix
  mtx_g <- as.matrix(get.adjacency(g))
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

  return(list(mtx_g, A))
}

##########################################################################
generateM_specific_type <- function(nn,k_ave,type.network="random",type.interact="random",interact.str.max=0.5,mix.compt.ratio=0.5){
  # @param nn number of nodes
  # @param k_ave average degree (number of edges per node)
  # @param type.network network structure
  #               random: random networks
  #                   sf: scale-free networks
  #                   sw: small-world networks
  #                bipar: random bipartite networks
  # @param type.interact interaction type
  #               random: random
  #               mutual: mutalism (+/+ interaction)
  #                compt: competition (-/- interaction)
  #                   pp: predator-prey (+/- or -/+ interaction)
  #                  mix: mixture of mutualism and competition
  #                 mix2: mixture of competitive and predator-prey interactions
  # @param interact.str.max maximum interaction strength
  # @param mix.compt.ratio the ratio of competitive interactions to all intereactions (this parameter is only used for type.interact="mix" or ="mix2")

  # number of edges
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

  # get adjacency matrix
  mtx_g <- as.matrix(get.adjacency(g))
  # get edge list
  edgelist <- get.edgelist(g)

  # generate an interaction matrix for the GLV model
  A <- matrix(0,nrow=nn,ncol = nn)

  if(type.interact == "random"){
    for(i in 1:nl){
      A[edgelist[i,1],edgelist[i,2]] <- runif(1,min=-interact.str.max,max=interact.str.max)
      A[edgelist[i,2],edgelist[i,1]] <- runif(1,min=-interact.str.max,max=interact.str.max)
    }
  } else if(type.interact == "mutual") {
    for(i in 1:nl){
      A[edgelist[i,1],edgelist[i,2]] <- runif(1,max=interact.str.max)
      A[edgelist[i,2],edgelist[i,1]] <- runif(1,max=interact.str.max)
    }
  } else if(type.interact == "compt"){
    for(i in 1:nl){
      A[edgelist[i,1],edgelist[i,2]] <- -runif(1,max=interact.str.max)
      A[edgelist[i,2],edgelist[i,1]] <- -runif(1,max=interact.str.max)
    }
  } else if(type.interact == "pp") {
    for(i in 1:nl){
      if(runif(1) < 0.5){
        A[edgelist[i,1],edgelist[i,2]] <- runif(1,max=interact.str.max)
        A[edgelist[i,2],edgelist[i,1]] <- -runif(1,max=interact.str.max)
      } else {
        A[edgelist[i,1],edgelist[i,2]] <- -runif(1,max=interact.str.max)
        A[edgelist[i,2],edgelist[i,1]] <- runif(1,max=interact.str.max)
      }
    }
  } else if(type.interact == "mix") {
    for(i in 1:nl){
      if(runif(1) < mix.compt.ratio){
        A[edgelist[i,1],edgelist[i,2]] <- -runif(1,max=interact.str.max)
        A[edgelist[i,2],edgelist[i,1]] <- -runif(1,max=interact.str.max)
      } else {
        A[edgelist[i,1],edgelist[i,2]] <- runif(1,max=interact.str.max)
        A[edgelist[i,2],edgelist[i,1]] <- runif(1,max=interact.str.max)
      }
    }
  } else if(type.interact == "mix2"){
    for(i in 1:nl){
      if(runif(1) < mix.compt.ratio){
        A[edgelist[i,1],edgelist[i,2]] <- -runif(1,max=interact.str.max)
        A[edgelist[i,2],edgelist[i,1]] <- -runif(1,max=interact.str.max)
      } else {
        if(runif(1) < 0.5){
          A[edgelist[i,1],edgelist[i,2]] <- runif(1,max=interact.str.max)
          A[edgelist[i,2],edgelist[i,1]] <- -runif(1,max=interact.str.max)
        } else {
          A[edgelist[i,1],edgelist[i,2]] <- -runif(1,max=interact.str.max)
          A[edgelist[i,2],edgelist[i,1]] <- runif(1,max=interact.str.max)
        }
      }
    }
  } else {
    stop("interaction type is invalid")
  }

  # diagonal elements
  diag(A) <- -1

  return(list(mtx_g,A))
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

##########################################################################
random.rewiring.interaction.mtx <- function(Mij, niter = 10, type.interact="random",interact.str.max=0.5,mix.compt.ratio=0.5){
  # Mij the original interaction matrix
  # @param type.interact interaction type
  #               random: random
  #               mutual: mutalism (+/+ interaction)
  #                compt: competition (-/- interaction)
  #                   pp: predator-prey (+/- or -/+ interaction)
  #                  mix: mixture of mutualism and competition
  #                 mix2: mixture of competitive and predator-prey interactions
  # @param interact.str.max maximum interaction strength
  # @param mix.compt.ratio the ratio of competitive interactions to all intereactions (this parameter is only used for type.interact="mix" or ="mix2")

	diag(Mij) <- 0
  Mij.original <- Mij
	nn <- dim(Mij)[[1]]
  Mij.mod <- matrix(0, nn, nn)

	for(n in 1:niter){
		flag <- 0
		while(flag == 0){
			source_id <- sample(1:nn, 1)
			target_id_set <- which(abs(Mij[source_id,]) > 0)
			if(length(target_id_set) > 0){
				flag <- 1
			}
		}
    if(length(target_id_set) == 1){
      target_id <- target_id_set[[1]]
    } else {
      target_id <- sample(target_id_set, 1)
    }
		Mij[source_id, target_id] <- 0
		Mij[target_id, source_id] <- 0

		flag <- 0
		while(flag == 0){
			new_target_id <- sample(1:nn, 1)
			if(Mij.mod[source_id, new_target_id] == 0 && new_target_id != source_id && Mij.original[source_id, new_target_id] == 0){
				flag <- 1
			}
		}

    if(type.interact == "random"){
      Mij.mod[source_id, new_target_id] <- runif(1,min=-interact.str.max,max=interact.str.max)
      Mij.mod[new_target_id, source_id] <- runif(1,min=-interact.str.max,max=interact.str.max)
    } else if(type.interact == "mutual") {
      Mij.mod[source_id, new_target_id] <- runif(1,max=interact.str.max)
      Mij.mod[new_target_id, source_id] <- runif(1,max=interact.str.max)
    } else if(type.interact == "compt"){
      Mij.mod[new_target_id, source_id] <- -runif(1,max=interact.str.max)
      Mij.mod[source_id, new_target_id] <- -runif(1,max=interact.str.max)
    } else if(type.interact == "pp") {
      if(runif(1) < 0.5){
        Mij.mod[source_id, new_target_id] <- runif(1,max=interact.str.max)
        Mij.mod[new_target_id, source_id] <- -runif(1,max=interact.str.max)
      } else {
        Mij.mod[source_id, new_target_id] <- -runif(1,max=interact.str.max)
        Mij.mod[new_target_id, source_id] <- runif(1,max=interact.str.max)
      }
    } else if(type.interact == "mix") {
      if(runif(1) < mix.compt.ratio){
        Mij.mod[source_id, new_target_id] <- -runif(1,max=interact.str.max)
        Mij.mod[new_target_id, source_id] <- -runif(1,max=interact.str.max)
      } else {
        Mij.mod[source_id, new_target_id] <- runif(1,max=interact.str.max)
        Mij.mod[new_target_id, source_id] <- runif(1,max=interact.str.max)
      }
    } else if(type.interact == "mix2"){
      if(runif(1) < mix.compt.ratio){
        Mij.mod[source_id, new_target_id] <- -runif(1,max=interact.str.max)
        Mij.mod[new_target_id, source_id] <- -runif(1,max=interact.str.max)
      } else {
        if(runif(1) < 0.5){
          Mij.mod[source_id, new_target_id] <- runif(1,max=interact.str.max)
          Mij.mod[new_target_id, source_id] <- -runif(1,max=interact.str.max)
        } else {
          Mij.mod[source_id, new_target_id] <- -runif(1,max=interact.str.max)
          Mij.mod[new_target_id, source_id] <- runif(1,max=interact.str.max)
        }
      }
    } else {
      stop("interaction type is invalid")
    }
	}

  Mij.mod <- Mij.mod + Mij

	net <- ifelse(abs(Mij.mod) > 0, 1, 0)
	diag(Mij.mod) <- -1
	return(list(net, Mij.mod))
}

##########################################################################
thresholding <- function(mtx, th){
  # mtx confidence score matrix
  # @param th number of node pairs accepeted as edge
	diag(mtx) <- 0
	g <- graph.adjacency(mtx, mode="undirected", weighted=T)
	score <- sort(E(g)$weight, decreasing=T)
	adj <- ifelse(mtx >= score[th], 1, 0)
	g <- graph.adjacency(adj, mode="undirected")
	return(g)
}

##########################################################################
mk.weighted.graph.obj <- function(mtx){
  diag(mtx) <- 0
  g <- graph.adjacency(mtx, mode="undirected", weighted=T)
  return(g)
}