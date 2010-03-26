class MealStatus < ActiveRecord::Base
  belongs_to :user
  belongs_to :meal
  belongs_to :matched_user, :class_name => "User"

  def self.eatable?(user_id, meal_id)
    ms = MealStatus.find(:first, :conditions => ["user_id = ? AND meal_id = ?", user_id, meal_id])
    ms.nil? ? "eatable" : ms.status
  end
end
