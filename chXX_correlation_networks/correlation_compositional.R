# Matrixパッケージの読み込み（ないならインストールする）
if(!require(Matrix)) install.packages("Matrix")
library(Matrix)
# Hmiscパッケージの読み込み（ないならインストールする）
if(!require(Hmisc)) install.packages("Hmisc") 
library(Hmisc)
# ppcorパッケージの読み込み（ないならインストールする）
if(!require(ppcor)) install.packages("ppcor") 
library(ppcor)
# SpiecEasiパッケージの読み込み（ないならインストールする）
if(!require(SpiecEasi)) install.packages("SpiecEasi")
library(SpiecEasi)
# P値で閾値化するための関数を読み込む
source("thresholding.p.value.R")
# ランダム行列理論で閾値化するための関数を読み込む
source("thresholding.RMT.R")
# その他必要な関数を読み込む
source("utils.R")

## 擬似データセットの作成
# 人工的な正解ネットワークを作成し，そのネットワーク構造に従って分散共分散行列を作る。
data <- generate_covariance_matrix(nn=30, k_ave=4, type.network="sf")
# @param nn ノード数
# @param k_ave a平均次数
# @param type.network ネットワーク構造
#               random: ランダムネットワーク
#                   sf: スケールフリーネットワーク
#                   sw: スモールワールドネットワーク

# 正解ネットワークのグラフオブジェクトを得る。
g_real <- data[[1]]
# 分散共分散行列を得る。
x.cor <- data[[2]] 
# 分散共分散行列に従い，多変量正規分布で相関した乱数をサンプル数300で作成する。
x_abs <- mvrnorm(300, rep(5,dim(x.cor)[[1]]), Sigma=nearPD(x.cor, corr = T, keepDiag = T)$mat)
# 相対データに変換
x_rel <- x_abs / apply(x_abs,1,sum)

cat("### ピアソン相関を使ったネットワーク推定\n")
# ピアソン相関
cormtx_abs <- rcorr(x_abs, type="pearson")
cormtx_rel <- rcorr(x_rel, type="pearson")
# 相関係数行列の取得
rmtx_abs <- cormtx_abs$r
rmtx_rel <- cormtx_rel$r
# P値行列の取得
pmtx_abs <- cormtx_abs$P
pmtx_rel <- cormtx_rel$P

cat("## P値に基づく閾値化（local FDRによる補正有り）\n")
# p値の閾値（p.th）を0.05とする
cat("# 絶対量データの場合\n")
g_pred_abs <- thresholding.p.value(pmtx_abs, p.th=0.05, method="lfdr")
network_prediction_performance(g_real, g_pred_abs)
cat("# 相対量データの場合\n")
g_pred_rel <- thresholding.p.value(pmtx_rel, p.th=0.05, method="lfdr")
network_prediction_performance(g_real, g_pred_rel)

cat("## ランダム行列理論による閾値化\n")
cat("# 絶対量データの場合\n")
g_pred_abs <- thresholding.RMT(rmtx_abs)
network_prediction_performance(g_real, g_pred_abs)
cat("# 相対量データの場合\n")
g_pred_rel <- thresholding.RMT(rmtx_rel)
network_prediction_performance(g_real, g_pred_rel)

cat("### SparCCを使ったネットワーク推定\n")
spboot <- sparccboot(x_abs, R=100, ncpus=2)
# @param R Bootstrap数
# @param ncpus 並列に使うCPUの数

cat("## P値に基づく閾値化（補正あり）\n")
# P値行列の作成
n <- dim(x_abs)[[2]]
m <- matrix(0, n, n)
m[upper.tri(m)] <- pval.sparccboot(spboot)$pvals
m <- m + t(m)
diag(m) <- 1
m <- ifelse(is.nan(m),1,m)
# p値の閾値（p.th）を0.05とする
g_pred_rel <- thresholding.p.value(m, p.th=0.05, method="BH")
network_prediction_performance(g_real, g_pred_rel)

cat("## ランダム行列理論による閾値化\n")
# 相関係数行列の作成
n <- dim(x_rel)[[2]]
m <- matrix(0, n, n)
m[upper.tri(m)] <- pval.sparccboot(spboot)$cors
m <- m + t(m)
diag(m) <- 1
m <- ifelse(is.nan(m),0,m)

g_pred_rel <- thresholding.RMT(rmtx_rel)
network_prediction_performance(g_real, g_pred_rel)


cat("### SpiecEasiを使ったネットワーク推定\n")
se <- spiec.easi(x_abs, method="mb")
g_pred_rel <- adj2igraph(getRefit(se))
network_prediction_performance(g_real, g_pred_rel)