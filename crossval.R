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

# Write the data in different files to use later
write.csv(imputed, "data/imputados.csv", row.names = FALSE)
write.csv(numerics.pca$x, "data/pca/data.csv", row.names = FALSE)
write.csv(numerics.pca$scale, "data/pca/scale.csv", row.names = FALSE)
write.csv(numerics.pca$center, "data/pca/center.csv", row.names = FALSE)
write.csv(numerics.pca$rotation, "data/pca/rotation.csv", row.names = FALSE)
write.csv(target, "data/pca/target.csv", row.names = FALSE)
write.csv(data[types=="integer" | types =="numeric"], "data/numericos.csv", row.names = FALSE)
write.csv(data[types!="integer" & types!="numeric"], "data/nonumericos.csv", row.names = FALSE)
write.csv(imputed, "data/imputados.csv", row.names = FALSE)
col.gender = c(1, 2, 4, 6, 7, 8, 10, 11, 21,22,23,26,31,32,42,44,45,46,47,51,57,58)
write.csv(data[,col.gender], "data/generos.csv", row.names=FALSE)
write.csv(cor(cbind(imputed,target)), "results/matriz correlacion.csv")

# To project new data into the new space: scale(newdata,pca$center,pca$scale) %*% pca$rotation 
