# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def reject_apply_link(eatable)
    if eatable == "eatable"
      link_to("欠食申請", :controller => "apply", :action => "reject_confirm")
    else eatable == "rejected"
      link_to("欠食取消", :controller => "apply", :action => "reject_cancel")
    end
  end

  def sell_apply_link(eatable)
    if eatable == "eatable"
      link_to("緊急欠食申請", :controller => "apply", :action => "sell_confirm")
    end
  end
end
