# Random scripts to parse out N-grams from the King James Version Bible
# http://www.sitepoint.com/natural-language-processing-ruby-n-grams/ was a great starting point

require('csv')

require_relative('ngram')
require_relative('corpus')
require_relative('bibleCorpusFile')

def analyze_book(n)
  corpus = Corpus.new("./corpus/books/#{n}.csv", BibleCorpusFile)

  unigrams = Hash.new(0);
  bigrams = Hash.new(0);
  trigrams = Hash.new(0);
  puts "Parsing unigrams"
  corpus.unigrams.each do |result|
    unigrams[result.join(' ')] += 1
  end
  CSV.open("./results/unigram/#{n}.csv", "w") do |csv|
    unigrams.keep_if{|k, v| v > 5}.sort_by{|k, v| [-v, k]}.each do |row|
      csv << row
    end
  end
  puts "Parsing bigrams"
  corpus.bigrams.each do |result|
    bigrams[result.join(' ')] += 1
  end
  CSV.open("./results/bigram/#{n}.csv", "w") do |csv|
    bigrams.keep_if{|k, v| v > 5}.sort_by{|k, v| [-v, k]}.each do |row|
      csv << row
    end
  end
  puts "Parsing trigrams"
  corpus.trigrams.each do |result|
    trigrams[result.join(' ')] += 1
  end
  CSV.open("./results/trigram/#{n}.csv", "w") do |csv|
    trigrams.keep_if{|k, v| v > 5}.sort_by{|k, v| [-v, k]}.each do |row|
      csv << row
    end
  end
end

(1..66).each do |n|
  puts "Analyzing book #{n}"
  analyze_book(n)
end
#puts results.keep_if{|k, v| v > 0}.sort_by{|k, v| v}.inspect
#puts results.keep_if{|k, v| k.include?("Amen")}.sort_by{|k, v| v}.inspect
