require 'open-uri'
require 'open_uri_redirections'

class IncomingController < ApplicationController
  prepend_before_filter :get_current_user, only: [:send_message]
  around_action :get_current_user, only: [:process_long_text, :process_short_text, :store_picture]

  def get_current_user
    @current_user = User.find_by(number: params[:From])
  end

    ## gets category for a short text. format: "10 F Miami" => "Price Category Location" (location optional) ##
  def get_short_text_category(letter)
    case letter
    when "f" then "Food"
    when "a" then "Accommodation"
    when "t" then "Transportation"
    when "e" then "EntertainmentAttractions"
    when "c" then "Culture"
    when "n" then "Nightlife"
    when "s" then "Shopping"
    when "o" then "SportsOutdoor"
    when "ne" then "NatureEnvironment"
    when "b" then "Business"
    when "h" then "HealthFitness"
    when "m" then "Miscellaneous"
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
      label = "EntertainmentAttractions"

    elsif label.start_with? "/travel/tourist facilities/camping"
      label = "NatureEnvironment"

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
      label = "HealthFitness"

    elsif label.start_with? "/sports/"
      label = "SportsOutdoor"

    else
      label = "Miscellaneous"
    end
  end

  ## runs short text message to create new expense; format: "10 F Miami" => "Price Category Location" (location optional)
  def process_short_text(body)
    body_arr = body.split
    @cost = '%.2f' % body_arr[0].to_f
    p body_arr[1]
    p body_arr[1].to_s
    letter = body_arr[1].to_s.strip.downcase
    p letter
    @label = get_short_text_category(letter)
    if body_arr.length == 2
      @location = @current_user.trips.last.expenses.last.location
    else body_arr.length == 3
      @location = body_arr[2].to_s.strip.capitalize
    end
    @new_expense = @current_user.trips.last.expenses.create(textmsg: body, cost: @cost, location: @location, category: @label, date: Time.now.utc)
  end

  ## runs long text message through Alchemy to create new expense ##
  def process_long_text(body)
    alchemyapi = AlchemyAPI.new(ENV['AL_CLIENT_ID'])

    response_taxonomy = alchemyapi.taxonomy('text', body, language: 'english')
    response_entity = alchemyapi.entities('text', body, language: 'english')
    response_keyword = alchemyapi.keywords('text', body, language: 'english')

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
      @location = response_entity['entities'].first['text'].to_s.strip.capitalize
      p @location

      ## SET COST OF EXPENSE ##
      @cost = '%.2f' % @body.scan(/\d/).join('').to_f
      p @cost

      @new_expense = @current_user.trips.last.expenses.create(textmsg: @body, cost: @cost, location: @location, category: @label, date: Time.now.utc)

      puts JSON.pretty_generate(response_keyword)
      # p JSON.pretty_generate(response_sentiment)
      ## Adds keyword tags to new expense ##
      for keyword in response_keyword['keywords']
        new_key = keyword['text']
        p new_key
        @new_expense.tag_list.add(new_key)
        @new_expense.save
      end
    
    # if JUST taxonomy present, NO entity/city   
    elsif response_taxonomy['status'] == 'OK'
      @location = @current_user.trips.last.expenses.last.location
      @label = get_long_text_category(response_taxonomy['taxonomy'].first['label'])   
      @cost = '%.2f' % @body.scan(/\d/).join('')
      @new_expense = @current_user.trips.last.expenses.create(textmsg: @body, cost: @cost, location: @location, category: @label, date: Time.now.utc)
      
      ## Adds keyword tags to new expense ##
      # for keyword in response_keyword['keywords']
      #   new_key = keyword['text']
      #   p new_key
      #   @new_expense.tag_list.add(new_key)
      #   @new_expense.save
      # end

      # to account for geocoding limit??
      # 5.times do
      #   new_key = response_keyword['keywords']['text']
      #   @new_expense.tag_list.add(new_key)
      #   @new_expense.save
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
    open_pic = open(pic_arr, :allow_redirections => :all) do |f|
      f.each_line { |line| p line }
      base_pic = f.base_uri
      content_type = f.content_type
      p base_pic
      p content_type
      create_pic = @current_user.friends.create(avatar: base_pic)
      p create_pic
    end
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
      bot_response = ["Hi there! I'm your TravelPal. You're text is being processed.", "TravelPal at your service! Processing your text now.", "Thanks for the text. I get lonely sometimes.", "Got it! Processing your text now.", "Ooh that sounds fun! I'll go ahead and submit this expense."]
      feedback_response = "Thanks for the feedback! Feel free to register at mytravelpal.herokuapp.com"
      bot_pictures = ["What a shot! I'll add this to your gallery.", "TravelPal at your service! Photo has been added.", "B-E-A-UTIFUL", "TravelPal likey, keeping this one my private folder. ;)", "This has to be your best picture yet! Submitting photo to gallery."]
      @feedback_score = 0.0
      @count = 0.0
      @all_nums = []

      ## checks if number is current userr ##
      if @current_user
        if @numMedia > 0
          r.Message bot_pictures.sample
          store_picture(@pic_arr)
        elsif @body.split.length == 2 || @body.split.length == 3
          r.Message bot_response.sample
          process_short_text(@body)
        elsif @body.split.length > 5
          r.Message bot_response.sample
          process_long_text(@body)
        elsif @body.strip.downcase == "ds"
          r.Message "You have spent $#{ '%.2f' % @current_user.spent('today')} today."
        elsif @body.strip.downcase == "ws"
          r.Message "You have spent $#{ '%.2f' % @current_user.spent('week')} this week."
        elsif @body.strip.downcase == "ms"
          r.Message "You have spent $#{ '%.2f' % @current_user.spent('month')} this month."
        elsif @body.strip.downcase == "db"
          if @current_user.balance('today') > 0
            r.Message "You have $#{ '%.2f' % @current_user.balance('today')} remaining in your daily budget."
          else @current_user.balance('today') < 0
            r.Message "You are $#{ '%.2f' % @current_user.balance('today').abs} over your daily budget, consider spending less if you can."
          end
        elsif @body.strip.downcase == "wb"
          if @current_user.balance('week') > 0
            r.Message "You have $#{ '%.2f' % @current_user.balance('week')} remaining in your weekly budget."
          else @current_user.balance('week') < 0
            r.Message "You are $#{ '%.2f' % @current_user.balance('week').abs} over your weekly budget, consider spending less if you can."
          end
        elsif @body.strip.downcase == "mb"
          if @current_user.balance('month') > 0
            r.Message "You have $#{ '%.2f' % @current_user.balance('month')} remaining in your monthly budget."
          else @current_user.balance('month') < 0
            r.Message "You are $#{ '%.2f' % @current_user.balance('month').abs} over your monthly budget, consider spending less if you can."
          end
        elsif @body.strip.downcase == "category"
          r.Message "(F)ood, (A)ccommodation, (T)ransportation, (E)ntertainmentAttractions, (C)ulture, (N)ightlife, (S)hopping, (S)portsOutdoor, (NE)atureEnvironment, (B)usiness, (H)ealthFitness, (M)iscellaneous"
        else 
          "Sorry, that's not a valid option please try again."
        end
      elsif @body.strip.downcase == "no"
        r.Message "Alright, thanks anyways! Feel free to register at mytravelpal.herokuapp.com!"
      elsif @body.strip.downcase == "yes"
        r.Message "Awesome! What would you rate our app on a scale of 1 to 10?"
      elsif @body.to_f >= 0.1 && @body.to_f <= 3
        p "bad rating"
        @feedback_score += @body.to_f
        @count += 1
        r.Message feedback_response
      elsif @body.to_f > 3 && @body.to_f <= 5
        p "OK rating"
        @feedback_score += @body.to_f
        @count += 1
        r.Message feedback_response
      elsif @body.to_f > 5 && @body.to_f <= 8
        p "pretty good rating"
        @feedback_score += @body.to_f
        @count += 1
        r.Message feedback_response
      elsif @body.to_f > 8 && @body.to_f <= 10
        p "Awesome rating!"
        @feedback_score += @body.to_f
        @count += 1
        r.Message feedback_response
      elsif @body.to_f > 10
        p "CRAZY RATING"
        @feedback_score += @body.to_f
        @count += 1
        r.Message feedback_response
      elsif @all_nums.exclude? @number
        r.Message "Hey there! We hope you enjoy listening to our pitch on TravelPal, the personal travel management tool in your pocket. Would you like to provide us some feedback at the end? [Yes/No]"
        @all_nums << @number
        p @all_nums
      else
        r.Message "Sorry, that's not a valid option please try again."
      end
    p @feedback_score
    p @count
    p @feedback_score/@count
    end
    # render 'send_message.xml.erb', :content_type => 'text/xml'
    render xml: @twiml.text
  end

end
