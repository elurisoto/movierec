# This file contains the functions necessary to obtain the 3 main matrixes used:
# The genre, contributors, and synopsis matrix
library(rPython)
library(data.table)
library(Matrix)


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
	l <- lapply(as.character(movieData$genres), getGenres)
	df <-as.data.frame(do.call(rbind, l))
	df$movieId <- 1:nrow(df)
	df
}

count = function(x) {
	data.table(x)[, .N, keyby = x]
}



# Contributors matrix
getContributorsMatrix <- function(){
	metadata <- read.csv("data/ml-latest-small/metadata.csv", header=TRUE, na.strings = "N/A")
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
	
	m[,"movieId"] <- 1:8570
	
	for(i in 1:length(contributors)){
		l <- contributors[i][[1]][contributors[i][[1]] %in% colnames(m)]
		m[i,l] = m[i,l] +1
	}
	
	m
}


