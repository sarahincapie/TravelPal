class MessagesController < ApplicationController
  def index
    client
    @client
  end

  private
  def client
    twilio_phone_number = "8329687725"
    account_sid = "AC92b8e49df8f7eec3f70c154b37e57052"
    auth_token = "1856e440cbfdec0181737f7075c59cfa"

    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new account_sid, auth_token
  end
end
