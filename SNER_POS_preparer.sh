#!/bin/bash


mkdir my_project
cd my_project

ner_zip="stanford-ner-2016-10-31.zip"
postag_zip="stanford-postagger-2016-10-31.zip"


# NOTE: need to update link for further versions
#wget http://nlp.stanford.edu/software/stanford-ner-2014-08-27.zip
if [[ ! -f $ner_zip ]]; then
	echo " . . . Downloading file stanford-ner-2016-10-31.zip"
	wget http://nlp.stanford.edu/software/stanford-ner-2016-10-31.zip
fi


if [[ ! -f $postag_zip ]]; then
	echo " . . . Downloading file stanford-poostagger-2016-10-31.zip"
	wget http://nlp.stanford.edu/software/stanford-postagger-2016-10-31.zip
fi

echo " . . . Unpacking stanford-ner-2016-10-31.zip"
echo " . . . Unpacking stanford-postagger-2016-10-31.zip"

rm -rf stanford-ner-2016-10-31
rm -rf stanford-postagger-2016-10-31

unzip stanford-ner-2016-10-31.zip
unzip stanford-postagger-2016-10-31.zip


mkdir -p stanford-ner
cp -f stanford-ner-2016-10-31/stanford-ner.jar stanford-ner/stanford-ner.jar
cp -f stanford-ner-2016-10-31/classifiers/english.all.3class.distsim.crf.ser.gz stanford-ner/english.all.3class.distsim.crf.ser.gz
cp -f stanford-ner-2016-10-31/classifiers/english.all.3class.distsim.prop stanford-ner/english.all.3class.distsim.prop
cp -f stanford-ner-2016-10-31/classifiers/english.all.3class.distsim.prop stanford-ner/english.all.3class.distsim.prop

mkdir -p stanford-postagger
cp -f stanford-postagger-2016-10-31/stanford-postagger.jar stanford-postagger/stanford-postagger.jar
cp -f stanford-postagger-2016-10-31/stanford-postagger-3.7.0.jar stanford-postagger/stanford-postagger-3.7.0.jar
cp -f stanford-postagger-2016-10-31/models/*.tagger* stanford-postagger/

echo " . . . Clearing all"

if [[ -f "test_sner.py" ]]; then
	echo " . . . Downloading file stanford-poostagger-2016-10-31.zip"
	exit
fi

echo " . . . Preparing Python test file test_sner.py"
touch test_sner.py

# import Stanford NER for NLTK (avaaible from 2.0 ver)
echo "from nltk.tag.stanford import StanfordNERTagger as NERTagger" >> test_sner.py

echo "from nltk.tag import StanfordPOSTagger">>test_sner.py
echo "from nltk import word_tokenize">>test_sner.py

# initialize SNER using copied files
echo "st = NERTagger('stanford-ner/english.all.3class.distsim.crf.ser.gz', 'stanford-ner/stanford-ner.jar')">> test_sner.py

# add test to see weather it works
echo "print st.tag('You can call me Billiy Bubu and I live in Amsterdam.'.split())">> test_sner.py

echo "print st.tag('France is lovely city.'.split())">> test_sner.py

echo "print st.tag('Turn off the kitchen light.'.split())">> test_sner.py

echo " ">> test_sner.py


echo "from nltk.tag import StanfordPOSTagger" >> test_sner.py

echo "st = StanfordPOSTagger('stanford-postagger/english-left3words-distsim.tagger', 'stanford-postagger/stanford-postagger.jar', encoding='utf8')" >> test_sner.py
echo "print st.tag(word_tokenize('What is the airspeed of an unladen swallow ?'))">> test_sner.py


chmod +x test_sner.py

echo " . . . Executing Python test file test_sner.py"
python test_sner.py

echo " . . . Isn't it cool? :)"
