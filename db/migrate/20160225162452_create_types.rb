class CreateTypes < ActiveRecord::Migration
  def change
    create_table :types do |t|
      t.string :category
      t.belongs_to :expense, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
