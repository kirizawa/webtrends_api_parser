require '../profile/profile'
require '../lib/wt_api_extract'
require '../lib/output_csv'
require 'nokogiri'
require 'dbi'
require 'date'
#require 'csv'

region = ARGV[0]
month = ARGV[1]
wt_profile = ARGV[2]
# traffic_daily_datfile = "../dat/daily_traffic_" + region + ".csv"


puts "================================"
puts "WT Profile: " + wt_profile
puts "Month: " + month
puts "Region: " + region

# puts "Data File (Output): " + traffic_daily_datfile
# use this if needed to convert to csv out instead of DB insert
# FIELDS = %w{Date Country Visits Orders Revenue}
# csv = CSV.open(traffic_daily_datfile,"w")
# csv << FIELDS

num_days = 31
n = num_days.to_i
for i in 1..n
	x = i.to_s

  # REST api generated from Webtrends generator --> http://generator.webtrends.com
  wt_query = "profiles/" + wt_profile + "/reports/13yZ9fCCiJ6/?totals=all&period=" + month + "d" + x + "&measures=Visits-0*CAoNYspmFb5-1*vo44854n7l5-3*qMKL354n7l5-6*lEo2K44n7l5-9*EPz7cqPMC26-15*FPz7cqPMC26-16*JP3fwtZ7DM6-20*RDqgRX18DM6-21&format=xml"

	puts "Query String: " + wt_query

	xml = query($wt_account, $wt_userid, $wt_pwd, wt_query)

	doc = Nokogiri::XML(xml)

	if region == "us"
	  expath_region = "US"
	elsif region == "nl"
	  expath_region = "NL"
	elsif region == "apj"
	  expath_region = "APJ"
  elsif region == "amr"
    expath_region = "AMR"
  elsif region == "emea"
    expath_region = "EMEA"
	else
	  expath_region = "Unknown"
	end

  # puts "Region ==> " + expath_region

	# -------------------------------------------------------------------------
	# New and Return visitors report:  This will parse xml and insert into DB
	# -------------------------------------------------------------------------

	date = doc.xpath('//list[@name="data"]/DataRow').attribute('name').text
	rdate = Date.strptime(date, '%m/%d/%Y')

	doc.xpath('//list[@name="data"]/DataRow/list[@name="SubRows"]/DataRow').each do |data_row|
  
 		traffic_type = data_row.attribute('name').text
 		daily_visitors = data_row.xpath('./list/float[@name="Daily Visitors"]').text
		visits = data_row.xpath('./list/float[@name="Visits"]').text
		pageviews = data_row.xpath('./list/float[@name="Page Views"]').text
		pdp_visits = data_row.xpath('./list/float[@name="Product Page View"]').text
		cart_visits = data_row.xpath('./list/float[@name="Shopping Cart"]').text
		single_visits = data_row.xpath('./list/float[@name="Single Page View Visits"]').text
		entry_visits = data_row.xpath('./list/float[@name="Entry Page Visits"]').text
		orders = data_row.xpath('./list/float[@name="Orders"]').text
		revenue = data_row.xpath('./list/float[@name="Revenue"]').text
    
    # Uncomment if need to output to CSV
		# traffic_daily_csv_file(csv, date, country, visits, orders, revenue)

    # Insert data into DB table
    begin
      dbh = DBI.connect("DBI:Mysql:" + $db_schema + ":" + $db_host, $mysql_id, $mysql_pw)
      sql = "
      insert into " + $db_schema + ".wt_daily_traffic (date, region, traffic_type, daily_visitors, visits, page_views, pdp_visits, cart_visits, single_visits, entry_visits, orders, revenue) 
      values('" + rdate.to_s + "','" + expath_region + "','" + traffic_type + "','" + daily_visitors + "','" + visits + "','" + pageviews + "','" + pdp_visits + "','" + cart_visits + "','" + single_visits + "','" + entry_visits + "','" + orders + "','" + revenue + ")
      "
      puts "=== SQL: Inserting... ===" + sql
      sth = dbh.execute(sql)
      sth.finish
    rescue DBI::DatabaseError => e
      puts "An error occured"
      puts "Error code: #{e.err}"
      puts "Error message: #{e.errstr}"
    ensure 
      # disconnect from server
      dbh.disconnect if dbh      
    end
    
	end

end

puts "================================"
