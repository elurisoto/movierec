# This function loads a list of movie titles and generates a csv file containing 
# all the data pulled from OMDB about those movies.
import omdb, csv, sys, time
from FAscrapper import *

# Create a list of titles from the "Name", "Year" and field of a CSV file
def pullFromCSV(filename):
	titles = []
	with open(filename) as csvfile:
		reader = csv.DictReader(csvfile)
		for row in reader:
			titles.append([(row["Name"]).decode('utf-8'), row["Year"], row["Rating"]])

	return titles

# Download the movie data to memory
def generateData(titles):

	total = len(titles)
	size=30
	data = []
	print "Downloading data for " + str(len(titles)) + " movies..."

	for i,movie in enumerate(titles):
		response = omdb.title(movie[0],year=movie[1], tomatoes=True)
		if response:
			if response['tomato_rating'] != 'N/A':

				FA = FARating(movie[0],movie[1])
				response['FA_rating']=str(FA)
				response['user_rating'] = movie[2]
				response['imdb_votes'] = response['imdb_votes'].replace(',','')
				response['box_office'] = response['box_office'].replace('$','').replace('M','')

				data.append(response) 
		progress = (i+1.0)/total
		sys.stdout.write("\r[" + "=" * (int(round((progress*size)))-1) +">" +  " " * int(round((1-progress)*size)) 
						+ "] "+ str(i+1) + "/" + str(total) + " (" + str(progress*100) + "%)")
		sys.stdout.flush()
		
	print
	return data

# Write to csv
def writeCSV(data, filename):

	with open(filename, 'w') as csvfile:
		
		fieldsToSave = ['title','year','metascore','FA_rating','tomato_rating','tomato_meter','tomato_rotten',
						'tomato_user_meter','tomato_fresh','imdb_votes','tomato_user_reviews','imdb_id','tomato_reviews',
						'awards','tomato_user_rating','genre','imdb_rating','country','runtime','box_office','user_rating']

		writer = csv.DictWriter(csvfile, fieldnames=fieldsToSave)

		writer.writeheader()
		for movie in data:
			writer.writerow({key:movie[key].encode('utf8') for key in fieldsToSave})


def pullAndSave(movieListPath, outputFile):
	titles = pullFromCSV(movieListPath)
	data=generateData(titles)
	writeCSV(data,outputFile)

if __name__ == "__main__":
	pullAndSave("data/lbxd/ratings.csv","data/output.csv")