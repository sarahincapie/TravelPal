class AddTypeToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :option, :integer,  default: 0, index: true
  end
end
