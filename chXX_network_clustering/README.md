# ネットワーククラスタリング（コミュニティ検出）
サンプルネットワークをクラスタリングします。
* Topological Overlap Matrixに基づいてネットワークをクラスタリングします。
* モジュラリティ最大化に基づいてネットワークをクラスタリングします（コミュニティの重複を考えません）。
* モジュラリティ最大化に基づいてネットワークをクラスタリングします（コミュニティの重複を考えます）。
* コミュニティ抽出の解像度限界を見てみましょう。

## ネットワークデータ
  * 空手クラブネットワーク
    * ``karate.GraphML``
    * GraphML形式
  * 大腸菌の代謝ネットワークの一部
    * ``eco_EM+TCA.txt``
    * エッジリスト形式
  * コミュニティ抽出の解像度限界を見るためのサンプルネットワーク
    * ``large.graphml``
    * ``small.graphml``
    * GraphML形式

## 使い方
### Topological Overlap Matrixに基づくネットワーククラスタリング
```
% Rscript network_clustering_topological_overlap.R 
```
#### 出力ファイル
* ``plots_topological_overlap.pdf``: 出力された図

### モジュラリティ最大化に基づくネットワーククラスタリング（コミュニティの重複を考慮しない場合）
```
% Rscript network_clustering_modularity_nonoverlap.R [method]
```
#### 手法を指定する引数 \[method\]
* ``edgebet``: [エッジ媒介性（Edge betweenness）に基づく方法](http://samoa.santafe.edu/media/workingpapers/01-12-077.pdf)
* ``greedy``: [貪欲アルゴリズムに基づく方法](https://arxiv.org/abs/cond-mat/0408187)
* ``eigen``: [スペクトル法（固有ベクトルに基づく方法）に基づく方法](https://arxiv.org/abs/physics/0602124)
* ``SA``: [焼きなまし法に基づく方法](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2175124/)

#### 出力ファイル
* ``network_clustering_modularity_nonoverlap_[method].R``: 出力された図

### モジュラリティ最大化に基づくネットワーククラスタリング（コミュニティの重複を考慮する場合）
```
% Rscript network_clustering_modularity_overlap.R [method]
```
#### 手法を指定する引数 \[method\]
* ``linkcomm``: [Link Communityアルゴリズムによる方法](https://arxiv.org/abs/0903.3178)
* ``ocg``: [Overlapping Cluster Generator (OCG) アルゴリズムに基づく方法](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3244771/)

#### 出力ファイル
* ``network_clustering_modularity_overlap_[method].R``: 出力された図

### コミュニティ抽出の解像度限界
```
% Rscript resolution_limit.R
```
#### 出力ファイル
* ``network_clustering_modularity_overlap_[method].R``: 出力された図