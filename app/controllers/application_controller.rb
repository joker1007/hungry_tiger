# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
 
  protected
  def user_check
    keycode = params[:keycode]
    @user = User.find_by_keycode(keycode)
    render(:text => "keycodeが不正です") and return unless @user
  end
 # filter_parameter_logging :password
end
