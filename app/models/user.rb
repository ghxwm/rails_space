# encoding: utf-8
class User < ActiveRecord::Base
  self.table_name = "users"
  
  # attr_accessible :title, :body
  attr_accessible :screen_name,:email,:password,:remember_me
  attr_accessor :remember_me
  
  
  SCREEN_NAME_MIN_LENGTH = 4
  SCREEN_NAME_MAX_LENGTH = 20
  PASSWORD_MIN_LENGTH = 4
  PASSWORD_MAX_LENGTH = 40
  EMAIL_MAX_LENGTH = 50
  SCREEN_NAME_RANGE = SCREEN_NAME_MIN_LENGTH..SCREEN_NAME_MAX_LENGTH
  PASSWORD_RANGE = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH
  
  validates_uniqueness_of  :screen_name, :email
  validates_length_of      :screen_name, :within => SCREEN_NAME_RANGE
  validates_length_of      :password,    :within => PASSWORD_RANGE
  validates_length_of      :email,       :maximum => EMAIL_MAX_LENGTH
  validates_presence_of    :email
  
  validate :other_validate
  #注册验证操作
  def other_validate
    errors.add(:email,"格式不正确") unless email.include? "@"
    errors.add(:screen_name,"不能有空格") if screen_name.include? " "
  end
  
  #登录,记录session信息
  def login!(session)
    session[:user_id] = self.id
  end
  #注销,清除session和cookies中的相关信息
  def self.logout!(session,cookies)
    session[:user_id] = nil
    cookies.delete(:auth_token)  #auth_token可用于直接登录
  end
  #清空密码
  def clear_password!()
    self.password = nil  #不能使用@password，必须加self; 否则password视为局部变量
  end
  
  #记住用户,以便未来登录时使用
  def remember!(cookies)
    cookie_expiration = 7.days.from_now
   
    self.auth_token = unique_identifier #注意赋值语句
    save!
    cookies[:remember_me] = {:value => "1",:expires => cookie_expiration}
    cookies[:auth_token] = {:value => auth_token, :expires => cookie_expiration}
    
  end
  
  #如果用户希望网站记住其登录信息则返回true
  def remember_me?
    remember_me == "1" #注意赋值语句
  end
  
  #使网站忘记用户的登录状态信息
  def forget!(cookies)
    cookies.delete(:remember_me)
    cookies.delete(:auth_token)
  end
  
  private
  #生成唯一标识
  def unique_identifier
    Digest::SHA2.hexdigest("#{screen_name}:#{password}")
  end

end
