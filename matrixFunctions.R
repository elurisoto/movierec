# This file contains the functions necessary to obtain the 3 main matrixes used:
# The genre, contributors, and synopsis matrix
library(rPython)

## Genre matrix
getMovieData <- function(){
	movieData <- read.csv(file = "data/ml-100k/u.item", header = FALSE, sep="|")
	names(movieData) <- c("code", "title", "date", "url", "unknown", "Action", 
												"Adventure", "Animation", "Children's", "Comedy", "Crime", 
												"Documentary", "Drama", "Fantasy", "Film-Noir", "Horror", 
												"Musical", "Mystery", "Romance", "Sci-Fi", "Thriller", 
												"War", "Western")
	movieData
}

getGenreMatrix <- function(movieData){
	movieData[5:23]
}

# Contributors matrix
# To download the contributors we will use a python function that downloads metadata
# for the movies, and then select the contributors.

getMetadata <- function(movieData){
	python.load('FAscrapper.py')
	python.load('getMetadata.py')
	metadata <- python.call('generateData', as.character(movieData$url))
	metadata
}
metadata <- getMetadata(movieData)
