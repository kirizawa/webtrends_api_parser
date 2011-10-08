require 'date'

def days_in_month(proc_month)
  rpt_month = proc_month.split("m")
  year = rpt_month[0].to_i
  month = rpt_month[1].to_i
  (Date.new(year, 12, 31) << (12-month)).day
end

