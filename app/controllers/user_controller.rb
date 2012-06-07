class UserController < ApplicationController
  
  layout "site"
  
  def index
  end

  def register
    @title = "Register"
    
    if request.post? and params[:user]
      #raise params[:user].inspect
      @user = User.new(params[:user])
      if @user.save
        flash[:notice] = "User #{@user.screen_name} created!"
        redirect_to(:action => index)
      else
        #render :text => @user.errors.full_messages;
      end
      
    end
  end
  
end
