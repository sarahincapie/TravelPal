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

  # def day_spent
  #   # d = Date.today.to_s
  #   today = Date.today.strftime("%m/%d/%Y")
  #   total = "SELECT date, SUM(cost) FROM expenses WHERE user_id=? AND date=?",
  #   Expense.connection.select_all total
  # end

  # def week_spent
  #   today = Date.today.strftime("%m/%d/%Y")
  #   week_ago = (Date.today - 7).strftime("%m/%d/%Y")
  #   total = "select date, sum(cost) from expenses where user_id=#{self.id} where date between #{week_ago} and #{today};"
  #   Expense.connection.select_all total
  # end

  # def month_spent
  #   today = Date.today.strftime("%m/%d/%Y")
  #   month_ago = (Date.today - 30).strftime("%m/%d/%Y")
  #   total = "select date, sum(cost) from expenses where user_id=#{self.id} where date between #{month_ago} and #{today};"
  #   Expense.connection.select_all total
  # end

  # def day_balance

  # end

  # def week_balance
  # end

  # def month_balance
  # end
end
