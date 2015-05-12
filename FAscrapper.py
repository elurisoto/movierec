import requests
from bs4 import BeautifulSoup

def getSearchURL(title,year):
	return "http://www.filmaffinity.com/en/advsearch.php?stext=" + title + "&fromyear=" + str(year) + "&toyear=" +str(year)


def getMovieURL(searchURL):
	session = requests.Session()
	r = session.get(searchURL)
	r.encoding='UTF-8'

	data = r.text
	soup = BeautifulSoup(data)

	moviedata = soup.find("div",{"class":"mc-title"}).find('a')
	return "http://www.filmaffinity.com" + moviedata['href']


def getRating(movieURL):
	session = requests.Session()
	r = session.get(movieURL)
	r.encoding='UTF-8'

	data = r.text
	soup = BeautifulSoup(data)

	nota = soup.find(id="movie-rat-avg").get_text()
	return float(nota.strip())

def FARating(title,year):
	searchurl = getSearchURL(title, year)
	movieurl = getMovieURL(searchurl)
	return getRating(movieurl)

