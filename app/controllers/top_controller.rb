class TopController < ApplicationController
  def index
    meal_type = Time.now.hour >= 10 || Time.now.hour <= 1 ? "Dinner" : "Breakfast"
    @meal = Meal.find(:first, :conditions => ["date = ? AND meal_type = ?", Date.today, meal_type])
    keycode = params[:keycode]
    @user = User.find_by_keycode(keycode)
    @meal_statuses = MealStatus.find(:all, :conditions => ["user_id = ? OR matched_user_id IS NOT NULL", @user.id], :limit => 10, :order => "date")
  end
end
