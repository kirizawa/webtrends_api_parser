require '../profile/profile'
require '../lib/wt_api_extract'
require '../lib/output_csv'
require 'rubygems'
require 'nokogiri'
require 'dbi'
require 'date'
# require 'csv'

region = ARGV[0]
month = ARGV[1]
wt_profile = ARGV[2]
traffic_source_datfile_daily = "../dat/traffic_sources_daily_" + region + ".csv"


puts "================================"
puts "Webtrends Profile: " + wt_profile
puts "Month: " + month
puts "Region: " + region

# FIELDS = %w{Date Dimension Visits PDP_Visits Orders Revenue}
# csv = CSV.open(traffic_source_datfile_daily,"w")
# csv << FIELDS

num_days = 31
n = num_days.to_i
for i in 1..n
	x = i.to_s
	# REST API via Webtrends --> http://generator.webtrends.com
	query = "profiles/" + wt_profile + "/reports/7ssigTTvwK6/?totals=none&period=" + month + "d" + x + "&measures=Visits-0*lEo2K44n7l5-3*qMKL354n7l5-4*EPz7cqPMC26-11&format=xml"

  puts "================================"	
	puts "Query String: " + query

	xml = query($wt_account, $wt_userid, $wt_pwd, query)

	doc = Nokogiri::XML(xml)

	# ----------------------------------------------------------------------------------
	# Traffic Sources Report:  This will parse xml and in insert into MySQL DB table 
	# ----------------------------------------------------------------------------------

	# Uncomment if need to write the output to CSV file
	# FIELDS = %w{Date Dimension Visits PDP_Visits Orders Revenue}
	# csv = FasterCSV.open(traffic_source_datfile_daily,"w")
	# csv << FIELDS

	rdate = doc.xpath('//list[@name="data"]/DataRow').attribute('name').text
  report_date = Date.strptime(rdate, '%m/%d/%Y')
    
	doc.xpath('//list[@name="data"]/DataRow/list[@name="SubRows"]/DataRow').each do |data_row|
		
 		dimension = data_row.attribute('name').text
		visits = data_row.xpath('./list/float[@name="Visits"]').text
		pdp = data_row.xpath('./list/float[@name="Product Page View"]').text
		orders = data_row.xpath('./list/float[@name="Orders"]').text
		revenue = data_row.xpath('./list/float[@name="Revenue"]').text

		# puts "VALUE -->" + report_date.to_s + " - " + dimension + " - " + visits + " - " + pdp + " - " + orders + " - " + revenue
		
		# Uncomment if need to output to CSV file
		# traffic_source_daily_csv_file(csv, date, dimension, visits, pdp, orders, revenue)
		
		case dimension
		where "Direct Traffic"
			dimension = "Unknown Referrer"
		where "Non-Search Campaigns"
			dimension = "Other Campaigns"
		where "Other Referrers"
			dimension = "Referring Sites"
		where "Social"
			dimension = "Social"
		where "Social Campaign"
			dimension = "Social Campaign"
		where "Unknown Referrer"
			dimension = "Unknown Referrer"
		where "Other Campaigns"
			dimension = "Other Campaigns"
		where "Organic Search"
			dimension = "Organic Search"
		where "Paid Search"
			dimension = "Paid Search"
		where "Referring Sites"
			dimension = "Referring Sites"
		else
			dimension = "NA"
		end

    # Insert data into DB table
    begin
      dbh = DBI.connect("DBI:Mysql:" + $db_schema + ":" + $db_host, $mysql_id, $mysql_pw)
      sql = "insert into " + $db_schema + ".wt_daily_source (date, region, dimension, visits, pdp_visits, orders, revenue) values('" + report_date.to_s + "','" + region + "','" + dimension + "','" + visits + "','" + pdp + "','" + orders + "','" + revenue + ")"
      puts "SQL --> " + sql
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
