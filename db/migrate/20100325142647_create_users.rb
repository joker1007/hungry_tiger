class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name, :null => false
      t.string :room, :null => false
      t.boolean :no_meal_flag, :default => false
      t.string :keycode, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
