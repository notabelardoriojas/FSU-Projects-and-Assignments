#Abelardo Riojas, ISC 4304C FSUID ar18aa
myfile = open('monteCristo.txt', 'r')
text = myfile.read().replace('\n', ' ').replace('\r',' ').replace('\t', ' ')

#print(text)
def getSentences(text):
	sentences = text.split('.')
	return sentences
sentences = getSentences(text)
#print (sentences)

def wordCount(listofsentences):
	summ = 0
	for sentence in listofsentences:
		sentence = sentence.split()
		summ += len(sentence)
	return summ

wordcount = wordCount(sentences)
print "Average word count: " + str(wordcount/len(sentences))

def wordLength(text):
	words = text.split()
	Sum = 0
	for word in words:
		Sum += len(word)
	return Sum
wordlen = wordLength(text)	
print "Average word length: " + str(wordlen/wordcount)
#question: could I have just done text.count(" ") + 1?
#top 100 words
words = text.split()
wordDict = {}
for word in words:
	wordDict[word] = 1
for word in words:
	if wordDict[word] >= 1:
		wordDict[word] += 1
wordlist = sorted(wordDict, key=wordDict.get, reverse=True)
x = 0
print ("The top 100 words in the text:")
while x <= 99:
	print x+1, wordlist[x]
	x += 1

def nLetterWords(text):
	c = [0] * 21
	words = text.split()
	for word in words:
		if len(word) > 20:
			c[0] += 1
		else:
			c[len(word)] += 1
	return c
c = nLetterWords(text) 
num = 0
for count in c:
	if num == 0:
		print " "
		num += 1
	else:
		print "Number of " + str(num) + "-letter words in text: " + str(c[num])
		num += 1



