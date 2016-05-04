require 'net/http'
require 'uri'
require 'json'

require 'line/bot'

module Linebot
  module_function

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_id = ENV["LINE_CHANNEL_ID"]
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_mid = ENV["LINE_CHANNEL_MID"]
    }
  end

  def splatoon_stage
    splapi = SplapiClient.new
    result = splapi.request

    return '' if result.empty?

    result = result['result'].first

    message = "#{result['rule']}\n#{result['maps'].join('/')}"
  end
end

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
