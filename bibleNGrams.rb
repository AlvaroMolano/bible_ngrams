# Random scripts to parse out N-grams from the King James Version Bible
# http://www.sitepoint.com/natural-language-processing-ruby-n-grams/ was a great starting point

require('csv')

require_relative('classes/ngram')
require_relative('classes/corpus')
require_relative('classes/bibleCorpusFile')

# Read in stop words
@stop_words = []
File.foreach('./stopwords.txt') {|x| @stop_words << x.chomp}

# This will kick off a massive run checking all n-grams
# from 1-10 across all versions. It will be slow.
def analyze_all_versions
  Dir.glob('./corpus/*/') do |version|
    version_name = /corpus\/(.+)\//.match(version)[1]
    (1..10).each do |x|
      write_result(analyze_version(version_name, x), 5)
    end
  end
end

# Generate base ngram statistics for a particular version 
# (stored in ./corpus/#{version}/)
# for example: analyze_version('kjv', 1)
def analyze_version(version, n)
  ngrams = Hash.new(0)
  ngrams[:all] = Hash.new(0)
  ngrams[:n] = n
  ngrams[:version] = version
  (1..66).each do |book|
    ngrams[book] = analyze_book(version, book, n)
    ngrams[:all].merge!(ngrams[book]){|key, oldVal, newVal| oldVal + newVal}
  end
  return ngrams
end

# Does the work to analyze a particular book in a particular version 
# and provide the statistics as a hash we can add to later
def analyze_book(version, book, n)
  corpus = Corpus.new("./corpus/#{version}/#{version}_#{book}.csv", BibleCorpusFile)
  results = Hash.new(0)
  # Keep book-specific results
  corpus.ngrams(n).each do |result|
    phrase = result.join(' ')
    if !all_stop_words(phrase)
      results[phrase] += 1
    end
  end
  return results
end

def write_result(results, minimum=1)
  n = results[:n]
  version = results[:version]

  base_dir = "./results/#{n}-gram/#{version}/"
  results.keys.each do |key|
    # Each of these are individual books
    if key.is_a? Integer

      # Check to see if we're saving this somewhere that exists
      if !Dir.exists?("#{base_dir}")
        Dir.mkdir("#{base_dir}")
      end

      # Open the CSV object to write out this individual book
      CSV.open("#{base_dir}/#{version}_#{key}.csv", "w") do |csv|
        csv << ["N-gram", "Count", "Book"] # Header
        results[key].keep_if{|k, v| v >= minimum}.sort_by{|k, v| [-v, k]}.each do |row|
          gram = row[0]
          count = row[1]
          csv << [gram, count, key]
        end
      end
    # Write out the aggregate stats
    elsif key == :all

      # Aggregate stats will live in the root directory for that n-gram folder
      CSV.open("./results/#{n}-gram/#{version}.csv", "w") do |csv|
        csv << ["N-gram", "Count", "Version"] # Header
        results[:all].keep_if{|k, v| v >= minimum}.sort_by{|k, v| [-v, k]}.each do |row|
          gram = row[0]
          count = row[1]
          csv << [gram, count, version]
        end
      end
    end
  end
end

def all_stop_words(phrase)
  acc = true
  phrase.downcase.split(' ').each do |word|
    acc = acc && @stop_words.include?(word)
  end
  return acc
end

analyze_all_versions
