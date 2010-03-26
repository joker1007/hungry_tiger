class CreateMeals < ActiveRecord::Migration
  def self.up
    create_table :meals do |t|
      t.date :date, :null => false
      t.string :meal_type, :null => false
      t.string :name
      t.timestamps
    end
    add_index :meals, [:date, :meal_type], :unique => true
  end

  def self.down
    drop_table :meals
  end
end
