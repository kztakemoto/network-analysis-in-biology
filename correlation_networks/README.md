# 相関ネットワーク解析
* ペアワイズ相関検定の統計量を閾値化することで相関ネットワークを作成します。
  * 補正されたP値に基づいて閾値化します。
  * ランダム行列理論に基づいて閾値化します。
  * 擬似データを用いて，相関ネットワークの予測性能を評価します。

## 相関ネットワーク解析
相関ネットワークとは，データの相関から作成されたネットワークのことを指します。

## 準備
SpiecEasiパッケージをマニュアルで[インストール](https://www.rdocumentation.org/packages/SpiecEasi/versions/0.1.4)してください。
```
install.packages("devtools") # インストールされていなければ
library(devtools)
install_github("zdk123/SpiecEasi")
```

## Notebook
### 閾値化による相関ネットワークの作成と相関ネットワークの予測性能評価（絶対量データを用いる場合）
```
correlation_thresholding.Rmd
```
[Notebookのプレビュー（HTML版）を見る](https://kztakemoto.github.io/network-analysis-in-biology/correlation_networks/correlation_thresholding.nb.html)。

### 閾値化による相関ネットワークの作成と相関ネットワークの予測性能評価（相対量データを用いる場合）
Bootstrapのため少し時間がかかります。
```
correlation_compositional.Rmd  
```
[Notebookのプレビュー（HTML版）を見る](https://kztakemoto.github.io/network-analysis-in-biology/correlation_networks/correlation_compositional.nb.html)。