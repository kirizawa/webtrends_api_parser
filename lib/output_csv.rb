require 'csv'


def new_return_csv_file(csv, month, dimension, visits, pdp, orders, units, revenue)

  wt_data = []
  wt_data << month
  wt_data << dimension
  wt_data << visits
  wt_data << pdp
  wt_data << orders
  wt_data << units
  wt_data << revenue
 
  csv << CSV::Row.new(FIELDS, wt_data)
end  


def traffic_source_csv_file(csv, date, source, visits, pdp, orders, units, revenue)

  wt_data = []
  wt_data << date
  wt_data << source
  wt_data << visits
  wt_data << pdp
  wt_data << orders
  wt_data << units
  wt_data << revenue
 
  csv << CSV::Row.new(FIELDS, wt_data)

end


def traffic_source_daily_csv_file(csv, date, source, visits, pdp, orders, revenue)

  wt_data = []
  wt_data << date
  wt_data << source
  wt_data << visits
  wt_data << pdp
  wt_data << orders 
  wt_data << revenue 

  csv << CSV::Row.new(FIELDS, wt_data)

end

def us_traffic_daily_csv_file(csv, date, country, visits, orders, revenue)

  wt_data = []
  wt_data << date
  wt_data << country
  wt_data << visits
  wt_data << orders
  wt_data << revenue

  csv << CSV::Row.new(FIELDS, wt_data)

end

def campaignid_traffic_daily_csv_file(csv, date, campaignid, visits)

  wt_data = []
  wt_data << date
  wt_data << campaignid
  wt_data << visits

  csv << CSV::Row.new(FIELDS, wt_data)

end

def seo_traffic_daily_csv_file(csv, date, phrase, visits)

  wt_data = []
  wt_data << date
  wt_data << phrase
  wt_data << visits

  csv << CSV::Row.new(FIELDS, wt_data)

end

def seo_engine_daily_traffic(csv, date, search_engine, visits)

  wt_data = []
  wt_data << date
  wt_data << search_engine
  wt_data << visits

  csv << CSV::Row.new(FIELDS, wt_data)

end

def paid_search_engine_daily_traffic(csv, date, search_engine, visits)

  wt_data = []
  wt_data << date
  wt_data << search_engine
  wt_data << visits

  csv << CSV::Row.new(FIELDS, wt_data)

end

