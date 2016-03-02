class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :trips, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :friends, dependent: :destroy

  # use this method in a controller method to create a json hash. Use json hash to pass into view for jquery to build
  # the D3 graphs once its called on.


  # def expense_cost_by_date
  #   q = "select date, sum(cost) from expenses where user_id=#{self.id} group by date;"
  #   Expense.connection.select_all q
  # end

end
