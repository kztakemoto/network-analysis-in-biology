# 生物ネットワーク解析

## はじめに
[R](https://www.r-project.org)を使って生物ネットワーク解析を行うためのR Notebookが利用可能です。
[R](https://www.r-project.org)のネットワーク解析用パッケージのひとつである[igraph](https://igraph.org/r/)を主に使います。

## 準備
[R](https://www.r-project.org)と[RStudio](https://rstudio.com)をインストールしてください。
[動画による説明](https://www.youtube.com/results?search_query=rstudio+インストール)が役に立つと思います。
なお，NotebookはR（ver 4.0.3）とRStudio（ver 1.3.1093）で作成されました。

各ディレクトリのNotebook（拡張子がRmd）のファイルを開くと，パッケージのインストールを要求するメッセージが表示されますので（インストールされていなければ），それに従ってパッケージをあらかじめインストールしてください（ほぼ自動的にインストールされます）。
部分的にマニュアルでインストールするパッケージもありますのでご注意ください（各トピックのREADMEをご覧ください）。

R Notebookを参考にすれば解析は完了しますが，自分の解析に沿うようにスクリプトを改変するためにはRとigraphの基本的な使い方を習得しておく必要があります。
以下が参考になりますので，適時ご参照ください。
* [Rとigraphの基本的な使い方](http://www.nemotos.net/igraph-tutorial/NetSciX_2016_Workshop_ja.html)
* [igraphの基本的な使い方](https://sites.google.com/site/kztakemoto/r-seminar-on-igraph---supplementary-information)
  * [スライド](https://www.slideshare.net/kztakemoto/r-seminar-on-igraph)

## 目次
以下のトピックを扱います。
リンクをクリックすると，そのトピックに関連するファイルが格納されたディレクトリに移動します。
* 第1回：[ネットワーク解析の基礎](basic)：読み込みや描画といった基本的な操作を行います
* 第2回：[相関ネットワーク解析](correlation_networks)：データの相関からネットワーク作成します
* 第3回：[中心性解析](centrality_analysis)：重要なノードを見つけます
* 第4回：[コミュニティ検出](community_detection)：ネットワークをクラスタリングします
* 第5回：[ネットワーク可制御性解析](network_controllability)：ドライバノードを同定します
* 第5回：[ネットワーク指標の統計解析とネットワークモチーフ](network_motifs)：ネットワーク指標の統計解析の基礎を学び，ネットワークから重要な部分ネットワークを見つけます。

## 参考書籍
* [ネットワーク科学: ひと・もの・ことの関係性をデータから解き明かす新しいアプローチ](https://www.amazon.co.jp/dp/4320124472/ref=cm_sw_r_tw_dp_x_ag4RFb65A3X6N)
  * [英語のオンライン版（全文読めます）](http://networksciencebook.com)
* [複雑ネットワーク：基礎から応用まで](https://www.amazon.co.jp/dp/4764903636/ref=cm_sw_r_tw_dp_ph4RFb6XKK3M2?_x_encoding=UTF8&psc=1)
* [ネットワーク分析 (Rで学ぶデータサイエンス 8)](https://www.amazon.co.jp/dp/4320019288/ref=cm_sw_r_tw_dp_x_qi4RFbJGM8RF8)
* [複雑ネットワークとその構造](https://www.amazon.co.jp/dp/4320110536/ref=cm_sw_r_tw_dp_x_aj4RFb2WW2EVW)

## 連絡
質問などは以下からお気軽に。
* [@kztakemoto](https://twitter.com/kztakemoto)