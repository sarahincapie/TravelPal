class IncomingController < ApplicationController
  prepend_before_filter :get_current_user, only: [:send_message]
  around_action :get_current_user, only: [:process_long_text, :process_short_text]

  def get_current_user
    @current_user = User.find_by(number: params[:From])
  end

    ## gets category for a short text. format: "10 F Miami" => "Price Category Location" (location optional) ##
  def get_short_text_category(letter)
    case letter
    when "F" then "Food"
    when "A" then "Accommodation"
    when "T" then "Transportation"
    when "E" then "Entertainment_Attractions"
    when "C" then "Culture"
    when "N" then "Nightlife"
    when "S" then "Shopping"
    when "O" then "Sports_Outdoor"
    when "NE" then "Nature_Environment"
    when "B" then "Business"
    when "H" then "Health_Fitness"
    when "M" then "Miscellaneous"
    end
  end

  ## filters Alchemy taxonomy classifications into 1 of 12 TravelPal categories ##
  def get_long_text_category(label)
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
      label = "Nature_Environment"

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
      label = "Health_Fitness"

    elsif label.start_with? "/sports/"
      label = "Sports_Outdoor"

    else
      label = "Miscellaneous"
    end
  end

  ## runs short text message to create new expense; format: "10 F Miami" => "Price Category Location" (location optional)
  def process_short_text(body)
    body_arr = body.split
    @cost = body_arr[0].to_f
    @label = get_short_text_category(body_arr[1])
    if body_arr.length == 2
      @location = current_user.last_location
    else body_arr.length == 3
      @location = body_arr[2]
    end
    @new_expense = @current_user.trips.last.expenses.build(textmsg: body, cost: @cost, location: @location, category: @label)
  end

  ## runs long text message through Alchemy to create new expense ##
  def process_long_text(body)
    alchemyapi = AlchemyAPI.new(ENV['AL_CLIENT_ID'])

    puts 'Processing text: ' + body

    response_taxonomy = alchemyapi.taxonomy('text', body, language: 'english')
    response_entity = alchemyapi.entities('text', body, language: 'english')
    # response_sentiment = alchemyapi.sentiment_targeted('text', body, language: 'english')

    # if BOTH taxonomy and entity present
    if response_taxonomy['status'] == 'OK' && response_entity['status'] == 'OK'
      # puts '## Response Object ##'
      # puts JSON.pretty_generate(response_taxonomy)

      ## SET CATEGORY/TAXONOMY LABEL ##
      @label = get_long_text_category(response_taxonomy['taxonomy'].first['label'])
      p @label

      ## SET CITY/LOCATION ##
      for entity in response_entity['entities']
        if entity['type'] == "City"
          puts 'text: ' + entity['text']
          puts 'type: ' + entity['type']
          @location = entity['text']
        end
      end

      ## SET COST OF EXPENSE ##
      @cost = @body.scan(/\d/).join('')
      p @cost

      @new_expense = @current_user.trips.last.expenses.build(textmsg: @body, cost: @cost, location: @location, category: @label)

      ## Adds sentiment tags to new expense ##
      # for sentiment in response_sentiment['docSentiment']
      #   new_sentiment = sentiment['type']
      #   @new_expense.tag_list.add(new_sentiment)
      # end
    
    # if JUST taxonomy present, NO entity/city   
    elsif response_taxonomy['status'] == 'OK'
      @location = @current_user.expenses.locations.last
      @label = get_long_text_category(response_taxonomy['taxonomy'].first['label'])   
      @cost = @body.scan(/\d/).join('')
      @new_expense = @current_user.trips.last.expenses.build(textmsg: @body, cost: @cost, location: @location, category: @label)
      
      ## Adds sentiment tags to new expense ##
      # for sentiment in response_sentiment['docSentiment']
      #   new_sentiment = sentiment['type']
      #   @new_expense.tag_list.add(new_sentiment)
      # end

    else
      puts 'Error in concept tagging call: ' + response_taxonomy['statusInfo']
    end
  end

  ## checks if number is true ##
  # def number_present?(number)
  #   if User.find_by(number: number) then true
  #   else "Sorry, you are not a registered user"
  #   end
  # end  

  ## Receives text message and checks the body for input or request ##
  def send_message
    @twiml = Twilio::TwiML::Response.new do |r|

    @body = params[:Body]
    @number = params[:From]

      if @body.split.length == 2 || @body.split.length == 3
        r.Message "Hi there! I'm your TravelPal. You're text is being processed."
        process_short_text(@body)
      elsif @body.split.length > 5
        r.Message "Hi there! I'm your TravelPal. You're text is being processed."
        process_long_text(@body)
      # elsif @body == "ds" then current_user.spent('today')
      # elsif @body == "ws" then current_user.spent('week')
      # elsif @body == "ms" then current_user.spent('month')
      # elsif @body == "db" then current_user.balance('today')
      # elsif @body == "wb" then current_user.balance('week')
      # elsif @body == "mb" then current_user.balance('month')
      else 
        "Sorry, that's not a valid option please try again."
      end
    end
    # render 'send_message.xml.erb', :content_type => 'text/xml'
    render xml: @twiml.text
  end

end
