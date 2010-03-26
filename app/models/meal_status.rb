class MealStatus < ActiveRecord::Base
  belongs_to :user
  belongs_to :meal
  belongs_to :matched_user, :class_name => "User"
end
