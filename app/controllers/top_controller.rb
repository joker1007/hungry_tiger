class TopController < ApplicationController
  # keycodeから@userを取得するフィルター
  before_filter :user_check

  layout "mobile"

  def index
    # 10時から1時までは、夜メニューを表示する
    meal_type = Time.now.hour >= 10 || Time.now.hour <= 1 ? "Dinner" : "Breakfast"
    @meal = Meal.find(:first, :conditions => ["date = ? AND meal_type = ?", Date.today, meal_type])

    # ステータスによって、トップページのメッセージを変える
    @eatable = MealStatus.eatable?(@user.id, @meal.id)

    if @eatable == "eatable"
      @message = "#{@user.name}さんは本日お食事予定です"
    elsif @eatable == "re-eatable"
      @message = "#{@user.name}さんは本日やっぱり食べる予定です"
    elsif @eatable == "rejected"
      @message = "#{@user.name}さんは本日欠食のため食べられません"
    elsif @eatable == "sold"
      @message = "#{@user.name}さんは本日緊急欠食のため食べられません"
    end

    # やり取りのログを表示するために、ステータスレコードを取得
    @meal_statuses = MealStatus.find(:all, :conditions => ["(user_id = ? AND matched_user_id IS NOT NULL) OR (matched_user_id = ?)", @user.id, @user.id], :limit => 10, :order => "date")
  end

  #緊急欠食申請
  def view_list
    meal_type = Time.now.hour >= 10 || Time.now.hour <= 1 ? "Dinner" : "Breakfast"
    @meals = Meal.paginate(:all, :conditions => ["(date = ? AND meal_type = ?) OR (date > ? AND date < ?)", Date.today, meal_type, Date.today, Date.today + 4], :page => params[:page])
  end
  
  #通常欠食申請
  def menu
    @meals = Meal.paginate(:all, :conditions => ["(date >= ? AND date < ?)", Date.today + 4, Date.today + 30], :page => params[:page])
  end
  
  #欠食申請サブミット
  def apply
    meals = params[:meals]
    notice = ""
    
    meals.each do |key, value|
      meal = Meal.find(key)
      meal_status_tmp = @user.meal_statuses.find(:first, :conditions => { :meal_id => meal.id})
      if meal_status_tmp
        #すでに同一のuser_idとmeal_idを持つmeal_statusesが存在する場合、更新を行う
        meal_status = meal_status_tmp.update_attribute(:status, "rejected")
      else
        #同一のuser_idとmeal_idを持つmeal_statusesが存在しない場合
        meal_status = @user.meal_statuses.create(:meal_id => meal.id, :date => meal.date, :meal_type => meal.meal_type, :status => "rejected")
      end
      
      if meal_status
        notice += "#{meal.date.strftime("%m/%d")} #{meal.name}を欠食にしました<br>"
      else
        flash[:error] = "欠食申請が失敗しました"
        redirect_to :controller => "top", :action => "menu", :keycode => @user.keycode
      end
    end
    
    flash[:notice] = notice
    redirect_to :controller => "top", :action => "menu", :keycode => @user.keycode
  end
end
