require 'bundler/setup'

require 'ruboty'
Thread.start do
  Ruboty::CommandBuilder.new(ARGV).build.call
end

require './app'
run Sinatra::Application
