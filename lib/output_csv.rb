require 'csv'


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

def traffic_daily_csv_file(csv, date, country, visits, orders, revenue)

  wt_data = []
  wt_data << date
  wt_data << country
  wt_data << visits
  wt_data << orders
  wt_data << revenue

  csv << CSV::Row.new(FIELDS, wt_data)

end

def seo_phrase_daily_csv_file(csv, date, phrase, visits)

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

def sem_engine_daily_traffic(csv, date, search_engine, visits)

  wt_data = []
  wt_data << date
  wt_data << search_engine
  wt_data << visits

  csv << CSV::Row.new(FIELDS, wt_data)

end

