class ApplyController < ApplicationController
  before_filter :user_check

  def reject_confirm
  end

  def sell_confirm
    @meal = Meal.find(params[:meal_id])
  end

  def sell
    @meal = Meal.find(params[:meal_id])
    if @meal_status = @meal.meal_statuses.find_by_matched_user_id(@user.id)
      @meal_status.matched_user_id = nil
      if @meal_status.save
        flash[:notice] = "#{@meal.date.strftime("%m/%d")} #{@meal.name}を欠食にしました"
        redirect_to :controller => "top", :action => "view_list", :keycode => @user.keycode
      end
    else
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

  def buy_confirm
    @meal = Meal.find(params[:meal_id])
  end

  def buy
    @meal = Meal.find(params[:meal_id])
    @meal_status = @meal.meal_statuses.find(:first, :conditions => "status = 'sold' AND matched_user_id IS NULL")
    if @meal_status
      @meal_status.matched_user = @user
      if @meal_status.save
        flash[:notice] = "#{@meal.date.strftime("%m/%d")} #{@meal.name}をやっぱり食べることにしました"
        redirect_to :controller => "top", :action => "view_list", :keycode => @user.keycode
      else
        flash[:error] = "やっぱり食べたい申請が失敗しました"
        redirect_to :controller => "top", :action => "view_list", :keycode => @user.keycode
      end
    else
      flash[:error] = "余りがありません"
      redirect_to :controller => "top", :action => "index"
    end
  end

end
