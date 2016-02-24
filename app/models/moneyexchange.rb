class Moneyexchange < ActiveRecord::Base

 register_currency :us

	  monetize :money,

	:numericality => {
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => 10000
  }
end





