class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.float :score
      t.string :number

      t.timestamps null: false
    end
  end
end
