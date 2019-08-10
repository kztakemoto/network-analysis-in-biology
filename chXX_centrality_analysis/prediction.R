## 中心性指標をいくつか用いてRandom forestで予測する
# 機会学習手法（Random forestを含む）のパッケージを読み込む
if(!require(caret)) install.packages("caret")
library(caret)

## データの前準備
# gene idを削除
d2 <- d2[-which("gene"==names(d2))]
# クロスバリデーションのために5分割する。
folds <- createFolds(d2$essential, k = 5)
  
## 
auc_set <- c()
for(idx in folds){
      # 訓練データ
      train <- d2[-idx,]
    # 検証データ
    test <- d2[idx,]
        # random forest
        model <- train(essential~., data = train, method="rf", preProcess = c('center', 'scale'), trControl = trainControl(method = "cv"))
        #trainControl(method = "repeatedcv", number = 5, repeats = 5), tuneLength = 5)
        #model <- randomForest(essential~degree+between, data=train)
        #pred <- predict(model, test, type="response")
        # 予測
        pred <- predict(model, test, type="raw")
	    auc_set <- c(auc_set, roc(test$essential, pred)$auc)
}
mean(auc_set)
