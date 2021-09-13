import nltk
from nltk.tokenize import sent_tokenize
from nltk.tokenize import word_tokenize
from nltk.stem import PorterStemmer

facts = ['btp', 'cours', 'internship', 'gsoc', 'fellowship']
ps = PorterStemmer()
text = input("Describe what you have done particularly about your btp, courses, internships, gsoc and fellowship.(Enter input about each in separate line)\n")
# text = 'I have done a btp in DS. The course I have done are DS, DBMS, SM, FCS, SE, NS and OS.I have done an internship in data science. I have done a gsoc in game developement.'
sentences = sent_tokenize(text)
count = {}
count['btp'] = 0
count['cours'] = 0
count['extra'] = 0

f = open("jobfacts.txt", 'w+')
for sen in sentences:
	tokens = word_tokenize(sen)
	nouns = [ps.stem(word) for (word, pos) in nltk.pos_tag(tokens) if pos[:2] == 'NN']
	ind = -1

	for i in range(len(facts)):
		if(facts[i] in nouns):
			ind = i

	if(ind == -1):
		break

	for i in nouns:
		if(i != facts[ind]):
			if(facts[ind] == 'btp' or facts[ind] == 'cours'):
				f.write(facts[ind]+"('"+i+"').\n")
				count[facts[ind]] += 1
			else:
				f.write("extra('"+facts[ind]+"','"+i+"').\n")
				count['extra'] += 1

for i in count:
	if(count[i] == 0):
		if(i == 'extra'):
			f.write("extra('ss','ss').\n")
		else:
			f.write(i+"('ss').\n")			

f.close()

