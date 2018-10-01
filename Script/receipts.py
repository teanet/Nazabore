#!/usr/bin/env python
import os
import json
import logging

logging.basicConfig(level=logging.INFO,
                    format="%(asctime)s %(levelname)s %(message)s")

script_dir = os.path.dirname(os.path.realpath(__file__))
fileName = "receipts.json"
cleanFileName = "clean_receipts.json"
outputFileName = "receiptQueries.log"
filePath = os.path.join(script_dir, fileName)
cleanFilePath = os.path.join(script_dir, cleanFileName)
outputFilePath = os.path.join(script_dir, outputFileName)

def main():
	cleanJson()
	readJson()

def cleanJson():
	logging.info("Creating temporary file with clean JSON")
	delete_list = [")", "ISODate(", ")", ".000Z", "NumberLong("]
	fin = open(filePath)
	fout = open(cleanFilePath, "w+")
	for line in fin:
		for word in delete_list:
			line = line.replace(word, "")
		fout.write(line)
	fin.close()
	fout.close()

def readJson():
	logging.info("Parse JSON")
	fout = open(outputFilePath, "w+")
	with open(cleanFilePath) as json_file: 
		data = json.load(json_file)
		for p in data:
			documentId = p["documentId"]
			fsId = p["fsId"]
			content = p["content"]
			date = content["dateTime"].replace("-","").replace(":","")[:-2]
			fiscalSign = content["fiscalSign"]
			operationType = content["operationType"]
			ts = str(content["totalSum"])
			position = len(ts) - 2
			totalSum = ts[:position] + "." + ts[position:]
			q = "t=" + date + "&s=" + totalSum + "&fn=" + fsId + "&i=" + str(documentId) + "&fp=" + str(fiscalSign) + "&n=" + str(operationType) + "\n"
			fout.write(q)
	fout.close()
	os.remove(cleanFilePath)
	logging.info("Temporary file removed")
	logging.info("Output file: " + outputFilePath)

if __name__ == "__main__":
	main()
