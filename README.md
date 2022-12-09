# 生物ネットワーク解析

## はじめに
このレポジトリでは、書籍『[生物ネットワーク解析](https://www.coronasha.co.jp/np/isbn/9784339027327/)』の補足資料が利用可能です。
書籍で紹介する手法や解析などを、統計解析ソフトウェア[R](https://www.r-project.org)とそのネットワーク解析用パッケージの[igraph](https://igraph.org/r/)を用いることで体験することができます。
資料はR Notebookとしてまとめられています。

## 準備
[R](https://www.r-project.org)と[RStudio](https://rstudio.com)をインストールしてください。
[動画による説明](https://www.youtube.com/results?search_query=rstudio+インストール)が役に立つと思います。
Windowsを使用している方は、[Rtools42](https://cran.r-project.org/bin/windows/Rtools/rtools42/rtools.html)もインストールしてください。

各ディレクトリのNotebook（拡張子がRmd）のファイルを開くと，パッケージのインストールを要求するメッセージが表示されますので（インストールされていなければ），それに従ってパッケージをあらかじめインストールしてください（ほぼ自動的にインストールされます）。
部分的にマニュアルでインストールするパッケージもありますのでご注意ください（各トピックのREADMEやNotebookをご覧ください）。

NotebookはR（ver 4.2.2），RStudio（ver 2022.07.2），igraph（ver 1.3.5）で動作確認されています。

R Notebookを参考にすれば解析は完了しますが，自分の解析に沿うようにスクリプトを改変するためにはRとigraphの基本的な使い方を習得しておく必要があります。
以下が参考になりますので，適時ご参照ください。
* [Rとigraphの基本的な使い方](http://www.nemotos.net/igraph-tutorial/NetSciX_2016_Workshop_ja.html)
* [igraphの基本的な使い方](https://sites.google.com/view/takemotolab/r-igraph)
  * [スライド](https://www.slideshare.net/kztakemoto/r-seminar-on-igraph)

## 目次
* 1章：[生物ネットワーク解析の基礎](introduction)
* 2章：[基本的なネットワーク指標](network_property)：基本的なネットワーク指標を計算します。
* 3章：[ネットワークモデル](network_models)：様々なネットワークモデルからネットワークを生成し，それを用いたネットワーク指標の統計解析を行います。
  * 参考：[ネットワークモチーフ](network_motifs)：ネットワークから重要な部分構造を見つけます。
* 4章：[中心性解析](centrality_analysis)：ノードの順位づけを行います。
* 5章：[ネットワーク可制御性解析](network_controllability)：ネットワークの制御に関わる重要なノードを同定します。
* 6章：[コミュニティ検出](community_detection)：ネットワークをクラスタリングします。
* 7章：[相関ネットワーク解析](correlation_networks)：データの相関からネットワーク構造を推定します。

## 参考書籍
* [ネットワーク科学: ひと・もの・ことの関係性をデータから解き明かす新しいアプローチ](https://www.amazon.co.jp/dp/4320124472/ref=cm_sw_r_tw_dp_x_ag4RFb65A3X6N)
  * [英語のオンライン版（全文読めます）](http://networksciencebook.com)
* [複雑ネットワーク：基礎から応用まで](https://www.amazon.co.jp/dp/4764903636/ref=cm_sw_r_tw_dp_ph4RFb6XKK3M2?_x_encoding=UTF8&psc=1)
* [ネットワーク分析 (Rで学ぶデータサイエンス 8)](https://www.amazon.co.jp/dp/4320019288/ref=cm_sw_r_tw_dp_x_qi4RFbJGM8RF8)
* [複雑ネットワークとその構造](https://www.amazon.co.jp/dp/4320110536/ref=cm_sw_r_tw_dp_x_aj4RFb2WW2EVW)

## 連絡
質問などは以下からお気軽に。
* [@kztakemoto](https://twitter.com/kztakemoto)
