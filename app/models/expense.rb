class Expense < ActiveRecord::Base

  belongs_to :user
  belongs_to :trip

  acts_as_taggable_on :tags

  geocoded_by :location   # can also be an IP address
  after_validation :geocode   # auto-fetch coordinates

  enum option: [:Food, :Accommodation, :Transport, :Entertainment_Attractions, :Nature_Environment,
   :Culture, :Nightlife, :Sports_Outdoor, :Shopping, :Business, :Health, :Miscellaneous ]

# def get_expense_by_day

# 	 array = %w(cost date)
# 	 as_json.inject({}) do | hash, key, value | 
# 	 	if array.include? key 
# 	 		hash[key] = value
# 	 	end 
# 	 	hash 
# 	 end 

# 	end 

end
