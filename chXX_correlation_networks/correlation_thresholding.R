# igraphパッケージの読み込み（ないならインストールする）
if(!require(igraph)) install.packages("igraph")
library(igraph)
# fdrtoolパッケージの読み込み（ないならインストールする）
if(!require(fdrtool)) install.packages("fdrtool")
library(fdrtool)
# Matrixパッケージの読み込み（ないならインストールする）
if(!require(Matrix)) install.packages("Matrix")
library(Matrix)

# Hmiscパッケージの読み込み（ないならインストールする）for rcorr
if(!require(Hmisc)) install.packages("Hmisc") 
library(Hmisc)

source("utils.R")
source("thresholding.RMT.R")

# 擬似データセットの生成
nn <- 250 # ノード数
k_ave <- 4 # 平均次数
n_samp <- 300 # サンプル数

data <- generate_covariance_matrix(nn, k_ave, type.network="sf", positive.ratio = 0.5)
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

# get adjacency matrix
Aij_real <- data[[1]]
g_real <- graph.adjacency(net_real, mode="undirected")
# extract the lower trianglar part
net_real <- net_real[lower.tri(net_real)]
# get covariance (correlation) matrix
x.cor <- tmp[[2]] 

# generate abusolute data
x <- mvrnorm(n_samp, rep(0,nn), Sigma=nearPD(x.cor, corr = T, keepDiag = T)$mat)


## ピアソン相関の場合
net_pred <- rcorr(as.matrix(x))$P
# extract the lower trianglar part
net_pred <- net_pred[lower.tri(net_pred)]
# p-value correction using Benjamini-Hochberg method (if needed)
#net_pred <- p.adjust(net_pred, method="none")
# local FDR
#net_pred <- fdrtool(net_pred, statistic="pvalue")$lfdr
# binarization
net_pred_bin <- ifelse(net_pred < 0.05, 1, 0)
# confusion table
table(net_pred_bin, net_real)

thresholding.p.value <- function(pmtx, p.th=0.05, method="lfdr"){
    # extract the lower trianglar part
    n <- dim(pmtx)[[1]]
    pmtx <- pmtx[lower.tri(pmtx)]
    if(method == "lfdr"){
        pmtx <- fdrtool(pmtx, statistic="pvalue")$lfdr
    } else if(method %in% p.adjust.methods){
        pmtx <- p.adjust(pmtx, method=method)
    } else if(method == F){
        stop("method is invalid")
    }
    pmtx_bin <- ifelse(pmtx < p.th, 1, 0)

    mtx_bin <- matrix(0, n, n)
    mtx_bin[lower.tri(mtx_bin)] <- pmtx_bin

    g <- graph.adjacency(mtx_bin, mode="undirected")
	return(g)
}