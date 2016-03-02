class Expense < ActiveRecord::Base

  belongs_to :user
  belongs_to :trip

  acts_as_taggable_on :tags

  geocoded_by :location   # can also be an IP address
  after_validation :geocode   # auto-fetch coordinates

  enum option: [:Food, :Accommodation, :Transport, :EntertainmentandAttractions,:NatureandOutdoor,
   :Culture,:Nightlife ,:Sports,:ShoppingandGifts, :Business, :Health, :Miscellaneous ]

end
