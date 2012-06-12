# encoding: utf-8
class UserController < ApplicationController
  include ApplicationHelper
  layout "site"
  
  #用户首页
  def index
    @titile = "个人中心"
    @user = User.find(session[:user_id])
  end
  #用户注册
  def register
    @title = "Register"
    
    if param_posted?(:user)
      #raise params[:user].inspect
      @user = User.new(params[:user])
      if @user.save  #注册成功
        @user.login(session)
        flash[:notice] = "User #{@user.screen_name} created!"
        redirect_to(:action => index)
      else  #失败,重新注册
        #render :text => @user.errors.full_messages;
        @user.clear_password!
      end
      
    end
  end
  
  #用户登录
  def login
    @title = "Login to RailsSpace"
    
    if request.get?
      @user = User.new(:remember_me => cookies[:remember_me] || "0")
    elsif param_posted?(:user)
      @user = User.new(params[:user])
      user = User.find_by_screen_name_and_password(@user.screen_name,@user.password)
      if user   #登录成功
        user.login!(session)
        flash[:notice] = "用户#{user.screen_name}登录成功!"
        @user.remember_me? ? user.remember!(cookies) : user.forget!(cookies)
        
        redirect_to_forward_url   #跳转到登录前的页面
      else  #失败,重新登录
        @user.clear_password!
        flash[:notice] = "无效的用户名或密码"
      end
    end #end first if
  end
  
  #注销
  def logout
    User.logout!(session,cookies)
    flash[:notice] = "注销成功"
    redirect_to :action => "index",:controller => "site"
  end
  
  private
  #判断注册和登录时是否post正确的用户信息参数
  def param_posted?(symbol)
    request.post? and params[symbol]
  end
  
  #重定向到保护页面
  def redirect_to_forward_url
    if (redirect_url = session[:protected_page])
          session[:protected_page] = nil
          redirect_to redirect_url
        else
          redirect_to :action => "index"
        end
  end
  
end
