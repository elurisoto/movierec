require(robCompositions)
require(mice)

data <- read.csv("data/outputAlexPreprocessed.csv", header = TRUE, na.strings = c("N/A","None","NA"), stringsAsFactors=FALSE)
types <- lapply(data,class)
numerics <- data[types=="integer" | types =="numeric"][-17]
target <- data$user_rating

# Missing value imputation
imputed <- impKNNa(numerics, primitive=TRUE, metric = "Euclidean", k=17)$xImp

numerics.pca <- prcomp(imputed, center=TRUE, scale=TRUE)
summary(numerics.pca)



library(devtools)
install_github("ggbiplot", "vqv")

library(ggbiplot)
g <- ggbiplot(numerics.pca, obs.scale = 1, var.scale = 1, 
							 ellipse = TRUE, 
							circle = TRUE)
g <- g + scale_color_discrete(name = '')
g <- g + theme(legend.direction = 'horizontal', 
							 legend.position = 'top')
print(g)
