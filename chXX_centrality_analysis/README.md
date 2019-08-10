# 中心性解析（Centrality analysis） 
タンパク質相互作用ネットワークの中心性指標とタンパク質の必須性の関係を調査する。
* 必須タンパク質と非必須タンパク質を中心性指標を比較する・差の統計分析を行う。
* 中心性指標を使って，必須タンパク質を予測する。

## 使用するデータ
  * 大腸菌のタンパク質相互作用ネットワーク
    * ``ecoli_ppi_Hu_etal_2009.txt``
    * エッジリスト形式
    * Hu P et al. (2009) Global functional atlas of Escherichia coli encompassing previously uncharacterized proteins. PLoS Biol. 7(4), e96. doi: [10.1371/journal.pbio.1000096](https://doi.org/10.1371/journal.pbio.1000096).
  * 大腸菌のタンパク質（遺伝子）の必須性
    * ``ecoli_proteins_essentiality_Baba2006MSB.txt``
    * 必須（E），非必須（N），不明（n）
    * Baba T, Ara T, Hasegawa M, Takai Y, Okumura Y, Baba M, Datsenko KA, Tomita M, Wanner BL, Mori H (2006) Construction of Escherichia coli K-12 in-frame, single-gene knockout mutants: the Keio collection. Mol Syst Biol. 2, 2006.0008. doi: [10.1038/msb4100050](https://doi.org/10.1038/msb4100050)

## 使い方
```
% Rscript centrality_analysis_script.R | tee result.txt
```
### 出力ファイル
* ``result.txt``: 統計分析の結果
* ``Rplots.pdf``: 出力された図
