class RemoveUserFromExpense < ActiveRecord::Migration
  def change
    remove_reference :expenses, :user, index: true, foreign_key: true
  end
end
