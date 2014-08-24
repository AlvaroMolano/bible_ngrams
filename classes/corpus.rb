# http://www.sitepoint.com/natural-language-processing-ruby-n-grams/ was a great starting point
class Corpus
  def initialize(glob, klass)
    @glob = glob
    @klass = klass
  end
  
  #Creates an array of the appropriate class (in this case BibleCorpusFile)
  def files
    @files ||= Dir[@glob].map do |file|
      @klass.new(file)
    end
  end

  #Grabs all verses out of all files in this array
  def verses
    files.map do |file|
      file.verses
    end.flatten
  end

  #Creates an array of Ngram objects of size n across whole corpus
  def ngrams(n)
    verses.map do |verse|
      Ngram.new(verse).ngrams(n)
    end.flatten(1)
  end

  def unigrams
    ngrams(1)
  end

  def bigrams
    ngrams(2)
  end

  def trigrams
    ngrams(3)
  end

end
