class Corpus
  def initialize(glob, klass)
    @glob = glob
    @klass = klass
  end

  def files
    @files ||= Dir[@glob].map do |file|
      @klass.new(file)
    end
  end

  def verses
    files.map do |file|
      file.verses
    end.flatten
  end

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
