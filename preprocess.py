import csv,copy, re

possibleGenres = {
'Action':		False,		'Adventure':	False,
'Animation':	False,		'Biography':	False,
'Comedy':		False,		'Crime':		False,
'Documentary':	False,		'Drama':		False,
'Family':		False,		'Fantasy':		False,
'Film-Noir':	False,		'History':		False,
'Horror':		False,		'Music':		False,
'Musical':		False,		'Mystery':		False,
'Romance':		False,		'Sci-Fi':		False,
'Sport':		False,		'Thriller':		False,
'War':			False,		'Western':		False
}

oscarsRE = re.compile("Won (?:\d*\.)?\d+ Oscar")
numberRE = re.compile("(?:\d*\.)?\d+")


def loadCSV(filename):
	reader = csv.DictReader(open(filename))
	data = [x for x in reader]
	return data
	
# Converts a list of genres into a dictionary of booleans
def convertGenres(genres):
	genres = genres.replace(' ','').split(',')
	dictionary = copy.copy(possibleGenres)
	for genre in genres:
		dictionary[genre] = True
	return dictionary

# Returns the number of oscars that a movie recieved
def processOscars(text):
	numOscars = 0
	oscars = oscarsRE.search(text)
	if oscars:
		numOscars = (numberRE.search(oscars.group(0))).group(0)
	return numOscars


# Changes the format of some rows to make the data more easy to compute
def addaptFormat(data):
	for row in data:
		row['imdb_votes'] = row['imdb_votes'].replace(',','')
		row['box_office'] = row['box_office'].replace('$','').replace('M','')
		genres = convertGenres(row['genre'])
		row.update(genres)
		row['oscars'] = processOscars(row['awards'])

	return data

def save(data, filename):
	with open(filename, 'w') as csvfile:
		writer = csv.DictWriter(csvfile, data[0].keys())

		writer.writeheader()
		for movie in data:
			writer.writerow({key:movie[key] for key in movie.keys()})

if __name__=="__main__":
	data = loadCSV("data/output.csv")
	data = addaptFormat(data)
	save(data, "data/outputPreprocessed.csv")


