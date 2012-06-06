class UserController < ApplicationController
  
  layout "site"
  
  def index
  end

  def register
    @user = User.new
  end
end
