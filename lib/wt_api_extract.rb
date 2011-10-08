require 'net/http'
require 'net/https'

def query(account, username, password, query)
     
     # puts account
     # puts username
     # puts password
     # puts query

     hostname = "ws.webtrends.com"
    
     https =  Net::HTTP.new(hostname, Net::HTTP.https_default_port)
     https.use_ssl = true
     https.ca_file = "/usr/share/curl/curl-ca-bundle.crt"

     resp = https.start { |http|
      
       request = Net::HTTP::Get.new("/v2/ReportService/" + query)
     
       request.basic_auth account + '\\' + username, password
           
        res = http.request(request)
 
        case res
 
        when Net::HTTPSuccess, Net::HTTPRedirection
         
          return  res.body
       
        else
       
          res.error!
       
        end
       
      }
     
  end
