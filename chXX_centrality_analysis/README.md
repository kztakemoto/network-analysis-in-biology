# 中心性解析
タンパク質相互作用ネットワークの中心性指標とタンパク質の必須性の関係を調査します。
* 必須タンパク質と非必須タンパク質を中心性指標を比較し，差の統計分析を行います。
* 単一の中心性指標を用いて必須タンパク質を判別します。

## 中心性解析について
中心性解析とは，ネットワークの構造に基づいて「中心的（重要）なノードはどれか」を評価することです。
より詳しい内容については[SlideShareに公開されるスライドの23枚目から](https://www.slideshare.net/kztakemoto/r-seminar-on-igraph)をご覧ください。

## データ
  * 大腸菌のタンパク質相互作用ネットワーク
    * ``ecoli_ppi_Hu_etal_2009.txt``
    * エッジリスト形式
    * Hu P et al. (2009) Global functional atlas of *Escherichia coli* encompassing previously uncharacterized proteins. PLoS Biol. 7(4), e96. doi: [10.1371/journal.pbio.1000096](https://doi.org/10.1371/journal.pbio.1000096)
  * 大腸菌タンパク質（遺伝子）の必須性
    * ``ecoli_proteins_essentiality_Baba2006MSB.txt``
    * 必須（E），非必須（N），不明（u）
    * Baba T et al. (2006) Construction of *Escherichia coli* K-12 in-frame, single-gene knockout mutants: the Keio collection. Mol Syst Biol. 2, 2006.0008. doi: [10.1038/msb4100050](https://doi.org/10.1038/msb4100050)
  * 出芽酵母のタンパク質相互作用ネットワーク
    * ``yeast_ppi_Batada_etal_2006.txt``
    * エッジリスト形式
    * Batada NN et al. (2006) Stratus not altocumulus: a new view of the yeast protein interaction network. PLoS Biol 4, e317. doi: [10.1371/journal.pbio.0040317](https://doi.org/10.1371/journal.pbio.0040317)
  * 出芽酵母タンパク質（遺伝子）の必須性
    * ``yeast_proteins_essentiality_OGEE.txt``
    * 必須（E），非必須（N）
    * Chen WH, Minguez P, Lercher MJ, Bork P (2012) OGEE: an online gene essentiality database. Nucleic Acids Res 40, D901-906. doi: [10.1093/nar/gkr986](https://doi.org/10.1093/nar/gkr986).

## 使い方
```
% Rscript centrality_analysis.R | tee result.txt
```
### 出力ファイル
* ``result.txt``: 統計分析の結果
* ``plots.pdf``: 出力された図

## やってみよう
* Rスクリプトは大腸菌のデータを例にして作成されています。このスクリプトを参考にして，酵母のデータを解析してみましょう。
* スクリプトを参考に自分のデータを解析してみましょう。
