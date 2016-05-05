require 'line/bot'

require 'splapi_client'

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

    message = "【#{result['rule']}】\n#{result['maps'].map {|x| "* #{x}" }.join("\n")}"
  end
end
