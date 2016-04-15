class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :trips, dependent: :destroy
  has_many :expenses, :through => :trips
  has_many :friends, dependent: :destroy


  scope :last_location, -> { find(current_user.id).trips.last.expenses.last.location }
 
  # class << self
    def spent(type)
      today = DateTime.now
      total = 0
      if type == 'today'
        # self.select("created_at AS date, SUM(cost)").where("created_at BETWEEN ? AND ?", today.at_beginning_of_day, today.at_end_of_day)
        Expense.select(:date, :cost).where(trip_id: self.trips.last.id, date: (today).at_beginning_of_day..today.at_end_of_day).each { |e| total += e.cost}        
      elsif type == 'week'
        Expense.select(:date, :cost).where(trip_id: self.trips.last.id, date: (today - 7).at_beginning_of_day..today.at_end_of_day).each { |e| total += e.cost}
        #self.select("created_at AS date, SUM(cost)").where("created_at BETWEEN ? AND ?", (today - 7).at_beginning_of_day, today.at_end_of_day)
      else type == 'month'
        Expense.select(:date, :cost).where(trip_id: self.trips.last.id, date: (today - 30).at_beginning_of_day..today.at_end_of_day).each { |e| total += e.cost}
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
    expenses = expenses[0..6]
    data = {
      nightlife: 0, 
      accommodation: 0,
      food: 0,
      transportation: 0,
      entertainmentattractions: 0,
      culture: 0, 
      shopping: 0,
      sportsoutdoor: 0,
      natureenvironment: 0,
      business: 0,
      healthfitness: 0,
      miscellaneous: 0,

    } 
    expenses.each do |e|
      case e.category
        when 'Nightlife'
          data[:nightlife]+= e.cost
        when 'Accommodation'
          data[:accommodation]+= e.cost
        when 'Food'
          data[:food]+= e.cost
        when 'Transportation'
          data[:transportation]+= e.cost
        when 'EntertainmentAttractions'
          data[:entertainmentattractions]+= e.cost
        when 'Culture'
          data[:culture]+= e.cost
        when 'Shopping'
          data[:shopping]+= e.cost
        when 'Sportsoutdoor'
          data[:sportsoutdoor]+= e.cost
        when 'NatureEnvironment'
          data[:natureenvironment]+= e.cost
        when 'Business'
          data[:business]+= e.cost
        when 'HealthFitness'
          data[:healthfitness]+= e.cost
        when 'Miscellaneous'
          data[:miscellaneous]+= e.cost
      end
    end
    data 
  end


def bar_data(expenses)
  data = []
  expenses.each do |e|
    is_dup = false
    data.each do |d| 
      if d[:location] == e.location
        is_dup = true 
        d[:cost] += e.cost
      end
    end
    data << {location: e.location, cost: e.cost} unless is_dup
  end
  data = data[0..6]
end 



def pink_data(expenses)
   data = []
    expenses.each do |e|
    is_dup = false
    data.each do |d| 
      if d[:date] == e.date
        is_dup = true 
        d[:cost] += e.cost
      end
    end
    data << { date: e.date, cost: e.cost} unless is_dup
  end
  data
end 




  # def self.geojson
  #   geojson = Hash.new
  #   features = []
  #   geojson[:type] = "FeatureCollection"
  #   geojson[:features] = features
  #   by_recency.each do |expense|
  #     features << {
  #       type: "Feature",
  #       geometry: {
  #         type: "Point",
  #         coordinates: [expense.longitude, expense.latitude]
  #       },
  #       properties: {
  #         category: expense.category.name,
  #         url: "/expenses/#{expense.id}",
  #         photo: expense.photo.url,
  #         updated_at: expense.display_date,
  #         id: "expense-#{expense.id}",
  #         icon: {
  #           html: expense.category.icon,
  #           iconSize: [50, 50],
  #           iconAnchor: [25, 25],
  #           popupAnchor: [0, -25],
  #           className: "#{expense.marker_color} map-icon"
  #         }
  #       }
  #     }
  #   end
  #   geojson
  # end

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
