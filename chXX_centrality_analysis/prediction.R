## 中心性指標をいくつか用いてRandom forestで予測する
# 機会学習手法（Random forestを含む）のパッケージを読み込む
if(!require(caret)) install.packages("caret")
library(caret)
# ROCカーブを書くためのパッケージを読み込む
if(!require(pROC)) install.packages("pROC")
library(pROC)

## データの前準備
# unknownの遺伝子を除外する。
d2 <- d[d$essential!="u",]
levels(d2$essential)[[3]] <- NA
# gene idを削除
d2 <- d2[-which("gene"==names(d2))]

d2$degree <- log(d2$degree)
d2$eigen <- log(d2$eigen)
d2$page <- log(d2$page)
d2$between <- log(d2$between+1)


# クロスバリデーションのために5分割する。
folds <- createFolds(d2$essential, k = 5)
  
## 
label_pred <- c()
label_actual <- c()
auc_set <- c()
for(idx in folds){
  # 訓練データ
  train <- d2[-idx,]
  # 検証データ
  test <- d2[idx,]
  # random forest
  #model <- train(essential~., data = train, method="rf", trControl = trainControl(method = "repeatedcv", number = 5), tuneLength = 20)

  # gradient boosting model
	#model <- train(essential~., data = train, method="gbm", trControl = trainControl(method = "repeatedcv", number = 5), tuneLength = 10)

  # xgboost
  #model <- train(essential~., data = train, method="xgbTree", trControl = trainControl(method = "repeatedcv", number = 5), tuneLength = 5)

  # SVM
	fitControl <- trainControl(method = "repeatedcv", number = 5, repeats =10, classProbs=TRUE)
	tGrid <- expand.grid(sigma=(1:10)*0.01, C= (1:10)*1)
	model <- train(
		essential~.,
		data=train, method="svmRadial",
		trControl = fitControl,
		tuneGrid = tGrid,
		preProc = c("center", "scale")
	)

  # 予測
  pred <- predict(model, test, type="prob")
  auc_set <- c(auc_set, multiclass.roc(test$essential, pred)$auc)

  label_pred <- rbind(label_pred, pred)
	label_actual <- c(label_actual, as.character(test$essential))
}
mean(auc_set)

# plot ROCs
multi.roc <- multiclass.roc(label_actual, label_pred)
rs <- multi.roc[['rocs']]
plot.roc(rs[[1]][[1]])



d2$degree <- log(d2$degree)
d2$eigen <- log(d2$eigen)
d2$page <- log(d2$page)
d2$between <- log(d2$between+1)
### PCA
pca_res <- prcomp(x=d2[-1], scale=T)
plot(pca_res$x[,1:2],col=d2$essential+1)


kmeans_res <- kmeans(d2[-1], 2)

# クラスタリング結果を表示
if(!require(fpc)) install.packages("fpc")
library(fpc)
plotcluster(d2[-1],kmeans_res$cluster,col=d2$essential+1)
