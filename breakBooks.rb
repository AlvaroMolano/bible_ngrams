require 'csv'

prev_book = 0
curr_out = nil

CSV.foreach('./corpus/t_kjv.csv') do |row|
  book = row[1].to_i
  if book > prev_book
    unless curr_out.nil?
      puts "Closing book #{prev_book}"
      curr_out.close
    end
    puts "Opening book #{book}"
    curr_out = CSV.open("./corpus/books/#{book}.csv", "w") or die "Fail!"
    prev_book = book
  end
  curr_out << row
end
