# ネットワーククラスタリング（コミュニティ検出）
ネットワークをクラスタリングします。
* Topological Overlap Matrixに基づいてネットワークをクラスタリングします。
* モジュラリティ最大化に基づいてネットワークをクラスタリングします（コミュニティの重複を考えません）。
* モジュラリティ最大化に基づいてネットワークをクラスタリングします（コミュニティの重複を考えます）。
* コミュニティ検出の解像度限界を見てみましょう。

## ネットワーククラスタリング
ネットワーククラスタリングとは，ネットワークを構造に従っていくつかのサブネットワークに分割することです。
より詳しい内容については[SlideShareに公開されるスライドの43枚目から](https://www.slideshare.net/kztakemoto/r-seminar-on-igraph)をご覧ください。

## データ
  * 空手クラブネットワーク
    * ``data/karate.GraphML``
    * GraphML形式
    * ノード属性``Faction``は実際のグループ分けに対応
    * Zachary WW (1977) An information flow model for conflict and fission in small Groups. J Anthropol Res 33, 452-473. [http://www.jstor.org/stable/3629752](http://www.jstor.org/stable/3629752)
  * 大腸菌の代謝ネットワークの一部
    * ``data/ecoli_metabolic_KEGG.graphml``
    * GraphML形式
    * ノード属性``Faction``はKEGG PATHWAYの定義に対応
    * Kanehisa M et al. (2019) New approach for understanding genome variations in KEGG. Nucleic Acids Res. 47, D590-D595. doi: [10.1093/nar/gky962](https://doi.org/10.1093/nar/gky962)
  * コミュニティ検出の解像度限界を見るためのサンプルネットワーク
    * ``data/large.graphml``
    * ``data/small.graphml``
    * GraphML形式

## 使い方
### Topological Overlap Matrixに基づくネットワーククラスタリング
```
% Rscript network_clustering_modularity_nonoverlap.R | tee result.txt
```
#### 出力ファイル
* ``figures/plots_topological_overlap.pdf``: 出力された図
* ``result.txt``: モジュラリティスコアやコミュニティの数

### モジュラリティ最大化に基づくネットワーククラスタリング（コミュニティの重複を考慮しない場合）
```
% Rscript network_clustering_modularity_nonoverlap.R
```
#### ここで使う手法
* [エッジ媒介性（Edge betweenness）に基づく方法](http://samoa.santafe.edu/media/workingpapers/01-12-077.pdf)
* [貪欲アルゴリズムに基づく方法](https://arxiv.org/abs/cond-mat/0408187)
* [スペクトル法（固有ベクトルに基づく方法）に基づく方法](https://arxiv.org/abs/physics/0602124)
* [焼きなまし法に基づく方法](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2175124/)

#### 出力ファイル
* ``figures/network_clustering_modularity_nonoverlap.R``: 出力された図

### モジュラリティ最大化に基づくネットワーククラスタリング（コミュニティの重複を考慮する場合）
```
% Rscript network_clustering_modularity_overlap.R
```
#### ここで使う手法
* [Link Communityアルゴリズムによる方法](https://arxiv.org/abs/0903.3178)
* [Overlapping Cluster Generator (OCG) アルゴリズムに基づく方法](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3244771/)

#### 出力ファイル
* ``figures/network_clustering_modularity_overlap.R``: 出力された図

### コミュニティ検出の解像度限界
```
% Rscript resolution_limit.R
```
#### 出力ファイル
* ``figures/plots_resolution_limit.pdf``: 出力された図

## やってみよう
Rスクリプトは空手クラブのネットワークを例にして作成されています。
このスクリプトを参考にして，大腸菌の代謝ネットワークを解析してみましょう。
