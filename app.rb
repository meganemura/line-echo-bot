require 'bundler/setup'
require 'sinatra'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'linebot'

get '/' do
  "Hello, world"
end

post '/callback' do
  signature = request.env['HTTP_X_LINE_CHANNELSIGNATURE']
  unless client.validate_signature(request.body.read, signature)
    error 400 do 'Bad Request' end
  end

  receive_request = Line::Bot::Receive::Request.new(request.env)

  receive_request.data.each { |message|
    case message.content
    # Line::Bot::Receive::Message
    when Line::Bot::Message::Text, Line::Bot::Message::Sticker
      client.send_text(
        to_mid: message.from_mid,
        text: message.inspect
      )
    # Line::Bot::Receive::Operation
    when Line::Bot::Operation::AddedAsFriend
      client.send_sticker(
        to_mid: message.from_mid,
        stkpkgid: 2,
        stkid: 144,
        stkver: 100
      )
    end
  }

  "OK"
end
