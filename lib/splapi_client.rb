require 'net/http'
require 'uri'
require 'json'

class SplapiClient
  API_URI = URI.parse('http://splapi.retrorocket.biz/gachi/now')

  def initialize
    @client = Net::HTTP.new(API_URI.host, API_URI.port)
  end

  def request
    req = Net::HTTP::Get.new(API_URI.request_uri)
    response = @client.request(req)

    if response.code == '200'
      JSON.parse(response.body)
    else
      {}
    end
  end
end
