require 'open-uri'

class IncomingController < ApplicationController
  prepend_before_filter :get_current_user, only: [:send_message]
  around_action :get_current_user, only: [:process_long_text, :process_short_text, :store_picture]

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
                         "/art and entertainment" ## if in A+E but not culture or nightlife
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
      @location = @current_user.last_location
    else body_arr.length == 3
      @location = body_arr[2]
    end
    @new_expense = @current_user.trips.last.expenses.create(textmsg: body, cost: @cost, location: @location, category: @label)
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
      p response_taxonomy['taxonomy'].first['label']
      @label = get_long_text_category(response_taxonomy['taxonomy'].first['label'])
      p @label

      ## SET CITY/LOCATION ##
      # for entity in response_entity['entities']
      #   if entity['type'] == "City"
      #     puts 'text: ' + entity['text']
      #     puts 'type: ' + entity['type']
      #     @location = entity['text']
      #   end
      # end
      @location = response_entity['entities'].first['text']
      p @location

      ## SET COST OF EXPENSE ##
      @cost = @body.scan(/\d/).join('').to_f
      p @cost

      p @current_user
      @new_expense = @current_user.trips.last.expenses.create(textmsg: @body, cost: @cost, location: @location, category: @label)

      # p JSON.pretty_generate(response_sentiment)
      ## Adds sentiment tags to new expense ##
      # for sentiment in response_sentiment['docSentiment']
      #   new_sentiment = sentiment['type']
      #   @new_expense.tag_list.add(new_sentiment)
      # end
    
    # if JUST taxonomy present, NO entity/city   
    elsif response_taxonomy['status'] == 'OK'
      @location = @current_user.last_location
      @label = get_long_text_category(response_taxonomy['taxonomy'].first['label'])   
      @cost = @body.scan(/\d/).join('')
      @new_expense = @current_user.trips.last.expenses.create(textmsg: @body, cost: @cost, location: @location, category: @label)
      
      ## Adds sentiment tags to new expense ##
      # for sentiment in response_sentiment['docSentiment']
      #   new_sentiment = sentiment['type']
      #   @new_expense.tag_list.add(new_sentiment)
      # end

    else
      puts 'Error in concept tagging call: ' + response_taxonomy['statusInfo']
    end
  end

  def store_picture(pic_arr)
    # p pic_arr
    # @numMedia.times do |n|
    #   m = (n - 1)
    #   new_pic = pic_arr[m]
    #   p new_pic
    #   open_pic = open(new_pic) do |f|
    #     f.each_line { |line| p line }
    #     base_pic = f.base_uri
    #     p base_pic
    #     create_pic = @current_user.friends.create(avatar: base_pic)
    #   end
    #   p create_pic
    # end
    create_pic = @current_user.friends.create(avatar: pic_arr)
    p create_pic

  end


  ## Receives text message and checks the body for input or request ##
  def send_message
    @twiml = Twilio::TwiML::Response.new do |r|

      @body = params[:Body]
      @number = params[:From]
      @numMedia = params[:NumMedia].to_i # The number of media items associated with your message
      # @pic_arr = [] # stores an array of picture URLs
      # @numMedia.times do |n|
      #   m = (n - 1)
      #   media = "MediaUrl#{m}".to_sym
      #   @pic_arr << params[media] # if 1 or more MMS, :mediaUrl{n-1} is picture
      # end

      @pic_arr = params[:MediaUrl0]

      @feedback_score = 0.0
      @count = 0
      @rating = @feedback_score/@count
      @all_nums = []

      ## checks if number is current userr ##
      if @current_user
        if @numMedia > 0
          p @pic_arr
          store_picture(@pic_arr)
        elsif @body.split.length == 2 || @body.split.length == 3
          r.Message "Hi there! I'm your TravelPal. You're text is being processed."
          process_short_text(@body)
        elsif @body.split.length > 5
          r.Message "Hi there! I'm your TravelPal. You're text is being processed."
          process_long_text(@body)
        elsif @body == "ds" then @current_user.spent('today')
        elsif @body == "ws" then @current_user.spent('week')
        elsif @body == "ms" then @current_user.spent('month')
        elsif @body == "db" then @current_user.balance('today')
        elsif @body == "wb" then @current_user.balance('week')
        elsif @body == "mb" then @current_user.balance('month')
        else 
          "Sorry, that's not a valid option please try again."
        end
      elsif @body.downcase == "no"
        r.Message "Alright, thanks anyways! Feel free to register at www.travelpal.herokuapp.com!"
      elsif @body.downcase == "yes"
        r.Message "Woot! What would you rate our app on a scale of 1 to 10?"
      elsif @body.to_f >= 0 && @body.to_f <= 3
        p "bad rating"
        @feedback_score += @body.to_f
        @count += 1
        r.Message "Thanks for the feedback! Feel free to register at www.travelpal.herokuapp.com"
      elsif @body.to_f > 3 && @body.to_f <= 5
        p "OK rating"
        @feedback_score += @body.to_f
        @count += 1
        r.Message "Thanks for the feedback! Feel free to register at www.travelpal.herokuapp.com"
      elsif @body.to_f > 5 && @body.to_f <= 8
        p "pretty good rating"
        @feedback_score += @body.to_f
        @count += 1
        r.Message "Thanks for the feedback! Feel free to register at www.travelpal.herokuapp.com"
      elsif @body.to_f > 8 && @body.to_f <= 10
        p "Awesome rating!"
        @feedback_score += @body.to_f
        @count += 1
        r.Message "Thanks for the feedback! Feel free to register at www.travelpal.herokuapp.com"
      elsif @body.to_f > 10
        p "CRAZY RATING"
        @feedback_score += @body.to_f
        @count += 1
        r.Message "Thanks for the feedback! Feel free to register at www.travelpal.herokuapp.com"
      elsif @all_nums.exclude? @number
        r.Message "Hey there! TravelPal at your service. Thanks for listening to our pitch. Would you like to provide some feedback? [Yes/No]"
        @all_nums << @number
        p @all_nums
      else
        r.Message "Sorry, that's not a valid option please try again."
      end
    p @rating.to_f
    end
    # render 'send_message.xml.erb', :content_type => 'text/xml'
    render xml: @twiml.text
  end

end
