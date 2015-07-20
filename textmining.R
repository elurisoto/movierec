library(tm)
library(SnowballC) 
library(skmeans)

textClusters <- function(k, text){
	
	corpus <- VCorpus(VectorSource(text))
	corpus <- tm_map(corpus, content_transformer(tolower))
	corpus <- tm_map(corpus, removeWords, stopwords("english"))
	corpus <- tm_map(corpus, removeNumbers)
	corpus <- tm_map(corpus, stripWhitespace)
	corpus <- tm_map(corpus, removePunctuation)
	corpus <- tm_map(corpus, stemDocument)
	corpus <- tm_map(corpus, stripWhitespace)
	
	
	dtm <- DocumentTermMatrix(corpus)
	
	dtm_tfidf <- weightTfIdf(dtm)
	
	m <- as.matrix(dtm_tfidf)
	
	results <- skmeans(m, k, method = "genetic")
	
	return(results)
}

textClusters.info <- function(results){
	numclusters <- max(results$cluster)
	clusters <- 1:numclusters
	for(i in clusters){
		cat("Cluster ", i, ":", names(sort(results$prototypes[i,],decreasing=TRUE))[1:10],"\n")
	}
	hist(results$cluster)
	
}

imputados <- read.csv("data//imputados.csv")
data <- read.csv("data/outputAlexPreprocessed.csv", header = TRUE, 
								 na.strings = c("N/A","None","NA"), stringsAsFactors=FALSE)
data[is.na(data$tomato_consensus),]$tomato_consensus <- "No_review"

for(numclusters in 16:25){
	print(numclusters)
	results <- textClusters(numclusters, paste(data$plot,data$tomato_consensus))
	
	write.csv(results$cluster, paste("data/clusters/",numclusters, ".csv", sep="") 
						,row.names = FALSE)
	
}
# numclusters <- 5
# 
# 
# results <- textClusters(numclusters, paste(data$plot,data$tomato_consensus))
# imputados$Clusters <- results$cluster
# # imputados$plotClusters <- textClusters(numclusters, data$plot)$cluster
# write.csv(imputados, "data/imp_textmining_combined.csv", row.names = FALSE)
