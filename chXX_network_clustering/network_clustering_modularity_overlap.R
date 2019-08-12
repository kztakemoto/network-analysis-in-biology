#################################################
# モジュラリティ最大化に基づくネットワーククラスタリング
#（コミュニティの重複を考慮する場合）
#################################################

# 手法の選択
method <- commandArgs(trailingOnly=TRUE)[1]
#   linkcomm: Link Communityアルゴリズムによる方法
#   ocg:      Overlapping Cluster Generator (OCG) アルゴリズムに基づく方法

# 図の出力先
if(method %in% c("linkcomm","ocg")){
    outputfilename <- paste("figures/plots_modularity_overlap_",method,".pdf",sep="")
    pdf(outputfilename)
}

# igraphパッケージの読み込み（ないならインストールする）
if(!require(igraph)) install.packages("igraph")
library(igraph)

# rnetcartoパッケージの読み込み（ないならインストールする）
if(!require(linkcomm)) install.packages("linkcomm")
library(linkcomm)

## ネットワークの読み込み
# 空手クラブのネットワークを（無向きなしネットワーク）で読み込む
g <- as.undirected(read.graph("data/karate.GraphML",format="graphml"))
# 後のわかりやすさのためノードに実際のコミュニティ番号を追加
V(g)$name <- paste(V(g)$name,V(g)$Faction,sep=":")
# エッジリストを取得
el <- get.edgelist(g)
# スペースをアンダーバーに置き換え（linkcommパッケージはスペースを許さない）
el <- gsub(" ","_",el)

###  ネットワーククラスタリング
if(method == "linkcomm"){
    ## Link Communityアルゴリズムによる方法
    # https://arxiv.org/abs/0903.3178
    # Link Communityアルゴリズムを実行（内部で使用され階層的クラスタリングはWard法を使用）
    # デンドログラムも表示する
    linkcomm <- getLinkCommunities(el, hcmethod="ward.D2")
    # クラスタリング結果を表示
    plot(linkcomm, type="graph")
    # メンバーシップを表示。ひとつのコミュニティのみに属すエッジは出力されないことに注意。
    plot(linkcomm, type="members")
    
    # 適当な閾値でクラスタを決定する。
    linkcomm_at <- newLinkCommsAt(linkcomm, cutat=2.2)
    # クラスタリング結果を表示
    plot(linkcomm_at, type="graph")
    # メンバーシップを表示。ひとつのコミュニティのみに属すエッジは出力されないことに注意。
    plot(linkcomm_at, type="members")

} else if(method == "ocg"){
    ## Overlapping Cluster Generator (OCG) アルゴリズムに基づく方法
    # https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3244771/
    # OCGアルゴリズムの実行
    ocg <- getOCG.clusters(el)
    # クラスタリング結果を表示
    plot(ocg, type="graph")
    # メンバーシップを表示。ひとつのコミュニティのみに属すエッジは出力されないことに注意。
    plot(ocg, type="members")

} else {
    stop("その引数は無効です。")
}

