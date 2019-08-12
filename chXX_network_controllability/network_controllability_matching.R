#######################################################################
# ネットワーク可制御性（最大マッチングに基づく）
# * ネットワークのドライバノードを見つける。
# * ネットワーク可制御性に基づくいてノードを「不必要」「中立」「不可欠」に分類する。
#######################################################################

# 図の出力先
pdf("figures/plots_controllability_matching.pdf")

# igraphパッケージの読み込み（ないならインストールする）
if(!require(igraph)) install.packages("igraph")
library(igraph)

# ネットワーク可制御性のための関数を読み込む
source("functions_network_controllability.R")

## ネットワークを読み込む
# モデルネットワークを例にする。
g <- static.power.law.game(30,40,2.1,2.1)

### 最小ドライバーノード集合（minimum driver node set）を得る
mds <- get_mds_matching(g, relax = F)
# @param relax: 論理値，バイナリ整数計画問題を線形計画緩和するかどうか。デフォルトはF（しない）。

# 最小ドライバーノード集合のサイズ（ドライバノードの数）
mds[[1]]
# ドライバノードメンバーシップ: ドライバノードである (1) でない (0)
mds[[2]]
# マッチングリンクのメンバーシップ: マッチングリンクである (1) ない (0)
mds[[3]]

## 結果を表示する。
## ドライバノードはオレンジで色付けされる。
plot(g, vertex.size=10, edge.arrow.size=0.7, vertex.color=c("white","orange")[mds[[2]]+1])


### 最大マッチングに基づくネットワーク可制御性に基づくいてノードを分類する
# 分類を得る
V(g)$node_class <- node_classification_controllability(g, get_mds = get_mds_matching, relax = F)
# @param relax: 論理値，バイナリ整数計画問題を線形計画緩和するかどうか。デフォルトはF（しない）。
# @param get_mds: 最小ノード集合を得るための関数

## 結果を表示する
# 色付けの準備
V(g)$color[V(g)$node_class=="dispensable"] <- "gray"
V(g)$color[V(g)$node_class=="neutral"] <- "skyblue"
V(g)$color[V(g)$node_class=="indispensable"] <- "pink"

# ネットワークを描画
# 灰：不必要（dispensable）ノード，水色：中立（neutral）ノード，桃：不可欠（indispensable）ノード
plot(g, vertex.size=10, edge.arrow.size=0.7)
