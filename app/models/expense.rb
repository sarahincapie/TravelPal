class Expense < ActiveRecord::Base

  belongs_to :user
  belongs_to :trip

  acts_as_taggable_on :tags

  geocoded_by :location   # can also be an IP address
  after_validation :geocode   # auto-fetch coordinates

  enum option: [:Food, :Accommodation, :Transport, :Entertainment_Attractions, :Nature_Environment,
   :Culture, :Nightlife, :Sports_Outdoor, :Shopping, :Business, :Health, :Miscellaneous ]

   class << self
     def report type
       if type == 'today'
        today = Date.today.strftime("%m/%d/%Y")
        self.select("date, SUM(cost)").where("date='?'", today)
      elsif type == 'weekly'
        self.select("date, SUM(cost)").where("date BETWEEN ? AND ?", today, today-7.days)
      end
     end
  end
end
