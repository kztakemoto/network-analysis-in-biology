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
# 空手クラブのネットワークを（無向ネットワークで）で読み込む
g <- as.undirected(read.graph("data/karate.GraphML",format="graphml"))
# エッジの重みがあれば無効にする（アルゴリズムが重み付きネットワークに対応していないため）
if(!is.null(get.edge.attribute(g,"weight"))) g <- delete_edge_attr(g, "weight")

# 代謝ネットワークを（無向ネットワークで）読み込む
d <- read.table("data/ecoli_metabolic_KEGG.txt")
g <- simplify(graph.data.frame(d, directed=F), remove.loops=T, remove.multiple=T)

## 隣接行列をk-meansでクラスタリング
# 隣接行列（Aij）を得る
A_ij <- get.adjacency(g,sparse=F)
# 対角成分を1にする。
diag(A_ij) <- 1
# 2個のコミュニティ（クラスタ）となるようにk-meansを実行
res <- kmeans(A_ij, 2)

## 結果を表示
# コミュニティのメンバシップにしたがってノードを色付け
V(g)$color <- res$cluster
# ネットワークを描画。ノードの形が実際のメンバーシップに対応する。
plot(g,vertex.size=10, vertex.label=V(g)$name)


## 階層的クラスタリング
# 隣接行列を使って距離行列を求める。
dist <- dist(A_ij,method="binary")
# 最短距離行列(dissimilarity score matrix)に変換
dist <- as.dist(distances(g))
# 群平均法に基づいて階層的クラスタリング
res <- hclust(dist, method="average")
# デンドログラムをプロット
plot(res)
# heightに対する適当な閾値hでコミュニティを決める
mem <- cutree(res, h=0.9)
# k個数のコミュニティになるように分割する
mem <- cutree(res, k=2)

## 結果を表示
# コミュニティのメンバシップにしたがってノードを色付け
V(g)$color <- mem
# ネットワークを描画。ノードの形が実際のメンバーシップに対応する。
plot(g,vertex.size=10, vertex.label=V(g)$name)
