require 'uservoice-ruby'
require 'json'
require 'date'
require 'open-uri'

#Client SDK information
SUBDOMAIN_NAME = 'uservoice'
API_KEY = 'ZFOd1llaYouus2Balhg'
API_SECRET = 'H32InQ3Ra9P7MXIZmBBH6PaVOoOIkyCFsAgRmCr7aHM'
URL = 'http://localhost:4567/'

#Initialize client
client = UserVoice::Client.new(SUBDOMAIN_NAME, API_KEY, API_SECRET, :callback => URL)

#Nuts and bolts of searching with date range
today = Time.now.strftime("%Y-%m-%d")
##search_query = '-assignee:"Product Feedback","Leads","Rescue","A/R" /
#{#}"created_start":"2016-11-01" "created_end":"#{today}" status:closed'

search_query = 'assignee:john.rix@uservoice.com,joey.pilot@uservoice.com,claire@uservoice.com /
"created_start":"2017-02-28" "created_end":"#{today}" status:closed'

#print 'when to start (yyyy-mm-dd) dont get crazy: '
#start_date = gets.chomp

response = client.get("/api/v1/tickets/search.json?query=#{CGI::escape(search_query)}&per_page=100")

#Get the total  number of tickets retrieved
record_total =  response['response_data']['total_records']

#create an empty array for their URLs, loop through and add them
ticket_urls = []
response['tickets'].each do |url|
	ticket_urls.push(url['url'])
end

random_ticket = ticket_urls.sample
puts "heres a random one #{random_ticket}\n\n"
system("open","#{random_ticket}")





