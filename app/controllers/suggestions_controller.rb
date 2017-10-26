class SuggestionsController < ApplicationController
	skip_before_action :verify_authenticity_token
	def post
		@title=params[:title]
		@body=params[:body]

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

		def post_suggestion(title,body,forum_id)
			api("#{@SUGGESTIONS_ENDPOINT}&title=#{title}&body=#{body}&links.forum=#{forum_id}","suggestions","POST")
		end

		post_suggestion(@title,@body,599035)
			end
end