class Meal < ActiveRecord::Base
  has_many :meal_statuses
end
