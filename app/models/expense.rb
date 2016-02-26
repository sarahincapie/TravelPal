class Expense < ActiveRecord::Base

  belongs_to :user

  enum option: [ :nightlife, :food, :attractions, :lodging, :transportation, :flights, :miscellaneous ]

end
