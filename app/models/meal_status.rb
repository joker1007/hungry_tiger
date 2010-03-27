class MealStatus < ActiveRecord::Base
  belongs_to :user
  belongs_to :meal
  belongs_to :matched_user, :class_name => "User"

  def self.eatable?(user_id, meal_id)
    ms = MealStatus.find_by_user_id_and_meal_id(user_id, meal_id)
    ms2 = MealStatus.find_by_meal_id_and_matched_user_id(meal_id, user_id)
    if ms.nil?
      "eatable"
    elsif ms2
      "re-eatable"
    else
      ms.status
    end
  end

  def self.buyable_count(meal_id)
    meal_statuses = MealStatus.find(:all, :conditions => ["meal_id = ? AND status = 'sold' AND matched_user_id IS NULL", meal_id])
    meal_statuses.length
  end
end
