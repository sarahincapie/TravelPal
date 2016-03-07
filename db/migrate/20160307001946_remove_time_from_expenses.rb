class RemoveTimeFromExpenses < ActiveRecord::Migration
  def change
    remove_column :expenses, :time, :string
  end
end
