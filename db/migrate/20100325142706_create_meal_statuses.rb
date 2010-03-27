class CreateMealStatuses < ActiveRecord::Migration
  def self.up
    create_table :meal_statuses do |t|
      t.integer :user_id, :null => false
      t.integer :meal_id, :null => false
      t.date :date, :null => false
      t.string :status, :null => false
      t.string :meal_type, :null => false
      t.integer :matched_user_id
      t.timestamps
    end
    add_index :meal_statuses, :user_id
    add_index :meal_statuses, :status
    add_index :meal_statuses, [:user_id, :meal_id], :unique => true
    add_index :meal_statuses, :date
  end

  def self.down
    drop_table :meal_statuses
  end
end
