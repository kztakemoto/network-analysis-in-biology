#######################################################################
# ネットワーク可制御性解析の例
# ノードの分類（「不必要」「中立」「不可欠」）とDrug targetの関連性を調査
#######################################################################

# 図の出力先
pdf("figures/plots_controllability_analysis.pdf")

# igraphパッケージの読み込み（ないならインストールする）
if(!require(igraph)) install.packages("igraph")
library(igraph)

# ネットワーク可制御性のための関数を読み込む
source("functions_network_controllability.R")

## 酵母の有向タンパク質相互作用ネットワークの読み込み
# エッジリストの読み込み
d <- read.csv("data/breast_cancer_directed_ppi_Kanhaiya_etal_2017.csv")
# グラフオブジェクトの作成
g <- simplify(graph.data.frame(d,directed=T),remove.multiple=T,remove.loops=T)
# 最大強連結成分の取得（本来は不必要だが，小さなネットワークを得るために実行）
cls <- clusters(g,"strong")
g <- delete.vertices(g,subset(V(g),cls$membership!=which(cls$csize==max(cls$csize))[[1]]))

## 最大マッチングに基づくネットワーク可制御性に基づくいてノードを分類する
V(g)$node_class <- node_classification_controllability(g, get_mds = get_mds_matching, relax = F)

## Drug targetのリストを読み込む
drug_target <- read.csv("data/drug_target_proteins.csv", stringsAsFactors=F)
# ノードがDrug targetかそうでないかをまとめる。
V(g)$target <- ifelse(V(g)$name %in% drug_target$target, "target", "nontarget")

## ノードクラスとDrug targetの関連性評価
# 混同行列の作成
conf_table <- table(V(g)$node_class,V(g)$target)
# 混同行列の出力
cat("混同行列\n")
conf_table

# 各ノードクラスにおけるDrug targetの割合を計算し，プロット
cat("\n各ノードクラスにおける薬剤標的タンパク質の割合\n")
target_ratio <- conf_table[,"target"] / apply(conf_table,1,sum)
target_ratio
barplot(target_ratio,col=c("skyblue","pink","gray"))

# 関連性を統計検定（エンリッチメント解析）
cat("\n統計検定\n")
fisher.test(conf_table)
