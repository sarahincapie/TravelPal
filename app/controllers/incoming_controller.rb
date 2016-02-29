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

  def get_category
    if label.include? "/art and entertainment/books and literature/" || 
                      "/art and entertainment/theatre/" || 
                      "/art and entertainment/music/" ||
                      "/art and entertainment/visual art and design/"
      label = "Culture"

    elsif label.include? "/art and entertainment/dance/" ||
                         "/food and drink/beverages/alcoholic beverages/"                     
      label = "Nightlife"

    elsif label.include? "/food and drink"
      label = "Food"

    elsif label.include? "/art and entertainment/movies and tv/" ||
                         "/art and entertainment/movies/" ||
                         "/art and entertainment/shows and events/" ||
                         "/hobbies and interests/games/" ||
                         "/travel/tourist destinations/" ||
                         "/travel/specialty travel/sightseeing tours"
      label = "Entertainment/Attractions"

    elsif label.include? "/travel/tourist facilities/camping"
      label = "Nature/Environment"

    elsif label.include? "/travel/hotels" ||
                         "/travel/tourist facilities/hotel" ||
                         "/travel/tourist facilities/bed and breakfast" ||
                         "/real estate/apartments"
      label = "Accommodation"

    elsif label.include? "/travel/transports/" ||
                         "/travel/budget travel" ||
                         "/travel/business travel" ||
                         "/travel/honeymoons and getaways" ||
                         "/automotive and vehicles/" ||
                         "/business and industrial/logistics/"
      label = "Transportation"

    elsif label.include? "/shopping/" ||
                         "/style and fashion/"
      label = "Shopping"

    elsif label.include? "/business and industrial/" ||
                         "/finance/" ||
                         "/careers"
      label = "Business"

    elsif label.include? "/health and fitness/"
      label = "Health/Fitness"

    elsif label.include? "/sports/"
      label = "Sports/Outdoors"

    else
      label = "Miscellaneous"
    end
  end

end
