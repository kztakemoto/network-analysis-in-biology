#################################################
# モジュラリティ最大化に基づくネットワーククラスタリング
#（コミュニティの重複を考慮しない場合）
#################################################

# 図の出力先
pdf("figures/plots_modularity_nonoverlap.pdf")

# igraphパッケージの読み込み（ないならインストールする）
if(!require(igraph)) install.packages("igraph")
library(igraph)

# rnetcartoパッケージの読み込み（ないならインストールする）
if(!require(rnetcarto)) install.packages("rnetcarto")
library(rnetcarto)

## ネットワークの読み込み
# 空手クラブのネットワークを（無向きなしネットワーク）で読み込む
g <- as.undirected(read.graph("data/karate.GraphML",format="graphml"))
# エッジの重みがあれば無効にする（一部のアルゴリズムが重み付きネットワークに対応していないため）
if(!is.null(get.edge.attribute(g,"weight"))) g <- delete_edge_attr(g, "weight")

#### モジュラリティ最大化に基づくネットワーククラスタリング
# 出力の定義
par(family = "Japan1GothicBBB")
output <- function(g,data,method){
    # 統計
    cat("\n### ",method,"に基づく手法\n",sep="")
    cat("最大モジュラリティスコア",max(data$modularity),"\n")
    cat("コミュニティの数",max(data$membership),"\n")
    # クラスタのメンバシップにしたがってノードを色付けして，ネットワークを描画。ノードの形が実際のメンバーシップに対応する。
    V(g)$color <- data$membership
    plot(g,vertex.size=10, vertex.label=V(g)$name, vertex.shape=c("circle","square")[V(g)$Faction], main=method)
}

## 辺媒介性（Edge betweenness）に基づく手法
# http://samoa.santafe.edu/media/workingpapers/01-12-077.pdf
data <- cluster_edge_betweenness(g)
# デンドログラムをプロット
dendPlot(data, main="辺媒介性(Edge betweenness)")
# 結果を表示
output(g,data,"辺媒介性(Edge betweenness)")

## 貪欲アルゴリズムに基づく方法
# https://arxiv.org/abs/cond-mat/0408187
data <- cluster_fast_greedy(g)
# デンドログラムをプロット
dendPlot(data, main="貪欲アルゴリズム")
# 結果を表示
output(g,data,"貪欲アルゴリズム")

# スペクトル法（固有ベクトルに基づく方法）に基づく方法
# https://arxiv.org/abs/physics/0602124
data <- cluster_leading_eigen(g,options=list(maxiter=1000000, ncv=5))
# デンドログラムをプロット
dendPlot(data, main="スペクトル法")
# 結果を表示
output(g,data,"スペクトル法")

# 焼きなまし法に基づく方法（rnetcartoパッケージで計算する）
# https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2175124/
# 隣接行列を取得
mtx <- get.adjacency(g, sparse=F)
# コミュニティ抽出を実行
res <- netcarto(mtx)
# igraphの出力結果と一致するように出力を調整
table <- as.data.frame(res[[1]])
table$module <- table$module + 1
row.names(table) <- table$name
table <- table[V(g)$name,]
data <- list(membership = table$module, modularity=c(res[[2]]))
# 結果を表示
output(g,data,"焼きなまし法")

