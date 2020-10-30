# ネットワーク可制御性解析
ネットワーク可制御性に基づく解析を行います。
* 最大マッチングに基づくネットワーク可制御性
  * [ドライバノードを見つけます](https://www.nature.com/articles/nature10011)。
  * [ネットワーク可制御性に基づいてノードを「不必要」「中立」「不可欠」に分類します](https://www.pnas.org/content/113/18/4976)。
* 最小支配集合に基づくネットワーク可制御性
  * [ドライバノードを見つけます](https://iopscience.iop.org/article/10.1088/1367-2630/14/7/073005)。
  * ネットワーク可制御性に基づいてノードを「不必要」「中立」「不可欠」に分類します。
* ノードのクラス（「不必要」「中立」「不可欠」）と薬剤標的タンパク質の関連性を調査します。

## ネットワーク可制御性
ネットワーク可制御性解析とは，構造可制御の理論に基づいて，ネットワークを制御するためのノード（ドライバノード）を見つけることです。

## 準備
lpSolveパッケージをマニュアルでインストールしてください。
```
install.packages("lpSolve")
```

## Notebook
### 最大マッチングに基づくネットワーク可制御性
```
network_controllability_matching.Rmd
```
[Notebookのプレビュー（HTML版）を見る](https://kztakemoto.github.io/network-analysis-in-biology/network_controllability/network_controllability_matching.nb.html)。

### 最小支配集合に基づくネットワーク可制御性
```
network_controllability_domination.Rmd
```
[Notebookのプレビュー（HTML版）を見る](https://kztakemoto.github.io/network-analysis-in-biology/network_controllability/network_controllability_domination.nb.html)。

### ネットワーク可制御性解析の例
ノードのクラス（「不必要」「中立」「不可欠」）と薬剤標的タンパク質の関連性を調査
```
network_controllability_analysis.Rmd
```
[Notebookのプレビュー（HTML版）を見る](https://kztakemoto.github.io/network-analysis-in-biology/network_controllability/network_controllability_analysis.nb.html)。
