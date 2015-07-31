# This file contains the functions necessary to obtain the 3 main matrixes used:
# The genre, contributors, and synopsis matrix
library(data.table)
library(Matrix)
library(tm)
library(SnowballC) 

## Genre matrix
genres <- c("Action", "Adventure", "Animation", "Children", 
						"Comedy", "Crime", "Documentary", "Drama", "Fantasy", 
						"Film-Noir", "Horror", "Musical", "Mystery", "Romance", 
						"Sci-Fi", "Thriller", "War", "Western", "IMAX")
emptyGenres = rep(FALSE, length(genres))
names(emptyGenres) <- genres


getGenres <- function(x){
	aux = emptyGenres
	x <- strsplit(x, split="|", fixed=TRUE)[[1]]
	for(i in 1:length(x)){
		if(x[i] != "(no genres listed)")
			aux[x[i]] = TRUE
	}
	aux
}


getGenreMatrix <- function(){

	movieData <- read.csv(file = "data/ml-latest-small/movies.csv", header = TRUE, sep=",")
	ids <- movieData$movieId
	l <- lapply(as.character(movieData$genres), getGenres)
	df <-as.data.frame(do.call(rbind, l))
	df$movieId <- ids
	df*1
}

count = function(x) {
	data.table(x)[, .N, keyby = x]
}

# Contributors matrix
getContributorsMatrix <- function(){
	metadata <- read.csv("data/ml-latest-small/metadata.csv", header=TRUE, na.strings = "N/A")
	ids <- metadata$movieId
	contributors <- paste(metadata$actors, metadata$writer, metadata$director, sep=", ")
	# Remove parentheses
	contributors <- gsub( " *\\(.*?\\) *", "", contributors)

	# Now count which contributors appear in more than two movies
	contributors <- lapply(contributors, function(x) strsplit(x, split=", ", fixed=TRUE)[[1]])
	c <- unlist(c)
	c <- c[c != "NA"]
	
	appearances <- count(c)
	selected <- appearances$N > 2 & !duplicated(appearances$x)
	selected.names <- appearances[selected]$x
	
	# Generate the sparse matrix
	m <- Matrix(0, ncol = length(selected.names)+1, nrow=nrow(metadata), sparse=TRUE, 
							dimnames=list(as.character(1:nrow(metadata)),c("movieId",selected.names)))	
	
	m[,"movieId"] <- ids
	
	for(i in 1:length(contributors)){
		l <- contributors[i][[1]][contributors[i][[1]] %in% colnames(m)]
		m[i,l] = m[i,l] +1
	}
	
	as.matrix(m)
}

getSynopsisMatrix <- function(){
	metadata <- read.csv("data/ml-latest-small/metadata.csv", header=TRUE, 
											 stringsAsFactors = FALSE, na.strings = "N/A")
	text <- metadata$plot
	text[is.na(text)] = "noplot"
	corpus <- VCorpus(VectorSource(text))
	corpus <- tm_map(corpus, content_transformer(tolower))
	corpus <- tm_map(corpus, removeWords, stopwords("english"))
	corpus <- tm_map(corpus, removeNumbers)
	corpus <- tm_map(corpus, stripWhitespace)
	corpus <- tm_map(corpus, removePunctuation)
	corpus <- tm_map(corpus, stemDocument)
	corpus <- tm_map(corpus, stripWhitespace)
	
	dtm <- DocumentTermMatrix(corpus)
	
	# Only save terms that appear in 5 or more movies
	dtm <- dtm[,findFreqTerms(dtm,5)]
	dtm_tfidf <- weightTfIdf(dtm)
	m <- as.matrix(dtm_tfidf)
	names <- colnames(m)
	
	m <- cbind(m,metadata$movieId)
	colnames(m) <- c(names, "movieId")
	m
}

getTagsMatrix <- function(){
	tags <- read.csv("data/ml-latest-small/tags.csv", header=TRUE, 
											 stringsAsFactors = FALSE, na.strings = "N/A")
	movieData <- read.csv(file = "data/ml-latest-small/movies.csv", header = TRUE, sep=",")
	
	text <- tags$tag
	corpus <- VCorpus(VectorSource(text))
	corpus <- tm_map(corpus, content_transformer(tolower))
	corpus <- tm_map(corpus, removeWords, stopwords("english"))
	corpus <- tm_map(corpus, removeNumbers)
	corpus <- tm_map(corpus, stripWhitespace)
	corpus <- tm_map(corpus, removePunctuation)
	corpus <- tm_map(corpus, stemDocument)
	corpus <- tm_map(corpus, stripWhitespace)
	
	df<- data.frame(text=unlist(sapply(corpus, `[`, "content")), stringsAsFactors=F)
	df$movieId <- tags$movieId
	names(df) = c("tag", "movieId")
	 
	tagsByMovie <- aggregate(tag ~ movieId, df, paste)
	 
	taglist <- df[!duplicated(df$tag),]$tag
	 
	m <- Matrix(0, ncol = length(taglist)+1, nrow=nrow(metadata), sparse=TRUE, 
							dimnames=list(as.character(1:nrow(metadata)),c("movieId",taglist)))	
	 
	m[,"movieId"] <- movieData$movieId
	 
	for(i in 1:nrow(tagsByMovie)){
		for(j in 1:length(tagsByMovie[i,]$tag[[1]])){
			t <- colnames(m) %in% tagsByMovie[i,]$tag[[1]][j]
			m[i,t] = m[i,t] +1
		}
	}
	 
	as.matrix(m)
}



users <- read.csv(file = "data/ml-latest-small/ratings.csv", header = TRUE, sep=",")
# Most active userId: 516

write.csv(users[users$userId == 516,], "data/ml-latest-small/biggestUser.csv", row.names = FALSE)
write.csv(getGenreMatrix(), "data/ml-latest-small/genreMatrix.csv", row.names = FALSE)
write.csv(getContributorsMatrix(), "data/ml-latest-small/contributorMatrix.csv", row.names = FALSE)
write.csv(getSynopsisMatrix(), "data/ml-latest-small/synopsisMatrix.csv", row.names = FALSE)
write.csv(getTagsMatrix(), "data/ml-latest-small/tagsMatrix.csv", row.names = FALSE)
