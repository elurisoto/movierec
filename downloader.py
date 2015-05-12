# This function loads a list of movie titles and generates a csv file containing 
# all the data pulled from OMDB about those movies.
import omdb, csv, sys, time
from FAscrapper import *

# Create a list of titles from the "Name" and "Year"field of a CSV file
def pullFromCSV(filename):
	titles = []
	with open(filename) as csvfile:
		reader = csv.DictReader(csvfile)
		for row in reader:
			titles.append([(row["Name"]).decode('utf-8'), row["Year"]])

	return titles

# Download the movie data to memory
def download(titles):

	total = len(titles)
	size=30
	data = []
	print "Downloading data for " + str(len(titles)) + " movies..."
	for i,movie in enumerate(titles):
		response = omdb.title(movie[0],year=movie[1], tomatoes=True)
		if response:
			FA = FARating(movie[0],movie[1])
			response['FA_rating']=str(FA)
			data.append(response) # For some movies with numbers in the title it doesnt answer, don't know why
		progress = (i+1.0)/total
		sys.stdout.write("\r[" + "=" * (int(round((progress*size)))-1) +">" +  " " * int(round((1-progress)*size)) + "] "+ str(i+1) + "/" + str(total) + " (" + str(progress*100) + "%)")
		sys.stdout.flush()
		
	print
	return data

# Write to csv
def writeCSV(data, filename):

	with open('data/' + filename, 'w') as csvfile:
		
		fieldsToSave = ['title','year','metascore','FA_rating','tomato_rating','tomato_meter','tomato_rotten','tomato_user_meter','tomato_fresh','imdb_votes','tomato_user_reviews','imdb_id','tomato_reviews','awards','tomato_user_rating','genre','imdb_rating','country','runtime','box_office']

		writer = csv.DictWriter(csvfile, fieldnames=fieldsToSave)

		writer.writeheader()
		for movie in data:
			#writer.writerow({k:v.encode('utf8') for k,v in movie.items()})
			writer.writerow({key:movie[key].encode('utf8') for key in fieldsToSave})


titles = pullFromCSV("data/lbxd/ratings.csv")
data=download(titles)
writeCSV(data,"output.csv")