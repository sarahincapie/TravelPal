class IncomingController < ApplicationController
  def send_message
    body = params[:Body]
    @twiml = Twilio::TwiML::Response.new do |r|
      if body == "Hello Sara"
          r.Message "Have fun Sara"
      else
          r.Message "Nice try :("
      end
      # r.Message "What up bruh."
    end
    render 'send_message.xml.erb', :content_type => 'text/plain'
  end
end
