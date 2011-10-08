require '../profile/profile'
require '../lib//wt_api_extract'
require '../lib//output_csv'
require '../lib/days_in_month'
require 'nokogiri'
require 'csv'

region = ARGV[0]
month = ARGV[1]
wt_profile = ARGV[2]
daily_datfile = "../dat/daily_sem_engine_traffic_" + region + ".csv"
num_days = days_in_month(month)

puts "========================================="
puts "Webtrends Profile: " + wt_profile
puts "Month: " + month
puts "Number of Days to Process: " + num_days.to_s
puts "Data File (Output): " + daily_datfile
puts "========================================="

FIELDS = %w{Date SearchEngine Visits}
csv = CSV.open(daily_datfile,"w")
csv << FIELDS

case region
when "nl"
  filter = "Netherlands"
  search_engine = "Google Netherlands"
when "us"
  filter = "Google"
  search_engine = "Google"
when "ca"
  filter = "Canada"
  search_engine = "Google Canada"
when "amr"
  filter = "Google"
  search_engine = "Google"
else
  filter = "Google"
  search_engine = "Google"
end

for i in 1..num_days
	x = i.to_s
	
	wt_query = "profiles/" + wt_profile + "/reports/rCcFTt1DNj5/?totals=all&period=" + month + "d" + x + "&search=" + filter + "&measures=Visits-0&format=xml"

	puts "Query String: " + wt_query

	xml = query($wt_account, $wt_userid, $wt_pwd, wt_query)

	doc = Nokogiri::XML(xml)

	# -------------------------------------------------------------------------
	# Search Engine (paid):  This will parse xml and create csv file
	# -------------------------------------------------------------------------

	date = doc.xpath('//list[@name="data"]/DataRow').attribute('name').text

	doc.xpath('//list[@name="data"]/DataRow/list[@name="SubRows"]/DataRow[@name="' + search_engine + '"]').each do |data_row|
  
 		search_engine = data_row.attribute('name')
		visits = data_row.xpath('./list/float[@name="Visits"]').text

		puts date + " - " + search_engine + " - " + visits 

		paid_search_engine_daily_traffic(csv, date, search_engine, visits)

	end


end

puts "========================================="
