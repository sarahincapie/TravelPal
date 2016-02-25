class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :textmsg
      t.float :cost
      t.string :date
      t.string :time
      t.string :location
      t.float :latitude
      t.float :longitude
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
