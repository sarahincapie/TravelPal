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

    # new text message body and date added to Expense model
    text_body = params[:id]
    text_date = params[:date_created]
    new_message = Expense.create(textmsg: text_body, date: text_date)

    puts 'Processing text: ' + text_body
    puts ''

    response_taxonomy = alchemyapi.taxonomy('text', text_body)
    response_entity = alchemyapi.entities('text', text_body)

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
