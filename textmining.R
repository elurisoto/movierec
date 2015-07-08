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
	hist(results$cluster, breaks=numclusters)
	
}


