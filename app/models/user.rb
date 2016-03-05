class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :trips, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :friends, dependent: :destroy

  scope :last_location, -> { find(current_user.id).trips.last.expenses.last.locations }
 
  # class << self
    def spent(type)
      today = DateTime.now
      total = 0
      if type == 'today'
        # self.select("created_at AS date, SUM(cost)").where("created_at BETWEEN ? AND ?", today.at_beginning_of_day, today.at_end_of_day)
        Expense.select(:created_at, :cost).where(trip_id: self.trips.last.id, created_at: (today).at_beginning_of_day..today.at_end_of_day).each { |e| total += e.cost}        
      elsif type == 'week'
        Expense.select(:created_at, :cost).where(trip_id: self.trips.last.id, created_at: (today - 7).at_beginning_of_day..today.at_end_of_day).each { |e| total += e.cost}
        #self.select("created_at AS date, SUM(cost)").where("created_at BETWEEN ? AND ?", (today - 7).at_beginning_of_day, today.at_end_of_day)
      else type == 'month'
        Expense.select(:created_at, :cost).where(trip_id: self.trips.last.id, created_at: (today - 30).at_beginning_of_day..today.at_end_of_day).each { |e| total += e.cost}
        # self.select("created_at AS date, SUM(cost)").where("created_at BETWEEN ? AND ?", (today - 30).at_beginning_of_day, today.at_end_of_day)
      end
      total
    end
  # end

  # class << self
    def balance(type)
      if type == 'today'
        self.trips.last.daily_budget - spent("today")
      elsif type == 'week'
        (self.trips.last.daily_budget * 7) - spent("week")
      else type == 'month'
        (self.trips.last.daily_budget * 30) - spent("month")
      end
    end
  # end

  def donut_data(expenses)
    data = {
      nightlife: 0, 
      accommodation: 0,
      food: 0,
      attraction: 0
    } 
    expenses.each do |e|
      case e.category
        when 'Nightlife'
          data[:nightlife]+= e.cost
        when 'Accommodation'
          p '*' * 1000
          p e.cost
          p '*' * 1000
          data[:accommodation]+= e.cost
        when 'Food'
          data[:food]+= e.cost
        when 'Entertainment_Attractions'
          data[:attraction]+= e.cost
      end
    end
    data 
  end



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

end
