import csv,copy, re

#############################################################################
# Here we preprocess the data to pass it to Matlab's neural network toolbox #
#############################################################################

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

def processBoxOffice(text):
	if text[-1]=='M':
		return float(text.replace('$','').replace('M',''))
	elif text[-1]=='k':
		k = float(text.replace('$','').replace('k',''))
		return k/1000.0
	else:
		return text

def processIMDBVotes(text):
	return text.replace(',','')
# Changes the format of some rows to make the data easier to compute 
# and delete some string rows since matlab doesn't like them.
def adaptFormat(data):
	for row in data:
		
		row['runtime'] = row['runtime'].replace(' min','')
		genres = convertGenres(row['genre'])
		row.update(genres)
		row['oscars'] = processOscars(row['awards'])
		row['box_office'] = processBoxOffice(row['box_office'])
		row['imdb_votes'] = processIMDBVotes(row['imdb_votes'])

		# del row['awards']
		# del row['genre']
		# del row['title']
		# del row['box_office'] #This is temporary

	return data

def save(data, filename):
	with open(filename, 'w') as csvfile:


		keys = data[0].keys()

		writer = csv.DictWriter(csvfile, keys)
		writer.writeheader()
		for movie in data:
			writer.writerow({key:movie[key].encode('utf-8') for key in keys})

if __name__=="__main__":
	data = loadCSV("data/outputAlex.csv")
	data = adaptFormat(data)
	save(data, "data/outputAlexPreprocessed.csv")

