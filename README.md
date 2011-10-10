# **Web Traffic Dashboard**

Sample programs to process Webtrends data into MySyQL database, and some codes output into CSV file instead.

# **Requirements**

You'll need access to Webtrends Generator.  http://generator.webtrends.com

MySQL tables containing columns pertaining to web metrics.  
**wt_daily_source** for traffic data by regional value by dimensions (i.e. Organic Search, Paid Search,e tc.)  
**wt_daily_traffic** for traffic data by regional value by day.  

I've defined the MySQL DB schema, user id, and password in profile.rb in profile, but you could change that accordingly.  Those values are obviously used to make connections to MySQL database.

Here are the list of variables that are needed to run the program.  
$wt_account = Webtrends Account ID  
$wt_userid = Webtrends User ID  
$wt_pwd = Webtrends USer Password  
$mysql_id = MySQL User ID  
$mysql_pw = MySQL Password  
$db_schema = MySQL DB Schema where the tables are
$db_host = MySQL Hostname.  Localhost is used if ran locally  

# **How to use it?**

I've written some shell scripts to run the ruby, but you can also pass the parameters directly to the ruby program as well.  

You can pass "-h" to look at what parameters are needed to run the program.  
The month format is represented by Webtrends Year & Month format which looks like 2011m07.  And for full day format would look like 2011m07d01.

> sh run_daily_traffic.sh -h  
> Usage: run_daily_traffic.sh -r [amr/emea/apj] -m [YYYYmMM]

My regional values are mapped to actual Webtrends profile id, so switch the regional parameter to reflect different regional data output.  
Program should be adjusted according to your Webtrends profile id.

 
