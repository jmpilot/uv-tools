class RandomTicketController < ApplicationController
	def rnd_tix				
	#Client SDK information
		@SUBDOMAIN_NAME = 'uservoice'
		@API_KEY = 'ZFOd1llaYouus2Balhg'
		@API_SECRET = 'H32InQ3Ra9P7MXIZmBBH6PaVOoOIkyCFsAgRmCr7aHM'
		@URL = 'http://localhost:4567/'

	#Initialize client
		client = UserVoice::Client.new(@SUBDOMAIN_NAME, @API_KEY, @API_SECRET, :callback => @URL)

	#Nuts and bolts of searching with date range
		today = Time.now.strftime("%Y-%m-%d")
		search_query = 'assignee:"joey.pilot@uservoice.com","claire@uservoice.com","john.rix@uservoice.com" /
		"created_start":"2017-1-01" "created_end":"#{today}"'

	#print 'when to start (yyyy-mm-dd) dont get crazy: '
	#start_date = gets.chomp

		response = client.get("/api/v1/tickets/search.json?query=#{CGI::escape(search_query)}&per_page=100")

		#create an empty array for their URLs, loop through and add them
		ticket_urls = []
		response['tickets'].each do |url|
			ticket_urls.push(url['url'])
		end

		@random_ticket_url = ticket_urls.sample(10)
	end
end
