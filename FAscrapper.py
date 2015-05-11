import requests
from bs4 import BeautifulSoup


# Generar url...

session = requests.Session()
url = "http://www.filmaffinity.com/en/film861601.html"
r = session.get(url)
r.encoding='UTF-8'

data = r.text
soup = BeautifulSoup(data)

nota = soup.find(id="movie-rat-avg").get_text()
nota = float(nota.strip())
print nota