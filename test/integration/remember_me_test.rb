require "test_helper"

class RememberMeTest < ActionController::IntegrationTest
  include ApplicationHelper
  
  fixtures :users
  
  def setup
    @user = users(:valid_user)
  end
  
  #remember_me登录测试
  def test_remember_me
    #启用Remember Me功能时的登录
    post "user/login",:user => {:screen_name => @user.screen_name, :password => @user.password,:remember_me => "1" }
    assert_response :redirect
    #清除session中的用户id信息来模拟"关闭浏览器"操作
    @request.session[:user_id] = nil
    #任意访问一个页面
    get "site/index"
    #check_authorization和before_filter函数将完成用户登录操作
    assert logged_in?
    assert_equal @user.id,session[:user_id]
  end
  
end
