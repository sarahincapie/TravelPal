class Expense < ActiveRecord::Base

  belongs_to :user
  belongs_to :trip

  acts_as_taggable_on :tags

  geocoded_by :location   # can also be an IP address
  after_validation :geocode   # auto-fetch coordinates

  enum category: [:Food, :Accommodation, :Transportation, :Entertainment_Attractions, :Culture, 
    :Nightlife, :Shopping, :Sports_Outdoor, :Nature_Environment, :Business, :Health_Fitness, :Miscellaneous ]


# def get_expense_by_day
# 	 array = %w(cost date)
# 	 as_json.inject({}) do | hash, key, value | 
# 	 	if array.include? key 
# 	 		hash[key] = value
# 	 	end 
# 	 	hash 
# 	 end 
# 	end 

  # class << self
  #   def spent(type)
  #     today = DateTime.now
  #     total = 0
  #     if type == 'today'
  #       # self.select("created_at AS date, SUM(cost)").where("created_at BETWEEN ? AND ?", today.at_beginning_of_day, today.at_end_of_day)
  #       self.select(:created_at, :cost).where(trip_id: current_user.trips.last.id, created_at: (today).at_beginning_of_day..today.at_end_of_day).each { |e| total += e.cost}        
  #     elsif type == 'week'
  #       self.select(:created_at, :cost).where(trip_id: current_user.trips.last.id, created_at: (today - 7).at_beginning_of_day..today.at_end_of_day).each { |e| total += e.cost}
  #       #self.select("created_at AS date, SUM(cost)").where("created_at BETWEEN ? AND ?", (today - 7).at_beginning_of_day, today.at_end_of_day)
  #     else type == 'month'
  #       self.select(:created_at, :cost).where(trip_id: current_user.trips.last.id, created_at: (today - 30).at_beginning_of_day..today.at_end_of_day).each { |e| total += e.cost}
  #       # self.select("created_at AS date, SUM(cost)").where("created_at BETWEEN ? AND ?", (today - 30).at_beginning_of_day, today.at_end_of_day)
  #     end
  #     total
  #   end
  # end

  # class << self
  #   def balance(type)
  #     if type == 'today'
  #       self.current_user.trips.last.daily_budget - spent("today")
  #     elsif type == 'week'
  #       (self.trips.last.daily_budget * 7) - spent("week")
  #     else type == 'month'
  #       (self.trips.last.daily_budget * 30) - spent("month")
  #     end
  #   end
  # end

end

