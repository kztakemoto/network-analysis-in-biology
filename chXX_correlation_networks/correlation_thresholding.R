# Matrixパッケージの読み込み（ないならインストールする）
if(!require(Matrix)) install.packages("Matrix")
library(Matrix)
# Hmiscパッケージの読み込み（ないならインストールする）
if(!require(Hmisc)) install.packages("Hmisc") 
library(Hmisc)
# ppcorパッケージの読み込み（ないならインストールする）
if(!require(ppcor)) install.packages("ppcor") 
library(ppcor)
# P値で閾値化するための関数を読み込む
source("thresholding.p.value.R")
# ランダム行列理論で閾値化するための関数を読み込む
source("thresholding.RMT.R")
# その他必要な関数を読み込む
source("utils.R")

## 擬似データセットの作成
# 人工的な正解ネットワークを作成し，そのネットワーク構造に従って分散共分散行列を作る。
data <- generate_covariance_matrix(nn=250, k_ave=4, type.network="sf")
# @param nn ノード数
# @param k_ave average degree (number of edges per node)
# @param type.network ネットワーク構造
#               random: ランダムネットワーク
#                   sf: スケールフリーネットワーク
#                   sw: スモールワールドネットワーク

# 正解ネットワークのグラフオブジェクトを得る。
g_real <- data[[1]]
# 分散共分散行列を得る。
x.cor <- data[[2]] 
# 分散共分散行列に従い，多変量正規分布で相関した乱数をサンプル数300で作成する。
x <- mvrnorm(300, rep(0,dim(x.cor)[[1]]), Sigma=nearPD(x.cor, corr = T, keepDiag = T)$mat)


## ペアワイズ相関検定によるネットワーク推定
# ピアソン相関の場合
cormtx <- rcorr(x, type="pearson")
# スピアマン相関の場合
#cormtx <- rcorr(x, type="spearman")

# 相関係数行列の取得
rmtx <- cormtx$r
# P値行列の取得
pmtx <- cormtx$P

cat("## P値に基づく閾値化\n")
# 補正なし
cat("# 補正なし\n")
g_pred <- thresholding.p.value(pmtx, method="none")
network_prediction_performance(g_real, g_pred)
cat("# Bonferroni\n")
g_pred <- thresholding.p.value(pmtx, method="bonferroni")
network_prediction_performance(g_real, g_pred)
cat("# Benjamini-Hochberg\n")
g_pred <- thresholding.p.value(pmtx, method="BH")
network_prediction_performance(g_real, g_pred)
cat("# local FDR\n")
g_pred <- thresholding.p.value(pmtx, method="lfdr")
network_prediction_performance(g_real, g_pred)

cat("## ランダム行列理論による閾値化\n")
g_pred <- thresholding.RMT(rmtx)
network_prediction_performance(g_real, g_pred)
