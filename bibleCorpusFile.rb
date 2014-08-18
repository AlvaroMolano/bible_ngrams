class BibleCorpusFile

  def initialize(path)
    @path = path
  end

  def verses
    puts "Opening #{@path} for reading"
    @verses = []
    CSV.foreach(@path) do |col|
      @verses << col[4].split(/[.!?]\s*/).each{|a| a.gsub!(/[[:punct:]]/,"")}
    end
    return @verses
  end

end
