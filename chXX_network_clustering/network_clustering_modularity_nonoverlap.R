#################################################
# モジュラリティ最大化に基づくネットワーククラスタリング
#（コミュニティの重複を考慮しない場合）
#################################################

# 手法の選択
method <- commandArgs(trailingOnly=TRUE)[1]
#   edgebet: エッジ媒介性（Edge betweenness）に基づく方法
#   greedy:  貪欲アルゴリズムに基づく方法
#   eigen:   スペクトル法（固有ベクトルに基づく方法）に基づく方法
#   SA:      焼きなまし法に基づく方法

# 図の出力先
if(method %in% c("edgebet","eigen","greedy","SA")){
    outputfilename <- paste("plots_modularity_nonoverlap_",method,".pdf",sep="")
    pdf(outputfilename)
}

# igraphパッケージの読み込み（ないならインストールする）
if(!require(igraph)) install.packages("igraph")
library(igraph)

# rnetcartoパッケージの読み込み（ないならインストールする）
if(!require(rnetcarto)) install.packages("rnetcarto")
library(rnetcarto)

## ネットワークの読み込み
# 空手クラブのネットワークを読み込む
g <- read.graph("karate.GraphML",format="graphml")

## モジュラリティ最大化に基づくネットワーククラスタリング
if(method == "edgebet"){
    # エッジの重みは無効にする
    g <- delete_edge_attr(g, "weight")
    # エッジ媒介性（Edge betweenness）に基づく手法
    # http://samoa.santafe.edu/media/workingpapers/01-12-077.pdf
    data <- edge.betweenness.community(g)
    # デンドログラムをプロット
    dendPlot(data)

} else if(method == "greedy"){
    # 貪欲アルゴリズムに基づく方法
    # https://arxiv.org/abs/cond-mat/0408187
    data <- fastgreedy.community(g)
    # デンドログラムをプロット
    dendPlot(data)

} else if(method == "eigen"){
    # スペクトル法（固有ベクトルに基づく方法）に基づく方法
    # https://arxiv.org/abs/physics/0602124
    data <- leading.eigenvector.community(g,options=list(maxiter=1000000, ncv=5))
    # デンドログラムをプロット
    dendPlot(data)

} else if(method == "SA"){
    # 焼きなまし法に基づく方法（rnetcartoパッケージで計算する）
    # https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2175124/
    # 隣接行列を取得
    mtx <- get.adjacency(g, sparse=F, attr = "weight")
    # コミュニティ抽出を実行
    res <- netcarto(mtx)
    # igraphの出力結果と一致するように出力を調整
    data <- as.data.frame(res[[1]])
    names(data)[[2]] <- "membership"
    data$membership <- data$membership + 1
    row.names(data) <- data$name
    data <- data[V(g)$name,]

} else {
    stop("その引数は無効です。")
}

## 結果を表示
# クラスタのメンバシップにしたがってノードを色付け
V(g)$color <- data$membership
# ネットワークを描画。ノードの形が実際のメンバーシップに対応する。
plot(g,vertex.size=10,vertex.label=V(g)$name, vertex.shape=c("circle","square")[V(g)$Faction])
