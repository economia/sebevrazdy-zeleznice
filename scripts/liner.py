# coding=utf-8

import csv

#30.08.2013 14:09

def toDate(datum):
	try:
		date = datum.split(" ")[0]
		time = datum.split(" ")[1]
	
		year = date.split(".")[2]
		month = date.split(".")[1]
		day = date.split(".")[0]
	
		hour = time.split(":")[0]
		min = time.split(":")[1]
		sec = "00"
	
		return year + month + day +hour + min + sec
	except:
		return ""


def toSingleRow(input):
	array = input[0]
	arr = array.split(", ")
	if (len(arr) > 1):
		for id in arr:
			print id + "	" + row[1] + "	"+ toDate(row[2]) + "	"+ toDate(row[3]) + "	"+ row[4]
	else:
		print row[0] + "	" + row[1] + "	"+ toDate(row[2]) + "	"+ toDate(row[3]) + "	"+ row[4]


with open('skokani.csv', 'rb') as csvfile:
	spamreader = csv.reader(csvfile, delimiter='	', quotechar='"')
	for row in spamreader:
		toSingleRow(row)