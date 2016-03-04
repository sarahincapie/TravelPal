class Expense < ActiveRecord::Base

  belongs_to :user
  belongs_to :trip

  acts_as_taggable_on :tags

  geocoded_by :location   # can also be an IP address
  after_validation :geocode   # auto-fetch coordinates

  enum category: [:Food, :Accommodation, :Transportation, :Entertainment_Attractions, :Nature_Environment,
   :Culture, :Nightlife, :Sports_Outdoor, :Shopping, :Business, :Health_Fitness, :Miscellaneous ]


# def get_expense_by_day

# 	 array = %w(cost date)
# 	 as_json.inject({}) do | hash, key, value | 
# 	 	if array.include? key 
# 	 		hash[key] = value
# 	 	end 
# 	 	hash 
# 	 end 

# 	end 



  class << self
    def spent(type)
      today = DateTime.now
      if type == 'today'
        self.select("created_at AS date, SUM(cost)").where("created_at BETWEEN ? AND ?", today.at_beginning_of_day, today.at_end_of_day)
      elsif type == 'week'
        self.select("created_at AS date, SUM(cost)").where("created_at BETWEEN ? AND ?", (today - 7).at_beginning_of_day, today.at_end_of_day)
      else type == 'month'
        self.select("created_at AS date, SUM(cost)").where("created_at BETWEEN ? AND ?", (today - 30).at_beginning_of_day, today.at_end_of_day)
      end
    end
  end




  # class << self
  #   def balance(type)
  #     if type == 'today'
  #       current_user. - spent("today")
  #     elsif type == 'weekly'
  #       @daily_budget - spent("week")
  #     else type == 'monthly'
  #       @daily_budget - spent("month")
  #     end
  #   end
end

