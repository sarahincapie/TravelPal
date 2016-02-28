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
    render 'send_message.xml.erb', :content_type => 'text/xml'
  end

  def process_text
    alchemyapi = AlchemyAPI.new(ENV['AL_CLIENT_ID'])

    text_message = params[:id]
    new_message = Message.create(textmsg: text_message)



    puts 'Processing text: ' + text_message
    puts ''

    response_taxonomy = alchemyapi.taxonomy('text', text_message)
    response_entity = alchemyapi.entities('text', text_message)

    if response_taxonomy['status'] == 'OK' && response_entity['status'] == 'OK'
      puts '## Response Object ##'
      puts JSON.pretty_generate(response_taxonomy)

      puts ''
      puts '## Taxonomy ##'
      for taxonomy in response_taxonomy['taxonomy']
        puts 'label: ' + taxonomy['label']
        puts 'score: ' + taxonomy['score']
        puts ''
        new_message.label = taxonomy['label']
        new_message.score = taxonomy['score']
      end

      puts ''
      puts '## Entity ##'
      for entity in response_entity['entities']
        if entity['type'] == "City"
          puts 'text: ' + entity['text']
          puts 'type: ' + entity['type']
          puts 'relevance: ' + entity['relevance']
          # puts ''
          # new_message.label = taxonomy['label']
          # new_message.score = taxonomy['score']
        end
      end
      puts ''
      puts '## Price ##'
      price = text_message.scan(/\d/).join('')
      puts price

    else
      puts 'Error in concept tagging call: ' + response_taxonomy['statusInfo']
    end
    redirect_to message_path
  end
end
