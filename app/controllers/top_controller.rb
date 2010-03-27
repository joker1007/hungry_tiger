class TopController < ApplicationController
  before_filter :user_check

  def index
    meal_type = Time.now.hour >= 10 || Time.now.hour <= 1 ? "Dinner" : "Breakfast"
    @meal = Meal.find(:first, :conditions => ["date = ? AND meal_type = ?", Date.today, meal_type])

    @eatable = MealStatus.eatable?(@user.id, @meal.id)

    if @eatable == "eatable"
      @message = "#{@user.name}さんは本日お食事予定です"
    elsif @eatable == "rejected"
      @message = "#{@user.name}さんは本日欠食のため食べられません"
    elsif @eatable == "sold"
      @message = "#{@user.name}さんは本日緊急欠食のため食べられません"
    end

    @meal_statuses = MealStatus.find(:all, :conditions => ["user_id = ? OR matched_user_id IS NOT NULL", @user.id], :limit => 10, :order => "date")
  end

  #緊急欠食申請
  def view_list
    meal_type = Time.now.hour >= 10 || Time.now.hour <= 1 ? "Dinner" : "Breakfast"
    @meals = Meal.paginate(:all, :conditions => ["(date = ? AND meal_type = ?) OR (date > ? AND date < ?)", Date.today, meal_type, Date.today, Date.today + 4], :page => params[:page])
  end
  
  #通常欠食申請
  def menu
    @meals = Meal.paginate(:all, :conditions => ["(date >= ? AND date < ?)", Date.today + 4, Date.today + 30], page => params[:page])
  end

end
