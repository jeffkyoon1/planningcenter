require 'tk'
require 'pdf-reader'
require './chase_activity'

pdfname = Tk::getOpenFile

quickpay_activities = []
PDF::Reader.open(pdfname) do |reader|
  reader.pages.each do |page|
    desc_line = false
    page.text.each_line do |line|
      line = line.gsub("Completed", "")
      line = line.gsub("Delivered", "")
      line = line.gsub("Real-time", "")
      if line.strip != "" && !(line.include?("chase.com") || line.include?("Date received") || line.include?("JPMorgan") || line.include?("Chase for Business"))
        if line.include?('"') || desc_line
          if quickpay_activities.any?
            if line.count('"') == 1
              desc_line = !desc_line
            end
            quickpay = quickpay_activities.pop()
            quickpay.description += line.strip.gsub('"', "")
            quickpay_activities << quickpay
          end
        else
          rec = line.strip.gsub(/  /, '|').split("|").reject { |c| c.empty? }.map { |s| s.strip }
          rec_date = rec[0]
          rec_name = rec[1]
          rec_desc = ""
          rec_amt = rec[2]
          quickpay = QuickpayActivity.new(rec_date, rec_name, rec_desc, rec_amt)
          quickpay_activities << quickpay
        end
      end
    end
  end
end

puts quickpay_activities

File.new("C:/Users/home/Documents/Onnuri/quickpay.csv", "w+")
File.open("C:/Users/home/Documents/Onnuri/quickpay.csv", "w+") do |f|
  f.puts(quickpay_activities)
end
