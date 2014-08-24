# Simple script to automate stripping down the full bibles in the bible_database repository into separate books and version folders

require 'csv'

def rip_version(version_name)
  # Reset counters
  prev_book = 0
  curr_out = nil

  #Open that particular version and rip it
  CSV.foreach("./corpus/t_#{version_name}.csv") do |row|
    book = row[1].to_i
    if book > prev_book
      unless curr_out.nil?
        puts "Closing book #{prev_book}"
        curr_out.close
      end
      puts "Opening book #{book}"
      curr_out = CSV.open("./corpus/#{version_name}/#{version_name}_#{book}.csv", "w") or die "Fail!"
      prev_book = book
    end
    curr_out << row
  end
end

def rip_all
  Dir.glob('./corpus/*.csv') do |version|
    version_name = /t_(\w+).csv/.match(version)[1]
    puts "Working on #{version_name}"
    rip_version(version_name)
  end
end

rip_version("ylt")
