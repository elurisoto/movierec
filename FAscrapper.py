import requests
from bs4 import BeautifulSoup

def getSearchURL(title,fromyear,toyear):
	return "http://www.filmaffinity.com/en/advsearch.php?stext=" + title + "&fromyear=" + str(fromyear) + "&toyear=" +str(toyear)


def getMovieURL(searchURL):
	session = requests.Session()
	r = session.get(searchURL)
	r.encoding='UTF-8'

	data = r.text
	soup = BeautifulSoup(data)

	moviedata = soup.find("div",{"class":"mc-title"})
	if moviedata:
		moviedata = moviedata.find('a')
		return "http://www.filmaffinity.com" + moviedata['href']
	else:
		return None


def getRating(movieURL):
	session = requests.Session()
	r = session.get(movieURL)
	r.encoding='UTF-8'

	data = r.text
	soup = BeautifulSoup(data)

	rating = soup.find(id="movie-rat-avg").get_text()
	return float(rating.strip())

def FARating(title,year):
	searchurl = getSearchURL(title, year,year)
	movieurl = getMovieURL(searchurl)
	if movieurl:
		return getRating(movieurl)
	else:
		searchurl = getSearchURL(title, year-1, year+1)
		movieurl = getMovieURL(searchurl)
		if movieurl:
			return getRating(movieurl)
		else:
			return None

