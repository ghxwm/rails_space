require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures  :users
 
  def setup
    @valid_user = users(:valid_user)
    @invalid_user = users(:invalid_user)
  end
 
  #该用户是有效的
  def test_user_validity
    assert @valid_user.valid?
  end
  
  #该用户是无效的
  def test_user_invalidity
    assert !@invalid_user.valid?
    #puts @invalid_user.errors.inspect
    #用户的这些属性指是无效的
    attributes = [:screen_name,:email,:password]
    attributes.each do |attr|
      assert_equal @invalid_user.errors[attr].empty?,false
    end
  end
  
end
