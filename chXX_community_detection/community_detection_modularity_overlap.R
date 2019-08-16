#################################################
# モジュラリティ最大化に基づくネットワーククラスタリング
#（コミュニティの重複を考慮する場合）
#################################################

# 図の出力先
pdf("figures/plots_modularity_overlap.pdf")

# igraphパッケージの読み込み（ないならインストールする）
if(!require(igraph)) install.packages("igraph")
library(igraph)

# rnetcartoパッケージの読み込み（ないならインストールする）
if(!require(linkcomm)) install.packages("linkcomm")
library(linkcomm)

## ネットワークの読み込み
# 空手クラブのネットワークを（無向きなしネットワークで）読み込む
g <- as.undirected(read.graph("data/karate.GraphML",format="graphml"))
# 後のわかりやすさのためノードに実際のコミュニティ番号を追加
V(g)$name <- paste(V(g)$name,V(g)$Faction,sep=":")
# エッジリストを取得
el <- get.edgelist(g)
# スペースをアンダーバーに置き換え（linkcommパッケージはスペースを許さない）
el <- gsub(" ","_",el)

###  ネットワーククラスタリング
## Link Communityアルゴリズムによる方法
# https://arxiv.org/abs/0903.3178
# Link Communityアルゴリズムを実行（内部で使用され階層的クラスタリングはWard法を使用）
# デンドログラムも表示する
linkcomm <- getLinkCommunities(el, hcmethod="ward.D2")
# クラスタリング結果を表示
plot(linkcomm, type="graph")
text(0.95*par("usr")[1],0.95*par("usr")[4],label="LinkComm",pos=4)
# メンバーシップを表示。ひとつのコミュニティのみに属すエッジは出力されないことに注意。
plot(linkcomm, type="members")
text(0.95*par("usr")[1],0.95*par("usr")[4],label="LinkComm",pos=4)

# 適当な閾値でクラスタを決定する。
linkcomm_at <- newLinkCommsAt(linkcomm, cutat=2.2)
# クラスタリング結果を表示
plot(linkcomm_at, type="graph")
text(0.95*par("usr")[1],0.95*par("usr")[4],label="LinkComm",pos=4)
# メンバーシップを表示。ひとつのコミュニティのみに属すエッジは出力されないことに注意。
plot(linkcomm_at, type="members")
text(0.95*par("usr")[1],0.95*par("usr")[4],label="LinkComm",pos=4)

## Overlapping Cluster Generator (OCG) アルゴリズムに基づく方法
# https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3244771/
# OCGアルゴリズムの実行
ocg <- getOCG.clusters(el)
# クラスタリング結果を表示
plot(ocg, type="graph")
text(0.95*par("usr")[1],0.95*par("usr")[4],label="OCG",pos=4)
# メンバーシップを表示。ひとつのコミュニティのみに属すエッジは出力されないことに注意。
plot(ocg, type="members")
text(0.95*par("usr")[1],0.95*par("usr")[4],label="OCG",pos=4)
