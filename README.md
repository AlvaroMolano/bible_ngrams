# About
This project aims to provide documentation of the basic n-grams that make up public domain translations of the Bible. 

# Inspiration
This project is partly inspired by [Chris Harrison's Bible Visualizations](http://www.chrisharrison.net/index.php/Visualizations/BibleViz) and partly by the [Bible Viz project](http://bibviz.com/). 

# Components

## Translations
This project is currently using the following public domain translations obtained via the bible_databases project from [scrollmapper](https://github.com/scrollmapper/bible_databases):
- American Standard Version (ASV)
- Bible in Basic English (BBE)
- Darby English Bible (DARBY)
- King James Version (KJV)
- Webster's Bible (WBT)
- World English Bible (WEB)
- Young's Literal Translation (YLT)

## Parsers
The initial splitting of the translations into each specific book is done with *breakBooks.rb*.

The output of *breakBooks.rb* is worked on by *bibleNGrams.rb* which does the work to actually extract the n-grams. This can be used to work across all translations at one time, or changed for a one-time run to just redo a particular translation, or book.
