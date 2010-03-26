class TopController < ApplicationController
  def index
    keycode = params[:keycode]
    @user = User.find_by_keycode(keycode)

    meal_type = Time.now.hour >= 10 || Time.now.hour <= 1 ? "Dinner" : "Breakfast"
    @meal = Meal.find(:first, :conditions => ["date = ? AND meal_type = ?", Date.today, meal_type])

    @eatable = MealStatus.find(:all, :conditions => ["meal_id = ? AND user_id = ?", @meal.id, @user.id]).empty? ? true : false

    if @eatable
      @message = "#{@user.name}さんは本日お食事予定です"
    else
      @message = "#{@user.name}さんは本日欠食のため食べられません"
    end

    @meal_statuses = MealStatus.find(:all, :conditions => ["user_id = ? OR matched_user_id IS NOT NULL", @user.id], :limit => 10, :order => "date")
  end
end
