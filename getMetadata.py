# -*- coding: utf-8 -*-

import re, omdb, sys, requests, csv
from bs4 import BeautifulSoup
from preprocess import loadCSV
from FAscrapper import *

regex = re.compile("(tt\d{7})")
regex2 = re.compile("(\d{6})")
keys = ['metascore', 'FA_rating', 'year', 'tomato_rating', 'tomato_meter', 
		'plot', 'rated', 'tomato_rotten', 'title', 'tomato_consensus', 
		'writer', 'tomato_user_meter', 'production', 'actors', 'tomato_fresh', 
		'imdb_votes', 'type', 'tomato_user_reviews', 'website', 'poster', 
		'imdb_id', 'director', 'released', 'tomato_reviews', 'awards', 
		'tomato_user_rating', 'genre', 'response', 'language', 'dvd', 
		'imdb_rating', 'country', 'tomato_image', 'runtime', 'box_office']

# gets an url and returns the imdb code for the movie
def getCode(url):

	# Weird special cases
	if url[-3:-1] == "/I":
		url = url.replace("/I","")
	elif url == "1" or url == "":
		return None

	session = requests.Session()
	r = session.get(url)
	r.encoding='UTF-8'

	# Two outcomes: You get the movie page, or you get a search page with the movie
	code = regex.search(r.url)
	if code:
		return code.group(0)	
	else:
		code = regex2.search(r.url)
		if code:
			return code.group(0)
		else:
			session = requests.Session()
			r = session.get(url)
			r.encoding='UTF-8'
			data = r.text
			soup = BeautifulSoup(data)

			u = soup.find("td",{"class":"result_text"})
			if u:
				u = u.find('a')
				u = u['href']
				return u[7:16]
			else:
				return None


def generateDataFromURL(urls):

	total = len(urls)
	size=30
	data = []
	print "Downloading data for " + str(len(urls)) + " movies..."

	for i,url in enumerate(urls):
		progress = (i+1.0)/total
		print str(i) + " " + str(len(data)) + " [" + str(progress) + "] " + url
		if i != len(data):
			print "DESIGUALDAD"
		code = getCode(url)
		if code:
			response = omdb.imdbid(code, tomatoes=True, fullplot=True)
			print response
			if response:
				FA = FARating(response['title'],response['year'])
				response['FA_rating']=str(FA)
				#response['user_rating'] = movie[2]
				data.append(response) 
			else:
				data.append(dict.fromkeys(keys))
		else:
			data.append(dict.fromkeys(keys))
		
		# sys.stdout.write("\r[" + "=" * (int(round((progress*size)))-1) +">" +  " " * int(round((1-progress)*size)) 
		# 				+ "] "+ str(i+1) + "/" + str(total))
		# sys.stdout.flush()
		
	print
	return data


def generateDataFromID(ids):

	total = len(ids)
	size=30
	data = []
	print "Downloading data for " + str(len(ids)) + " movies..."

	for i,link in enumerate(ids):

		print str(i) + " " + str(len(data)) + " [" + str(i+1) + "/" + str(total) + "] " + link['imdbId']

		response = omdb.imdbid("tt" + link['imdbId'], tomatoes=True, fullplot=True)
		if response:
			FA = FARating(response['title'],response['year'])
			response['FA_rating']=str(FA)
			response['movieId'] = link['movieId']
			#response['user_rating'] = movie[2]
			data.append(response) 
		else:
			data.append(dict.fromkeys(keys))

		progress = (i+1.0)/total		
		# sys.stdout.write("\r[" + "=" * (int(round((progress*size)))-1) +">" +  " " * int(round((1-progress)*size)) 
		# 				+ "] "+ str(i+1) + "/" + str(total))
		# sys.stdout.flush()
		
	print
	return data


links = loadCSV("data/ml-latest-small/links.csv")


data = generateDataFromID(links)
save(data, "data/ml-latest-small/metadata.csv")