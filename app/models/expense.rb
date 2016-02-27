class Expense < ActiveRecord::Base

  belongs_to :user
  
  acts_as_taggable_on :tags

  enum option: [:Food, :Accommodation, :Transport, :EntertainmentandAttractions,:NatureandOutdoor,
   :Culture,:Nightlife ,:Sports,:ShoppingandGifts, :Business, :Health, :Miscellaneous ]

end
