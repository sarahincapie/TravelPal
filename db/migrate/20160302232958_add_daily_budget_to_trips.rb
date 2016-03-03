class AddDailyBudgetToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :daily_budget, :integer
  end
end
