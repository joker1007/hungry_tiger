# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def reject_apply_link(user_id, meal_id)
    if MealStatus.eatable?(user_id, meal_id) == "eatable"
      link_to("欠食申請", :controller => "apply", :action => "reject_confirm", :keycode => @user.keycode, :meal_id => meal_id)
    else
      link_to("欠食取消", :controller => "apply", :action => "reject_cancel", :keycode => @user.keycode, :meal_id => meal_id)
    end
  end

  def sell_apply_link(user_id, meal_id)
    eatable_status = MealStatus.eatable?(user_id, meal_id)
    if eatable_status == "eatable" || eatable_status == "re-eatable"
      link_to("緊急欠食申請", :controller => "apply", :action => "sell_confirm", :keycode => @user.keycode, :meal_id => meal_id)
    else
      if (buyable_count = MealStatus.buyable_count(meal_id)) > 0
        link_to("やっぱり食べたい(#{buyable_count})", :controller => "apply", :action => "buy_confirm", :keycode => @user.keycode, :meal_id => meal_id)
      else
        "やっぱり食べたい(0)"
      end
    end
  end

  def trade_status(meal_status)
    if meal_status.user_id == @user.id
      opposite_user = meal_status.matched_user
      meal_status.date.strftime("%m/%d") + " 【譲渡】 #{opposite_user.room} #{opposite_user.name}"
    else
      opposite_user = meal_status.user
      meal_status.date.strftime("%m/%d") + " 【譲受】 #{opposite_user.room} #{opposite_user.name}"
    end
  end
end
