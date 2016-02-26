class Expense < ActiveRecord::Base

  belongs_to :user
  
  acts_as_taggable_on :tags

  enum option: [ :nightlife, :food, :attractions, :lodging, :transportation, :flights, :miscellaneous ]

end
