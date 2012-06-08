class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :validate_login,:only => :about  #受保护的页面
 
  
  private
  def validate_login
    unless logged_in?
      session[:protected_page] = request.fullpath #保存登录之前浏览的页面
      flash[:notice] = "请先登录"
      redirect_to :controller => "user",:action => "login"
      return false
    end
  end
end
