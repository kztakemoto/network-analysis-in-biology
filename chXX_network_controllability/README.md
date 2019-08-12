# ネットワーク可制御性解析
ネットワーク可制御性に基づく解析を行います。
* 最大マッチングに基づくネットワーク可制御性
  * [ドライバノードを見つけます](https://www.nature.com/articles/nature10011)。
  * [ネットワーク可制御性に基づいてノードを「不必要」「中立」「不可欠」に分類します](https://www.pnas.org/content/113/18/4976)。
* 最小支配集合に基づくネットワーク可制御性
  * [ドライバノードを見つけます](https://iopscience.iop.org/article/10.1088/1367-2630/14/7/073005)。
  * ネットワーク可制御性に基づいてノードを「不必要」「中立」「不可欠」に分類します
* ノードのクラス（「不必要」「中立」「不可欠」）と薬剤標的タンパク質の関連性を調査します。

## ネットワーク可制御性
ネットワーク可制御性解析とは，構造可制御の理論に基づいて，ネットワークを制御するためのノード（ドライバノード）を見つけることです。

## データ
  * 乳がんタンパク質相互作用ネットワーク
    * ``breast_cancer_directed_ppi_Kanhaiya_etal_2017.csv``
    * エッジリスト形式
    * 有向ネットワーク
    * Kanhaiya K, Czeizler E, Gratie C, Petre I (2017) Controlling directed protein interaction networks in cancer. Sci Rep 7, 10327. doi: [10.1038/s41598-017-10491-y](https://doi.org/10.1038/s41598-017-10491-y)
  * アメリカ食品医薬品局が承認した（FDA-approved）薬剤標的タンパク質のリスト
    * ``drug_target_proteins.csv``
    * 引用はネットワークのものと同じ。
  * 乳がんにおける必須タンパク質のリスト
    * ``breast_cancer_essential_proteins.csv``
    * 引用はネットワークのものと同じ。

## 使い方
### 最大マッチングに基づくネットワーク可制御性
```
% Rscript network_controllability_matching.R 
```
#### 出力ファイル
* ``figures/plots_controllability_matching.pdf``: 出力された図

### 最小支配集合に基づくネットワーク可制御性
```
% Rscript network_controllability_domination.R 
```
#### 出力ファイル
* ``figures/plots_controllability_domination.pdf``: 出力された図

### ネットワーク可制御性解析の例
ノードのクラス（「不必要」「中立」「不可欠」）と薬剤標的タンパク質の関連性を調査
```
% Rscript network_controllability_analysis.R | tee result.txt
```
#### 出力ファイル
* ``figures/plots_controllability_analysis.pdf``: 出力された図
* ``result.txt``: 統計解析の結果など


## やってみよう
* Rスクリプト``network_controllability_matching.R``と``network_controllability_domination.R``はモデルネットワークを例にして作成されています。
このスクリプトを参考にして，タンパク質相互作用ネットワークを解析してみましょう。
* Rスクリプト``Rscript network_controllability_analysis.R``を参考に，別の解析をしてみましょう。例えば，以下のようです。
  * ``get_mds_matching``（最大マッチングに基づく手法）の代わりに，``get_mds_domination``（最小支配集合に基づく手法）を用いた場合，結果はどうなるでしょうか。
  * ノードのクラスと必須タンパク質には関係性があるでしょうか。具体的にどのような傾向があるでしょうか。
