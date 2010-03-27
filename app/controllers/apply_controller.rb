class ApplyController < ApplicationController
  before_filter :user_check

  def reject_confirm
  end

  def sell_confirm
    @meal = Meal.find(params[:meal_id])
  end

end
