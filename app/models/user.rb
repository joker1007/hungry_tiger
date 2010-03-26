class User < ActiveRecord::Base
  has_many :meal_statuses
  has_many :unlikes
  has_many :meals, :through => :meal_statuses
end
