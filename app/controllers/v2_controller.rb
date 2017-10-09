class V2Controller < ApplicationController
	def suggestions
		require 'net/https'
		require 'uri'
		require 'json'
		require 'mime/types'
		require 'open-uri'
		require 'pp'

		@SUBDOMAIN_NAME = 'jmp'
		@API_KEY = '2Uwls5q3JBhxO5BXOuAnTQ'
		@API_SECRET = '9KFFzFwrPW8HAhI5DfIRueyaYRo5oL51s13YIVnMeA'
		@API_URL = "https://jmp.uservoice.com/api/v2"

		def parse_json(response_body,attribute=nil)
			obj = JSON.parse(response_body)
			attribute == nil ? (@out = obj) : (@out = obj["#{attribute}"])
			return @out
		end

		#give it an endpoint, an optional attribute (to drill down into response, and the appropriate http verb)
		def api(endpoint,attribute = nil,verb = nil)
			uri = URI.parse("#{@API_URL}#{endpoint}")
			header = {'Content-Type': 'text/json'}
			if verb == "POST"
				http = Net::HTTP.new(uri.host, uri.port)
				request = Net::HTTP::Post.new(uri.request_uri, header)
				http.use_ssl = true
				http.ssl_version = :TLSv1
				http.verify_mode = OpenSSL::SSL::VERIFY_PEER
				response = http.request(request)
				parse_json(response.body,attribute)
			else
				return parse_json(uri.read,attribute)
			end
		end

		@TOKEN_ENDPOINT = "/oauth/token?client_id=#{@API_KEY}&client_secret=#{@API_SECRET}&grant_type=client_credentials"
		@ACCESS_TOKEN = api("#{@TOKEN_ENDPOINT}","access_token","POST")
		@SUGGESTIONS_ENDPOINT = "/admin/suggestions?client_id=#{@API_KEY}&client_secret=#{@API_SECRET}&grant_type=client_credentials&oauth_token=#{@ACCESS_TOKEN}"

		def get_paginated_urls(endpoint)
			@objects = api("#{@SUGGESTIONS_ENDPOINT}","pagination")
			@total_pages = @objects["total_pages"]
			@paginated_urls = []
			(1..@total_pages).each {|i| @paginated_urls.push("#{@SUGGESTIONS_ENDPOINT}&page=#{i}")}
			return @paginated_urls
		end

		# def paged_api(paged_query_url)
		# 	response = api("#{paged_query_url}")
		# 	response["suggestions"].each {|i| puts "#{i["title"]}:#{i["portal_url"]}"}
		# end

		def paged_api(paged_query_url)
			response = api("#{paged_query_url}")
			response["suggestions"].each {|i| @suggs[i["title"]] = "#{i["portal_url"]}"}
		end

		paginated_urls = get_paginated_urls("#{@SUGGESTIONS_ENDPOINT}")
		@suggs = {}
		paginated_urls.each {|i| paged_api(i)}
	end
end