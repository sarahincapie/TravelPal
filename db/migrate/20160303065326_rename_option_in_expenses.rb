class RenameOptionInExpenses < ActiveRecord::Migration
  def change
    rename_column :expenses, :option, :category
  end
end
