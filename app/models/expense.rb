class Expense < ActiveRecord::Base

  belongs_to :user
  belongs_to :trip

  acts_as_taggable_on :tags

  geocoded_by :location   # can also be an IP address
  after_validation :geocode   # auto-fetch coordinates

  enum option: [:Food, :Accommodation, :Transport, :Entertainment_Attractions, :Nature_Environment,
   :Culture, :Nightlife, :Sports_Outdoor, :Shopping, :Business, :Health, :Miscellaneous ]


  class << self
    def spent(type)
      today = DateTime.now
      if type == 'today'
        self.select("created_at AS date, SUM(cost)").where("created_at BETWEEN ? AND ?", today.at_beginning_of_day, today.at_end_of_day)
      elsif type == 'weekly'
        self.select("created_at AS date, SUM(cost)").where("created_at BETWEEN ? AND ?", (today - 7).at_beginning_of_day, today.at_end_of_day)
      else type == 'monthly'
        self.select("created_at AS date, SUM(cost)").where("created_at BETWEEN ? AND ?", (today - 30).at_beginning_of_day, today.at_end_of_day)
      end
    end
  end

  # class << self
  #   def balance(type)

  #   end
end
