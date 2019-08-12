####################################################
# Topological Overlapを用いたネットワーククラスタリング
####################################################

# 図の出力先
pdf("figures/plots_topological_overlap.pdf")

# igraphパッケージの読み込み（ないならインストールする）
if(!require(igraph)) install.packages("igraph")
library(igraph)

# WGCNAパッケージの読み込み（ないならインストールする）
# if(!require(WGCNA)) install.packages("WGCNA")
# library(WGCNA)

## ネットワークの読み込み
# 空手クラブのネットワークを（無向きなしネットワーク）で読み込む
g <- as.undirected(read.graph("data/karate.GraphML",format="graphml"))
# エッジの重みがあれば無効にする（アルゴリズムが重み付きネットワークに対応していないため）
if(!is.null(get.edge.attribute(g,"weight"))) g <- delete_edge_attr(g, "weight")

## Topological overlap score matrixの計算
# 隣接行列（Aij）を得る
A_ij <- get.adjacency(g,sparse=F)
# Jijの計算
J_ij <- cocitation(g)
# min(ki,kj)の計算
deg <- degree(g)
deg_mtx <- matrix(0,nrow=vcount(g),ncol=vcount(g))
for(i in 1:vcount(g)){
	for(j in 1:vcount(g)){
		deg_mtx[i,j] <- min(deg[[i]],deg[[j]])
	}
}
# Topological overlap score matrixを得る
overlap_mtx <- (J_ij + A_ij) / (deg_mtx + 1 - A_ij)
diag(overlap_mtx) <- 1
# WGCNAパッケージを使ったTopological overlap score matrixの計算
# overlap_mtx <- TOMsimilarity(A_ij)

## 階層的クラスタリングの実行
# 距離行列(dissimilarity score matrix)に変換
dist <- as.dist(1 - overlap_mtx)
# 群平均法に基づいて階層的クラスタリング
res <- hclust(dist, method="average")
# デンドログラムをプロット
plot(res)
# 適当な閾値でクラスタを決める
mem <- cutree(res,h=0.9)

## 結果を表示
# クラスタのメンバシップにしたがってノードを色付け
V(g)$color <- mem
# ネットワークを描画。ノードの形が実際のメンバーシップに対応する。
plot(g,vertex.size=10, vertex.label=V(g)$name, vertex.shape=c("circle","square")[V(g)$Faction])
