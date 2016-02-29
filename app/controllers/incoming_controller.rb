class IncomingController < ApplicationController
  def send_message
    body = params[:Body]
    @twiml = Twilio::TwiML::Response.new do |r|
      if body == "Hi" || "Hello" || "Test"
          r.Message "Hi there! I'm your TravelPal"
      else
          r.Message "I'll get back to you on that."
      end
      # r.Message "What up bruh."
    end
    render 'send_message.xml.erb', :content_type => 'text/xml'
  end
end
