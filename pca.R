require(robCompositions)
require(mice)

data <- read.csv("data/outputAlexPreprocessed.csv", header = TRUE, na.strings = c("N/A","None","NA"), stringsAsFactors=FALSE)
types <- lapply(data,class)
numerics <- data[types=="integer" | types =="numeric"][-17]
target <- data$user_rating

#Keep only variables that may have useful information

# Missing value imputation
imputed <- impKNNa(numerics, primitive=TRUE, metric = "Euclidean", k=17)$xImp

