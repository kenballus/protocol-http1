# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2022, by Samuel Williams.

$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)

require 'async'
require 'async/io/stream'
require 'async/http/endpoint'
require 'protocol/http1/connection'
require 'pry'

Async do
	endpoint = Async::HTTP::Endpoint.parse("https://www.google.com/search?q=kittens", alpn_protocols: ["http/1.1"])
	
	peer = endpoint.connect
	
	puts "Connected to #{peer} #{peer.remote_address.inspect}"
	
	# IO Buffering...
	stream = Async::IO::Stream.new(peer)
	client = Protocol::HTTP1::Connection.new(stream)
	
	puts "Writing request..."
	client.write_request("www.google.com", "GET", "/search?q=kittens", "HTTP/1.1", [["Accept", "*/*"]])
	client.write_body("HTTP/1.1", nil)
	
	puts "Reading response..."
	response = client.read_response("GET")
	
	puts "Got response: #{response.inspect}"
	
	puts "Closing client..."
	client.close
end

puts "Exiting."
