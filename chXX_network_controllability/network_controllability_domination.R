#######################################################################
# ネットワーク可制御性（最小支配集合に基づく）
# * ネットワークのドライバ（支配）ノードを見つける。
# * ネットワーク可制御性に基づくいてノードを「不必要」「中立」「不可欠」に分類する。
#######################################################################

# 図の出力先
pdf("figures/plots_controllability_domination.pdf")

# igraphパッケージの読み込み（ないならインストールする）
if(!require(igraph)) install.packages("igraph")
library(igraph)

# ネットワーク可制御性のための関数を読み込む
source("functions_network_controllability.R")

## ネットワークを読み込む
# モデルネットワークを例にする。
g <- static.power.law.game(30,40,2.1,2.1)

### 最小支配集合（minimum dominating set）を得る
mds <- get_mds_domination(g, relax = F)
# @param relax: 論理値，バイナリ整数計画問題を線形計画緩和するかどうか。デフォルトはF（しない）。

# 最小支配集合のサイズ（ドライバ（支配）ノードの数）
mds[[1]]
# ドライバノードメンバーシップ: ドライバノードである (1) でない (0)
mds[[2]]

## 結果を表示する。
## ドライバノードはオレンジで色付けされる。
plot(g, vertex.size=5, edge.arrow.size=0.7, vertex.color=c("white","orange")[mds[[2]]+1])


### 最小支配集合に基づくネットワーク可制御性に基づくいてノードを分類する
# 分類を得る
V(g)$node_class <- node_classification_controllability(g, get_mds = get_mds_domination, relax = F)
# @param relax: 論理値，バイナリ整数計画問題を線形計画緩和するかどうか。デフォルトはF（しない）。
# @param get_mds: 最小ノード集合を得るための関数

## 結果を表示する
# 色付けの準備
V(g)$color[V(g)$node_class=="dispensable"] <- "gray"
V(g)$color[V(g)$node_class=="neutral"] <- "skyblue"
V(g)$color[V(g)$node_class=="indispensable"] <- "pink"

# ネットワークを描画
# 灰：不必要（dispensable）ノード，水色：中立（neutral）ノード，桃：不可欠（indispensable）ノード
plot(g, vertex.size=5, edge.arrow.size=0.7)
