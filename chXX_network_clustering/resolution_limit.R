########################################################
# モジュラリティ最大化に基づくネットワーククラスタリングにおける
# コミュニティ検出の解像度限界を確認する
########################################################

# 図の出力先
pdf("plots_resolution_limit.pdf")

# igraphパッケージの読み込み（ないならインストールする）
if(!require(igraph)) install.packages("igraph")
library(igraph)

# rnetcartoパッケージの読み込み（ないならインストールする）
if(!require(rnetcarto)) install.packages("rnetcarto")
library(rnetcarto)

# 小さなネットワークの読み込み
g_s <- as.undirected(read.graph("small.graphml",format="graphml"))
V(g_s)$name <- 1:vcount(g_s)
# 大きなネットワークの読み込み
g_l <- as.undirected(read.graph("large.graphml",format="graphml"))
V(g_l)$name <- 1:vcount(g_l)

## 同じサイズのコミュニティを考える場合
## 小さなネットワークではコミュニティを見つけることができる。
# ネットワーククラスタリング
data_s <- fastgreedy.community(g_s)
# 結果の出力
plot(g_s,vertex.color=data_s$membership)

## しかし大きなネットワークではコミュニティを見逃す場合がある。
# ネットワーククラスタリング
data_l <- fastgreedy.community(g_l)
# 結果の出力
plot(g_l,vertex.color=data_l$membership)

## 焼きなまし法などを用いれば見逃しを軽減できる
mtx <- get.adjacency(g_l, sparse=F)
# ネットワーククラスタリングを実行
res <- netcarto(mtx)
# igraphの出力結果と一致するように出力を調整
data_l <- as.data.frame(res[[1]])
names(data_l)[[2]] <- "membership"
data_l$membership <- data_l$membership + 1
row.names(data_l) <- data_l$name
data_l <- data_l[V(g_l)$name,]
# 結果の出力
plot(g_l,vertex.color=data_l$membership)

