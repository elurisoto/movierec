# This function loads a list of movie titles and generates a csv file containing 
# all the data pulled from OMDB about those movies.
import omdb, csv, sys, time

# Create a list of titles from the "Name" and "Year"field of a CSV file
def pullFromCSV(filename):
	titles = []
	with open(filename) as csvfile:
		reader = csv.DictReader(csvfile)
		for row in reader:
			title = row["Name"]
			titles.append([(row["Name"]).decode('utf-8'), row["Year"]])

	return titles

# Download the movie data to memory
def download(titles):

	total = len(titles)
	size=30
	data = []
	print "Downloading..."
	for i,movie in enumerate(titles):
		response = omdb.title(movie[0],year=movie[1], tomatoes=True)
		if response:
			data.append(response) # For some movies it doesnt answer, don't know why
		progress = (i+1.0)/total
		sys.stdout.write("\r[" + "=" * (int(round((progress*size)))-1) +">" +  " " * int(round((1-progress)*size)) + "]"+  str(progress*100) + "%")
		sys.stdout.flush()
		
	print
	return data

# Write to csv
def writeCSV(data, filename):

	with open('data/' + filename, 'w') as csvfile:
		
		writer = csv.DictWriter(csvfile, fieldnames=data[0].keys())

		writer.writeheader()
		for movie in data:
			writer.writerow({k:v.encode('utf8') for k,v in movie.items()})


titles = pullFromCSV("data/lbxd/ratings.csv")
data=download(titles)
writeCSV(data,"output.csv")