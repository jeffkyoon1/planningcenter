require 'tk'
require 'csv'
require './chase_activity'

filename = Tk::getOpenFile
activities = []

CSV.foreach(filename, :headers => true) do |row|
  date = row['Posting Date']
  payer = row['Description'].upcase.delete_prefix("QUICKPAY WITH ZELLE PAYMENT FROM ").split(" ")[0..-2].join(" ")
  amount = row['Amount']

  record = ChaseActivity.new(date, payer, amount)
  activities << record
end

puts activities

File.new("C:/Users/home/Documents/Onnuri/chase_activity.csv", "w+")
File.open("C:/Users/home/Documents/Onnuri/chase_activity.csv", "w+") do |f|
  f.puts(activities)
end
