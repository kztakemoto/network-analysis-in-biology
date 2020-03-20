########################################################
# モジュラリティ最大化に基づくネットワーククラスタリングにおける
# コミュニティ検出の解像度限界を確認する
########################################################

# 図の出力先
pdf("figures/plots_resolution_limit.pdf")

# igraphパッケージの読み込み（ないならインストールする）
if(!require(igraph)) install.packages("igraph")
library(igraph)
# 配色パッケージの読み込み
library(RColorBrewer)

# ネットワークの読み込み
g_6 <- as.undirected(read.graph("data/6_3-node_cliques.graphml",format="graphml"))
g_9 <- as.undirected(read.graph("data/9_3-node_cliques.graphml",format="graphml"))

# 描画の設定
par(mfrow=c(2,2))
cols <- brewer.pal(9,"Set3")

# コミュニティに対応する3ノードの完全グラフが円環上につながったネットワークを考える。
# このようなネットワークからモジュラリティ最大化に基づいてコミュニティを検出する場合，
# コミュニティの数がある閾値よりも多くなるとコミュニティを見逃す場合がある。
# この場合理論的に閾値は8である。

## 閾値（8）より小さな数のコミュニティで構成されるネットワークでは
## コミュニティを見つけることができる
##（コミュニティが併合したとしてもモジュラリティは小さくならない）。
mem <- c(1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6) # 割り当て
modularity(g_6, mem)
set.seed(123)
plot(g_6, vertex.color=cols[mem], main=paste("Q=",modularity(g_6, mem),sep=""))

mem <- c(1,1,1,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5) # 割り当て
modularity(g_6, mem)
set.seed(123)
plot(g_6, vertex.color=cols[mem], main=paste("Q=",modularity(g_6, mem),sep=""))

## コミュニティの数が閾値（8）より大きい場合、コミュニティを見逃す
##（コミュニティが併合した方がモジュラリティQが大きくなる）。
mem <- c(1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,8,8,8,9,9,9) # 割り当て
modularity(g_9, mem)
set.seed(123)
plot(g_9, vertex.color=cols[mem], main=paste("Q=",modularity(g_9, mem),sep=""))

mem <- c(1,1,1,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,8,8,8) # 割り当て
modularity(g_9, mem)
set.seed(123)
plot(g_9, vertex.color=cols[mem], main=paste("Q=",modularity(g_9, mem),sep=""))
