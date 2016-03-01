class IncomingController < ApplicationController

  ## runs text message through Alchemy processing ##
  def process_long_text(body)
    alchemyapi = AlchemyAPI.new(ENV['AL_CLIENT_ID'])

    puts 'Processing text: ' + body

    response_taxonomy = alchemyapi.taxonomy('text', body)
    response_entity = alchemyapi.entities('text', body)

    if response_taxonomy['status'] == 'OK' && response_entity['status'] == 'OK'
      puts '## Response Object ##'
      puts JSON.pretty_generate(response_taxonomy)

      puts '## Taxonomy ##'
      ## SET CATEGORY LABEL ##
      @label = get_category(response_taxonomy['taxonomy']['label'])

      ## IF ABOVE DOESN'T WORK ##
      # 1.times do response_taxonomy['taxonomy']
      #   @label = taxonomy['label']
      # end

      # for taxonomy in response_taxonomy['taxonomy']
      #   puts 'label: ' + taxonomy['label']
      #   puts 'score: ' + taxonomy['score']
      #   new_message.label = taxonomy['label']
      #   new_message.score = taxonomy['score']
      # end

      puts '## Entity ##'
      ## SET LOCATION CITY ##
      for entity in response_entity['entities']
        if entity['type'] == "City"
          puts 'text: ' + entity['text']
          puts 'type: ' + entity['type']
          @location = entity['text']
          # puts 'relevance: ' + entity['relevance']
          # new_message.label = taxonomy['label']
          # new_message.score = taxonomy['score']
        end
      end
      puts '## Price ##'
      ## SET COST OF EXPENSE ##
      @cost = @body.scan(/\d/).join('')
      puts @cost

      @new_message = Expense.create(textmsg: @body, cost: @cost, date: @date_created, location: @location)

      ## ONCE USERS HAVE A PROFILE WITH PHONE NUMBER ##
      # @new_message = current_user.expenses.build(textmsg: @body, cost: @cost, date: @date_created, location: @location)

    else
      puts 'Error in concept tagging call: ' + response_taxonomy['statusInfo']
    end
    # redirect_to message_path
  end



  ## checks if number is true ##
  # def number_present?(number)
  #   if User.find_by(number: number) then true
  #   else "Sorry, you are not a registered user"
  #   end
  # end

  def get_balance
  end

  def get_spent
  end

  def process_short_text(body)
  end




  def get_category(label)
    if label.start_with? "/art and entertainment/books and literature/",
                      "/art and entertainment/theatre/",
                      "/art and entertainment/music/",
                      "/art and entertainment/visual art and design/",
                      "/art and entertainment/shows and events/exhibition"
      label = "Culture"

    elsif label.start_with? "/art and entertainment/dance/",
                         "/food and drink/beverages/alcoholic beverages/"
      label = "Nightlife"

    elsif label.start_with? "/food and drink/"
      label = "Food"

    elsif label.start_with? "/art and entertainment/movies and tv/",
                         "/art and entertainment/movies/",
                         "/art and entertainment/shows and events/",
                         "/hobbies and interests/games/",
                         "/travel/tourist destinations/",
                         "/travel/specialty travel/sightseeing tours",
                         "/travel/travel guides",
                         "/art and entertainment/" ## if in A+E but not culture or nightlife
      label = "Entertainment/Attractions"

    elsif label.start_with? "/travel/tourist facilities/camping"
      label = "Nature/Environment"

    elsif label.start_with? "/travel/hotels",
                         "/travel/tourist facilities/hotel",
                         "/travel/tourist facilities/bed and breakfast",
                         "/real estate/apartments"
      label = "Accommodation"

    elsif label.start_with? "/travel/transports/",
                         "/travel/budget travel",
                         "/travel/business travel",
                         "/travel/honeymoons and getaways",
                         "/automotive and vehicles/",
                         "/business and industrial/logistics/"
      label = "Transportation"

    elsif label.start_with? "/shopping/",
                         "/style and fashion/"
      label = "Shopping"

    elsif label.start_with? "/business and industrial/",
                         "/finance/",
                         "/careers"
      label = "Business"

    elsif label.start_with? "/health and fitness/",
                            "/science/"
      label = "Health/Fitness"

    elsif label.start_with? "/sports/"
      label = "Sports/Outdoors"

    else
      label = "Miscellaneous"
    end
  end

  def send_message
    @body = params[:Body]
    @number = params[:from]
    @date_created = params[:date_created]

    @twiml = Twilio::TwiML::Response.new do |r|
      if @body == "Hello I spent 20"
          r.Message "Hi there! I'm your TravelPal. You're text is being processed."
          process_long_text(@body)
      else
          r.Message "I'll get back to you on that."
      end
    end
    # render 'send_message.xml.erb', :content_type => 'text/xml'
    render xml: @twiml.text
  end

end
