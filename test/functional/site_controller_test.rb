require 'test_helper'

class SiteController; def rescure_action(e) raise e end;end

class SiteControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    title = assigns(:title)
    assert_equal "Welcome to RailsSpace",title
    assert_response :success
    assert_template :index
  end

  test "should get about" do
    get :about
    title = assigns(:title)
    assert_equal "About RailsSpace",title
    assert_response :success
    assert_template :about
  end

  test "should get help" do
    get :help
    title = assigns(:title)
    assert_equal "RailsSpace Help",title
    assert_response :success
    assert_template :help
  end

end
