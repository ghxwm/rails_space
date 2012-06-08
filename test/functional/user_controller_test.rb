require 'test_helper'

class UserControllerTest < ActionController::TestCase
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
    assert_tag "input",:attributes => {:type => "submit",:value => "Register!"}
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
  
end
