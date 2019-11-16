#######################################################################
# 中心性解析（Centrality analysis） 
# タンパク質相互作用ネットワークの中心性指標とタンパク質の必須性の関係を調査する。
# * 必須タンパク質と非必須タンパク質を中心性指標の比較と差の統計分析
# * 単一の中心性指標を用いて必須タンパク質を判別する。
#######################################################################

# 図の出力先
pdf("plots.pdf")

# igraphパッケージの読み込み（ないならインストールする）
if(!require(igraph)) install.packages("igraph")
library(igraph)

## 大腸菌のタンパク質相互作用ネットワークの読み込み
# Hu P, Janga SC, Babu M, Díaz-Mejía JJ, Butland G, et al.
# Global functional atlas of Escherichia coli encompassing previously uncharacterized proteins.
# PLoS Biol. 2009 Apr 28;7(4):e96. doi: 10.1371/journal.pbio.1000096.

# エッジリストの読み込み
d <- read.table("data/ecoli_ppi_Hu_etal_2009.txt")
# グラフオブジェクトの作成
g <- simplify(graph.data.frame(d,directed=F),remove.multiple=T,remove.loops=T)

# 最大連結成分の取得
cls <- clusters(g,"weak")
g <- delete.vertices(g,subset(V(g),cls$membership!=which(cls$csize==max(cls$csize))[[1]]))

## 中心性指標の計算
# 次数中心性（degree centrality）
degree <- degree(g)
# 固有ベクトル中心性（eigenvector centraliry）
eigen <- evcent(g)$vector
# PageRank
page <- page.rank(g)$vector
# 近接中心性（closeness centrality）
closen <- closeness(g)
# 媒介中心性（betweenness centrality）
between <- betweenness(g)
# サブグラフ中心性（subgraph centrality）
subgraph <- subgraph.centrality(g)

## データフレームにまとめる
nprop <- data.frame(V(g)$name,degree,eigen,page,closen,between,subgraph)
names(nprop)[[1]] <- "gene"

## タンパク質の必須性のデータを読み込む
# Baba T, Ara T, Hasegawa M, Takai Y, Okumura Y, Baba M, Datsenko KA, Tomita M, Wanner BL, Mori H
# Construction of Escherichia coli K-12 in-frame, single-gene knockout mutants: the Keio collection.
# Mol Syst Biol. 2006;2:2006.0008. Epub 2006 Feb 21. doi: 10.1038/msb4100050
ess <- read.table("data/ecoli_proteins_essentiality_Baba2006MSB.txt",header=T)
# 必須（E），非必須（N），不明（u）

## 中心性指標のデータと必須性のデータをマージする
d <- merge(ess,nprop,by="gene")
# unknownの遺伝子を除外する。
d <- d[d$essential!="u",]
levels(d$essential)[[3]] <- NA

## Boxplot
layout(matrix(1:6, ncol=3))
# 次数中心性（degree centrality）
boxplot(log(d$degree)~d$essential,xlab="Essentiality",ylab="Degree")
# 固有ベクトル中心性（eigenvector centraliry）
boxplot(log(d$eigen)~d$essential,xlab="Essentiality",ylab="Eigenvector")
# PageRank
boxplot(log(d$page)~d$essential,xlab="Essentiality",ylab="PageRank")
# 近接中心性（closeness centrality）
boxplot(d$closen~d$essential,xlab="Essentiality",ylab="Closeness")
# 媒介中心性（betweenness centrality）
boxplot(log(d$between+1)~d$essential,xlab="Essentiality",ylab="Betweenness")
# サブグラフ中心性（subgraph centrality）
boxplot(log(d$subgraph)~d$essential,xlab="Essentiality",ylab="Subgraph")

## 必須タンパク質と非必須タンパク質の中心性指標の差を統計検定する。
# 必須タンパク質の中心性指標
ess_nprop <- d[d$essential=="E",]
# 非必須タンパク質の中心性指標
noness_nprop <- d[d$essential=="N",]

# wilcoxon test
cat("## 次数中心性（degree centrality）\n")
cat("中央値　必須：",median(ess_nprop$degree),"非必須：",median(noness_nprop$degree),"\n")
wilcox.test(ess_nprop$degree,noness_nprop$degree)

cat("## 固有ベクトル中心性（eigenvector centraliry）\n")
cat("中央値　必須：",median(ess_nprop$eigen),"非必須：",median(noness_nprop$eigen),"\n")
wilcox.test(ess_nprop$eigen,noness_nprop$eigen)

cat("## PageRank\n")
cat("中央値　必須：",median(ess_nprop$page),"非必須：",median(noness_nprop$page),"\n")
wilcox.test(ess_nprop$page,noness_nprop$page)

cat("## 近接中心性（closeness centrality）\n")
cat("中央値　必須：",median(ess_nprop$closen),"非必須：",median(noness_nprop$closen),"\n")
wilcox.test(ess_nprop$closen,noness_nprop$closen)

cat("## 媒介中心性（betweenness centrality）\n")
cat("中央値　必須：",median(ess_nprop$between),"非必須：",median(noness_nprop$between),"\n")
wilcox.test(ess_nprop$between,noness_nprop$between)

cat("## サブグラフ中心性（subgraph centrality）\n")
cat("中央値　必須：",median(ess_nprop$subgraph),"非必須：",median(noness_nprop$subgraph),"\n")
wilcox.test(ess_nprop$subgraph,noness_nprop$subgraph)

## 単一の中心性指標を用いて必須タンパク質を判別する。
# データの前準備
# 必須なら1，非必須なら0とする。
ess_score <- ifelse(d$essential == "E",1,0)

# ROCカーブを書くためのパッケージを読み込む（ないならインストールする）
if(!require(pROC)) install.packages("pROC")
library(pROC)
# ROCカーブをプロットする。
layout(matrix(1:6, ncol=3))
# 次数中心性（degree centrality）
plot.roc(ess_score,d$degree,print.auc=T,main="Degree")
# 固有ベクトル中心性（eigenvector centraliry）
plot.roc(ess_score,d$eigen,print.auc=T,main="Eigenvector")
# PageRank
plot.roc(ess_score,d$page,print.auc=T,main="PageRank")
# 近接中心性（closeness centrality）
plot.roc(ess_score,d$closen,print.auc=T,main="Closeness")
# 媒介中心性（betweenness centrality）
plot.roc(ess_score,d$between,print.auc=T,main="Betweenness")
# サブグラフ中心性（Subgraph centrality）
plot.roc(ess_score,d$subgraph,print.auc=T,main="Subgraph")
