class CreateMoneyexchanges < ActiveRecord::Migration
  def change
    create_table :moneyexchanges do |t|
      t.float :money

      t.timestamps null: false
    end
  end
end
