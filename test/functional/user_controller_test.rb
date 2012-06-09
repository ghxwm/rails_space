require 'test_helper'

class UserControllerTest < ActionController::TestCase
  fixtures  :users
 
  def setup
    @valid_user = users(:valid_user)
    @invalid_user = users(:invalid_user)
  end
  
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get register" do
    get :register
    assert_response :success
    
    #测试表单和它所有的标签
    assert_tag "form",:attributes => {:action => "/user/register",:method => "post"}
    assert_tag "input",:attributes => {:name => "user[screen_name]",:type => "text"}
    assert_tag "input",:attributes => {:type => "submit",:value => "注册"}
  end

  def test_registratioin_success 
    post :register,:user => {:screen_name => "new_screen_name",:email => "valid@example.com",:password => "long_enough_password"}
    #测试用户的参数
    user = assigns(:user)
    assert_not_nil user
    #测试数据库中的新用户
    new_user = User.find_by_screen_name_and_password(user.screen_name,user.password)
    assert_equal new_user,user
    #测试flash变量和页面重定向
    assert_equal "User #{new_user.screen_name} created!",flash[:notice]
    assert_redirected_to :action => "index"
  end
  
  #测试一个有效的登录
  def test_login_success
    try_to_login @valid_user,:remember_me => "0"
    assert_not_nil session[:user_id]
    assert_equal @valid_user.id,session[:user_id]
    assert_response :redirect
    assert_redirected_to :action => "index"
    user = assigns(:user)
    assert user.remember_me != "1"
    assert_nil cookies[:remember_me]
    assert_nil cookies[:auth_token]
  end
  
  def test_login_success_with_remember_me
    try_to_login @valid_user,:remember_me => "1"
    test_time= Time.now
    assert_not_nil session[:user_id]
    assert_equal @valid_user.id,session[:user_id]
    assert_response :redirect
    assert_redirected_to :action => "index"
    #检查cookie和过期时间
    user = User.find(@valid_user.id)
    time_range = 100
    assert_equal "1",cookies["remember_me"]
    #assert_in_delta 7.days.from_now(test_time),cookies.expires["remember_me"],time_range
    #身份验证cookie
    assert_equal user.auth_token,cookies["auth_token"]
    #assert_in_delta 7.days.from_now(test_time),cookies["auth_token"].expires,time_range
  end
  
  private
  #尝试通过login操作完成登录
  def try_to_login(user,option={})
    user_hash = {:screen_name => user.screen_name,:password => user.password}
    user_hash.merge!(option)
    post :login,:user => user_hash
  end
end
