# 相関ネットワーク解析
* ペアワイズ相関検定の統計量を閾値化することで相関ネットワークを作成します。
  * 補正されたP値に基づいて閾値化します。
  * ランダム行列理論に基づいて閾値化します。
  * 擬似データを用いて，相関ネットワークの予測性能を評価します。

## 相関ネットワーク解析
相関ネットワークとは，データの相関から作成されたネットワークのことを指します。

## 使い方
### 閾値化による相関ネットワークの作成と相関ネットワークの予測性能評価（絶対量データを用いる場合）
```
% Rscript correlation_thresholding.R | tee result_thresholding.txt
```
#### 出力ファイル
* ``result_thresholding.txt``: 各閾値化法に対する予測性能

### 閾値化による相関ネットワークの作成と相関ネットワークの予測性能評価（相対量データを用いる場合）
Bootstrapのため少し時間がかかります。
```
% Rscript correlation_compositional.R | tee result_compositional.txt
```
#### 出力ファイル
* ``result_compositional.txt``: 各閾値化法に対する予測性能

## やってみよう
* シロイヌナズナのメタボロームデータを使って相関ネットワークを作成してみましょう。
  * ``AraMetLeaves.csv``
  * 野生株（``Col-``），mto1変異株（``mto1-``），tt4変異株（``tt4-``）のデータが格納されています。
  * Kusano M et al (2007) Unbiased characterization of genotype-dependent metabolic regulations by metabolomic approach in *Arabidopsis thaliana*. BMC Syst Biol 1, 53. doi: [10.1186/1752-0509-1-53](https://doi.org/10.1186/1752-0509-1-53) 
* 腸内細菌のデータを使って相関ネットワークを作成してみましょう。
  * SpiecEasiパッケージで利用可能なデータを使ってみましょう。
```
library(SpiecEasi)
data(amgut1.filt)
```
* スクリプトを参考に自分のデータを解析してみましょう。
