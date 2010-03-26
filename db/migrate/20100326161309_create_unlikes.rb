class CreateUnlikes < ActiveRecord::Migration
  def self.up
    create_table :unlikes do |t|
      t.string :keyword, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
    add_index :unlikes, :user_id
  end

  def self.down
    drop_table :unlikes
  end
end
