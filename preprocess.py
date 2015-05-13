import csv

def loadCSV(filename):
	reader = csv.DictReader(open(filename))
	data = [x for x in reader]
	return data
	
