class TopController < ApplicationController
  def index
    keycode = params[:keycode]
    @user = User.find(keycode)
    @meal_statuses = MealStatus.find(:all, :conditions => ["user_id = ? OR matched_user_id IS NOT NULL", @user.id], :limit => 10, :order => "date")
  end
end
