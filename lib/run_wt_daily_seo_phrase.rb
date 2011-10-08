require '../profile/profile'
require '../lib/wt_api_extract'
require '../lib/output_csv'
require '../lib/days_in_month'
require 'rubygems'
require 'nokogiri'
require 'csv'

region = ARGV[0]
month = ARGV[1]
wt_profile = ARGV[2]
search_term = ARGV[3]
daily_datfile = "../dat/daily_seo_phrase_" + month + "_" + region + ".csv"
num_days = days_in_month(month)

puts "================================"
puts "Webtrends Profile: " + wt_profile
puts "Data Year and Month: " + month 
puts "Number of Days to Process: " + num_days.to_s
puts "Search Term: " + search_term
puts "Data File (Output): " + daily_datfile

FIELDS = %w{Date Phrase Visits}
csv = CSV.open(daily_datfile,"w")
csv << FIELDS

for i in 1..num_days
	x = i.to_s
	wt_query = "profiles/" + wt_profile + "/reports/sNlAnkJRYk5/?totals=all&period=" + month + "d" + x + "&search=" + search_term + "&measures=Visits-0&format=xml"

	puts "Query String: " + wt_query

	xml = query($wt_account, $wt_userid, $wt_pwd, wt_query)

	doc = Nokogiri::XML(xml)

	# -------------------------------------------------------------------------
	# Search Phrase Organic:  This will parse xml and create csv file
	# -------------------------------------------------------------------------

	date = doc.xpath('//list[@name="data"]/DataRow').attribute('name').text

	doc.xpath('//list[@name="data"]/DataRow/list[@name="SubRows"]/DataRow[@name="' + search_term + '"]').each do |data_row|
  
 		phrase = data_row.attribute('name')
		visits = data_row.xpath('./list/float[@name="Visits"]').text

		puts date + " - " + phrase + " - " + visits 

		seo_traffic_daily_csv_file(csv, date, phrase, visits)

	end

end

puts "================================"
