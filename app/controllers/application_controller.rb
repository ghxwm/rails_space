class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery
 
  #session :session_key => "_rails_space_session_id"
  
  before_filter :validate_login,:only => :about  #受保护的页面
  before_filter :check_authorization
  
  private
  #检测用户是否登录
  def validate_login
    unless logged_in?
      session[:protected_page] = request.fullpath #保存登录之前浏览的页面
      flash[:notice] = "请先登录"
      redirect_to :controller => "user",:action => "login"
      return false
    end
  end
  #检测用户是否使用cookie登录
  def check_authorization
    #puts "check_authorization..................."
    if cookies[:auth_token] and not session[:user_id]
      user = User.find_by_auth_token(cookies[:auth_token])
      user.login!(session) if user
    end
  end
  
end
