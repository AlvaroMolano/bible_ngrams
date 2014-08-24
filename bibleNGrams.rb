# Random scripts to parse out N-grams from the King James Version Bible
# http://www.sitepoint.com/natural-language-processing-ruby-n-grams/ was a great starting point

require('csv')

require_relative('classes/ngram')
require_relative('classes/corpus')
require_relative('classes/bibleCorpusFile')

def analyze_all_books(n, minimum)
  ngrams = Hash.new(0)
  (1..2).each do |book|
    analyze_book(n, book, ngrams)
  end
end

def analyze_book(n, book, results)
  corpus = Corpus.new("./corpus/books/#{n}.csv", BibleCorpusFile)

  # Write out book-specific results
  corpus.ngrams(n).each do |result|
    results[book][result.join(' ')] += 1
  end
end

def write_result(results, minimum=1)
  CSV.open("./results/unigram/#{n}.csv", "w") do |csv|
    results[:all].keep_if{|k, v| v >= minimum}.sort_by{|k, v| [-v, k]}.each do |row|
      gram = row[0]
      count = row[1]
      csv << [gram, count, n]
    end
  end
end

(1..66).each do |n|
  puts "Analyzing book #{n}"
  analyze_book(n, 0)
end

puts "Writing out aggregate results"
CSV.open("./results/unigram/aggregate.csv", "w") do |csv|
  @all_unigrams.keep_if{|k, v| v > 0}.sort_by{|k, v| [-v, k]}.each do |row|
    gram = row[0]
    count = row[1]
    csv << [gram, count]
  end
end
CSV.open("./results/bigram/aggregate.csv", "w") do |csv|
  @all_bigrams.keep_if{|k, v| v > 0}.sort_by{|k, v| [-v, k]}.each do |row|
    gram = row[0]
    count = row[1]
    csv << [gram, count]
  end
end
CSV.open("./results/trigram/aggregate.csv", "w") do |csv|
  @all_trigrams.keep_if{|k, v| v > 0}.sort_by{|k, v| [-v, k]}.each do |row|
    gram = row[0]
    count = row[1]
    csv << [gram, count]
  end
end

#puts results.keep_if{|k, v| v > 0}.sort_by{|k, v| v}.inspect
#puts results.keep_if{|k, v| k.include?("Amen")}.sort_by{|k, v| v}.inspect
