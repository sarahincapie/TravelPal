class MessagesController < ApplicationController
  def index
    client
    @client
  end

  private
  def client
    twilio_phone_number = "8329687725"
    account_sid = ENV['CLIENT_ID']
    auth_token = ENV['CLIENT_SECRET']

    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new account_sid, auth_token
  end
end
