# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def reject_apply_link(user_id, meal_id)
    if MealStatus.eatable?(user_id, meal_id)
      link_to("欠食申請", :controller => "apply", :action => "reject_confirm", :keycode => @user.keycode, :meal_id => meal_id)
    else
      link_to("欠食取消", :controller => "apply", :action => "reject_cancel", :keycode => @user.keycode, :meal_id => meal_id)
    end
  end

  def sell_apply_link(user_id, meal_id)
    if MealStatus.eatable?(user_id, meal_id)
      link_to("緊急欠食申請", :controller => "apply", :action => "sell_confirm", :keycode => @user.keycode, :meal_id => meal_id)
    else
      link_to("余り", :controller => "apply", :action => "buy_confirm", :keycode => @user.keycode, :meal_id => meal_id)
    end
  end
end
