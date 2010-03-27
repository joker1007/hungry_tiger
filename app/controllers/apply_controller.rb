class ApplyController < ApplicationController
  before_filter :user_check

  def reject_confirm
  end

  def sell_confirm
    @meal = Meal.find(params[:meal_id])
  end

  def sell
    @meal = Meal.find(params[:meal_id])
    @meal_status = @user.meal_statuses.new(:meal_id => @meal.id, :date => @meal.date, :meal_type => @meal.meal_type, :status => "sold")
    if @meal_status.save
      flash[:notice] = "#{@meal.date.strftime("%m/%d")} #{@meal.name}を欠食にしました"
      redirect_to :controller => "top", :action => "view_list", :keycode => @user.keycode
    else
      flash[:error] = "欠食申請が失敗しました"
      redirect_to :controller => "top", :action => "view_list", :keycode => @user.keycode
    end
  end

end
