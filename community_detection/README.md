# コミュニティ抽出
ネットワークをクラスタリングします。
* Topological Overlap Matrixに基づいてネットワークをクラスタリングします。
* モジュラリティ最大化に基づいてネットワークをクラスタリングします（コミュニティの重複を考えません）。
  * この文脈で，[機能地図作成（Functional cartography）](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2175124/)を行います。
* モジュラリティ最大化に基づいてネットワークをクラスタリングします（コミュニティの重複を考えます）。

## コミュニティ抽出
コミュニティ抽出とは，ネットワークを構造に従っていくつかのコミュニティ（サブネットワーク）に分割することです。
ネットワークをクラスタリングすることに対応します。
より詳しい内容については[SlideShareに公開されるスライドの43枚目から](https://www.slideshare.net/kztakemoto/r-seminar-on-igraph)をご覧ください。


## Notebook
### Topological Overlap Matrixに基づくコミュニティ抽出
```
community_detection_topological_overlap.Rmd
```
[NotebookをHTMLで見る](https://kztakemoto.github.io/network-analysis-in-biology/community_detection/community_detection_topological_overlap.nb.html)。

### モジュラリティ最大化に基づくコミュニティ抽出（コミュニティの重複を考慮しない場合）
併せて，機能地図作成も実行します。
```
community_detection_modularity_nonoverlap.Rmd
```
[NotebookをHTMLで見る](https://kztakemoto.github.io/network-analysis-in-biology/community_detection/community_detection_modularity_nonoverlap.nb.html)。

#### ここで使う手法
* [エッジ媒介性（Edge betweenness）に基づく方法](http://samoa.santafe.edu/media/workingpapers/01-12-077.pdf)
* [貪欲アルゴリズムに基づく方法](https://arxiv.org/abs/cond-mat/0408187)
* [スペクトル法（固有ベクトルに基づく方法）に基づく方法](https://arxiv.org/abs/physics/0602124)
* [焼きなまし法に基づく方法](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2175124/)


### モジュラリティ最大化に基づくコミュニティ抽出（コミュニティの重複を考慮する場合）
```
community_detection_topological_overlap.Rmd
```
[NotebookをHTMLで見る](https://kztakemoto.github.io/network-analysis-in-biology/community_detection/community_detection_modularity_overlap.nb.html)。

#### ここで使う手法
* [Link Communityアルゴリズムによる方法](https://arxiv.org/abs/0903.3178)
* [Overlapping Cluster Generator (OCG) アルゴリズムに基づく方法](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3244771/)


