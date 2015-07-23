

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